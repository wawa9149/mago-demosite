import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class MagoS2T {
  String apiUrl;

  String resultType = 'text';
  String key = 'eadc5d8d-ahno-9559-yesa-8c053e0f1f69';
  String? id;
  MagoS2T(this.apiUrl);

  // 음성 인식 요청
  Future<String?> uploadAndProcessAudio(
      Uint8List fileBytes, String audioFileName) async {
    // 음성 파일 업로드
    try {
      // 파일 업로드
      id = await upload(fileBytes, audioFileName);
      print('S2T Uploaded with ID: $id');

      // 결과 가져오기
      String? result = await getResult(id!);

      return result;
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  Future<String?> upload(Uint8List audioData, String fileName) async {
    //print('audioData: $audioData, fileName: $fileName');
    try {
      print('uploading...');
      var request = http.MultipartRequest('POST', Uri.parse('$apiUrl/upload'))
        ..headers['accept'] = 'application/json'
        ..headers['Bearer'] = key
        ..headers['Content-Type'] = 'multipart/form-data'
        ..files.add(http.MultipartFile.fromBytes(
          'speech',
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
      print('Error uploading file: $e');
    }
    return null;
  }

  Future<String> getResult(String id) async {
    Completer<String> completer = Completer<String>();

    Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      try {
        var response = await http.get(
            Uri.parse('$apiUrl/result/$id?result_type=$resultType'),
            headers: {
              'accept': 'application/json',
              'Bearer': key,
            });

        if (response.statusCode == 200) {
          // var utf16CodeUnits = response.bodyBytes.buffer.asUint16List();
          // var responseBody = String.fromCharCodes(utf16CodeUnits);
          // var responseBody = utf8.decode(response.bodyBytes);
          // var result = getResultFromJson(responseBody, 'result');
          String result = jsonEncode(response.bodyBytes);
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
      //print(contentsObject);
      if (contentsObject.containsKey('results') == false) {
        return null;
      }
      String result = json.encode(contentsObject['results']);
      print('S2T Result: $result');
      return result;
      //Map<String, dynamic> resultsObject = contentsObject['results'];
      // if (resultsObject.containsKey('text') == false) {
      //   return null;
      // }
      // String text = resultsObject['text'];
      // print('S2T Result: $text');
      //return text;
    }
    return null;
  }
}
