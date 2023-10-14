import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
//
// class magoS2t extends StatefulWidget {
//   const magoS2t({super.key});
//
//   @override
//   State<magoS2t> createState() => _magoS2tState();
// }
//
// class _magoS2tState extends State<magoS2t> {
//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text('hello world'),
//     );
//   }
// }

class MagoSttApi {
  String apiUrl;
  String resultType = 'json';

  MagoSttApi(this.apiUrl);

  // 음성 인식 요청
  Future<void> uploadAndProcessAudio(Uint8List fileBytes) async {
    // 음성 파일 업로드
    try {
      // 파일 업로드
      String? id = await upload(fileBytes);
      //print('Uploaded with ID: $id');

      // upload에서 받아온 id를 넣어줌
      String? message = await batch(id!);
      //print('Batch Process: $message');

      // 결과 가져오기
      String? result = await getResult(id);
      //print('Result: $result');

    } catch (e) {
      //print('Error: $e');
    }
  }

  Future<String?> upload(Uint8List audioData) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$apiUrl/upload'))
        ..headers['accept'] = 'application/json'
        ..files.add(http.MultipartFile.fromBytes(
          'speech',
          audioData,
          filename: 'audio.wav',
          contentType: MediaType('audio', 'wav'),
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

  Future<String?> batch(String id) async {
    try {
      var request = await http.post(
        Uri.parse('$apiUrl/batch/$id'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: '{"lang": "ko"}',
      );

      if (request.statusCode == 200) {
        var responseBody = request.body;
        String? message = getResultFromJson(responseBody, 'batch');
        return message;
      } else {
        throw Exception('API request failed: ${request.statusCode}');
      }
    } catch (e) {
      print('Error in batch request: $e');
    }
    return null;
  }

  Future<String> getResult(String id) async {
    Completer<String> completer = Completer<String>();
    final List<String> result = [""];

    Timer.periodic(const Duration(milliseconds: 300), (timer) async {
      try {
        var response = await http.get(
            Uri.parse('$apiUrl/result/$id?result_type=$resultType'),
            headers: {'accept': 'application/json'});

        if (response.statusCode == 200) {
          var responseBody = utf8.decode(response.bodyBytes);
          result[0] = getResultFromJson(responseBody, 'result')!;
          if (result[0] != "") {
            timer.cancel();
            completer.complete(result[0]);
          }
        } else {
          throw Exception('API request failed: ${response.statusCode}');
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
    } else if (status == 'batch') {
      String message = jsonObject['message'];
      return message;
    } else if (status == 'result') {
      Map<String, dynamic> contentsObject = jsonObject['contents'];
      if (contentsObject.containsKey('results') == false) {
        return "";
      }
      Map<String, dynamic> resultsObject = contentsObject['results'];
      if (resultsObject.containsKey('utterances') == false) {
        return "";
      }
      String text = resultsObject['utterances'][0]['text'];
      return text;
    }
    return null;
  }
}

