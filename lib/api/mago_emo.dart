import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class MagoEMO {
  String apiUrl;
  String key = 'eadc5d8d-ahno-9559-yesa-8c053e0f1f69'; // 토큰 값 따로 빼기
  String? id;

  MagoEMO(this.apiUrl);

  // 음성 인식 요청
  Future<String?> uploadAndProcessAudio(
      Uint8List fileBytes, String audioFileName) async {
    // 음성 파일 업로드
    try {
      // 파일 업로드
      id = await upload(fileBytes, audioFileName);
      print('EMO Uploaded with ID: $id');

      // 결과 가져오기
      String? result = await getResult(id!);
      print(result);

      return result;
    } catch (e) {
      print('EMO Error: $e');
    }
    return null;
  }

  Future<String?> upload(Uint8List audioData, String fileName) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$apiUrl/upload'))
        ..headers['accept'] = 'application/json'
        ..headers['Bearer'] = key
        ..headers['Content-Type'] = 'multipart/form-data'
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          audioData,
          filename: fileName,
          contentType: MediaType('audio', 'flac'),
        ));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        String? id = getResultFromJson(responseBody, 'upload');
        return id;
      } else {
        print('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('EMO Error uploading file: $e');
    }
    return null;
  }

  Future<String> getResult(String id) async {
    Completer<String> completer = Completer<String>();
    // Results are not immediately available, so we poll the API until we get a result
    Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      if (timer.tick * 500 >= 30000) {
        // 30초 이상 경과하면 타이머를 취소하고 오류를 반환합니다.
        timer.cancel();
        completer.completeError(TimeoutException('Request timed out'));
      } else {
        try {
          var response = await http.get(
            Uri.parse('$apiUrl/result/$id'),
            headers: {
              'accept': 'application/json',
              'Bearer': key,
            },
          );

          print('EMO response.statusCode: ${response.statusCode}');
          if (response.statusCode == 200) {
            var responseBody = utf8.decode(response.bodyBytes);
            var result = getResultFromJson(responseBody, 'result');
            if (result != null) {
              timer.cancel();
              completer.complete(result);
            } else {
              print('No result yet');
            }
          }
        } catch (e) {
          completer.completeError(e);
        }
      }
    });

    return completer.future;
  }

  String? getResultFromJson(String jsonResponse, String status) {
    Map<String, dynamic> jsonObject = json.decode(jsonResponse);

    if (status == 'upload') {
      Map<String, dynamic> contentsObject = jsonObject['contents'];
      String id = contentsObject['id'];
      return id;
    } else if (status == 'result') {
      Map<String, dynamic> contentsObject = jsonObject['contents'];
      if (contentsObject.containsKey('results') == false) {
        return null;
      }
      Map<String, dynamic> resultsObject = contentsObject['results'];
      if (resultsObject.containsKey('utterances') == false) {
        return null;
      }
      String result = json.encode(resultsObject['utterances']);
      return result;
      // if (resultsObject.containsKey('utterances') == false) {
      //   return null;
      // }
      // String nbest = json.encode(resultsObject['utterances'][0]['nbest']);
      // return nbest;
    }
    return null;
  }
}