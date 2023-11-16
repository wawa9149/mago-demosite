import 'dart:developer';
import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';
import 'package:comet/api/api_result_parser.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class MagoABM {
  String apiUrl;
  String key; // 토큰 값 따로 파일로 빼기
  String? id;
  String resultType = 'all';

  MagoABM(this.apiUrl, this.key);

  // 음성 인식 요청
  Future<String?> uploadAndProcessAudio(
      Uint8List fileBytes, String audioFileName) async {
    // 음성 파일 업로드
    try {
      // 파일 업로드
      id = await upload(fileBytes, audioFileName);
      log('ABM Uploaded with ID: $id');

      // 결과 가져오기
      String? result = await getResult(id!);

      return result;
    } catch (e) {
      log('ABM Error: $e');
    }
    return null;
  }

  Future<Uint8List?> plotRequest(String featureName, String plotId) async {
    log(featureName);
    log('plotId: $plotId');
    Uint8List? result = await plot(plotId, featureName);

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
        String? id = ApiResultParser.getResultFromJson('abm', responseBody, 'upload');
        return id;
      } else {
        log('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      log('ABM Error uploading file: $e');
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
            Uri.parse('$apiUrl/result/$id?result_type=$resultType'),
            headers: {
              'accept': 'application/json',
              'Bearer': key,
            },
          );

          log('ABM response.statusCode: ${response.statusCode}');
          if (response.statusCode == 200) {
            var responseBody = utf8.decode(response.bodyBytes);
            String? result = ApiResultParser.getResultFromJson('abm', responseBody, 'result');
            if(result != null) {
              timer.cancel();
              completer.complete(result);
            } else {
              log('No result yet');
            }
          }
        } catch (e) {
          completer.completeError(e);
        }
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
      log('Plot failed with status: ${response.statusCode}');
    }
    return null;
  }
}
