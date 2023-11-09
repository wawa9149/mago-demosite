import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';
import 'package:comet/demo/imageResult.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:comet/demo/imageResult.dart';

class MagoABM {
  String apiUrl;
  String key = 'eadc5d8d-ahno-9559-yesa-8c053e0f1f69'; // 토큰 값 따로 파일로 빼기
  String? id;
  String resultType = 'all';

  MagoABM(this.apiUrl);

  // 음성 인식 요청
  Future<String?> uploadAndProcessAudio(
      Uint8List fileBytes, String audioFileName) async {
    // 음성 파일 업로드
    try {
      // 파일 업로드
      id = await upload(fileBytes, audioFileName);
      print('ABM Uploaded with ID: $id');

      // 결과 가져오기
      String? result = await getResult(id!);

      return result;
    } catch (e) {
      print('ABM Error: $e');
    }
    return null;
  }

  Future<Uint8List?> plotRequest(String featureName, String plotId) async {
    print(featureName);
    print('plotId: $plotId');
    Uint8List? result = await plot(plotId!, featureName);

    return result;
  }

  String? getId() {
    return id;
  }

  Future<String?> upload(Uint8List audioData, String fileName) async {
    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '$apiUrl/upload?task=ABM&readable=false&with_sequence=false&with_feats=true&plot_features=true'))
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
      print('ABM Error uploading file: $e');
    }
    return null;
  }

  Future<String> getResult(String id) async {
    Completer<String> completer = Completer<String>();
    // Results are not immediately available, so we poll the API until we get a result
    Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      try {
        var response = await http.get(
            Uri.parse('$apiUrl/result/$id?result_type=$resultType'),
            headers: {
              'accept': 'application/json',
              'Bearer': key,
            });

        print('ABM response.statusCode: ${response.statusCode}');
        if (response.statusCode == 200) {
          var responseBody = utf8.decode(response.bodyBytes);
          String? result = getResultFromJson(responseBody, 'result');
          if (result != null) {
            timer.cancel();
            print(result);
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

  Future<Uint8List?> plot(String id, String featureName) async {
    var response = await http
        .get(Uri.parse('$apiUrl/plot/$id?feature_name=$featureName'), headers: {
      'accept': 'application/json',
      'Bearer': key,
    });

    if (response.statusCode == 200) {
      return response.bodyBytes; // 이미지 바이트 데이터를 직접 사용
    } else {
      print('Plot failed with status: ${response.statusCode}');
    }
    return null;
  }

  String? getResultFromJson(String jsonResponse, String status) {
    Map<String, dynamic> jsonObject = json.decode(jsonResponse);

    // status에 따라서 다른 결과를 반환
    if (status == 'upload') {
      Map<String, dynamic> contentsObject = jsonObject['contents'];
      String id = contentsObject['id'];
      return id;
    } else if (status == 'result') {
      try {
        Map<String, dynamic> contentsObject = jsonObject['contents'];
        //print('ABM contentsObject: ok');
        if (contentsObject.containsKey('results')) {
          Map<String, dynamic> results = contentsObject['results'];
          //print('ABM results: ok');
          if (results.containsKey('biomarkers') &&
              results['biomarkers'] is Map<String, dynamic>) {
            //print('ABM biomarkers: ok');
            String contentsJsonString = json.encode(results['biomarkers']);
            //print('ABM contentsJsonString: $contentsJsonString');
            return contentsJsonString;
          } else {
            String message = 'Failed to get biomarkers';
            return message;
          }
        } else if(contentsObject.containsKey('detail')){
          String message = '실패';
          return message;
        } else {
          return null;
        }
      } catch (e) {
        print('Error parsing result: $e');
        return null;
      }
    }
    return null;
  }
}