import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ExampleDragTarget extends StatefulWidget {
  const ExampleDragTarget({Key? key}) : super(key: key);

  @override
  _ExampleDragTargetState createState() => _ExampleDragTargetState();
}

class _ExampleDragTargetState extends State<ExampleDragTarget> {

  String showFileName = "";
  bool _dragging = false;
  var magoSttApi = MagoSttApi('http://saturn.mago52.com:9003/speech2text'); // API 객체
  late String? requestResult = '';
  late Uint8List audioFile = Uint8List(0);
  late String audioFileName = '';
  Color uploadingColor = Colors.blue[400]!;
  Color defaultColor = Colors.grey[400]!;

  Container makeDropZone(){
    Color color = _dragging ? uploadingColor : defaultColor;
    return Container(
      height: 300,
      width: 500,
      decoration: BoxDecoration(
        border: Border.all(width: 5, color: color,),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("Drop Your ", style: TextStyle(color: color, fontSize: 20,),),
              Text("Audio File", style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 20,),),
              Icon(Icons.insert_drive_file_rounded, color: color,),
              Text(" Here", style: TextStyle(color: color, fontSize: 20,),),
            ],
          ),
          // InkWell은 클릭 시 효과를 줄 수 있는 위젯
          InkWell(
            hoverColor: Colors.yellow[100],
            splashColor: Colors.blue[300],
            // 클릭 시 파일 선택
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['aac', 'mp3', 'wav'],
              );
              if( result != null && result.files.isNotEmpty ){
                audioFileName = result.files.first.name;
                audioFile = result.files.first.bytes!;
                setState(() {
                  showFileName = "Now File Name: $audioFileName";
                });
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("or ", style: TextStyle(color: color,),),
                Text("Find and Upload", style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 20,),
                ),
                Icon(Icons.upload_rounded, color: color,),
              ],
            ),
          ),
          Text("('.aac' or '.mp3' or '.wav')", style: TextStyle(color: color,),
          ),
          const SizedBox(height: 10,),
          Text(showFileName, style: const TextStyle(color: Colors.black,),
          ),
        ],
      ),
    );
  }

 Future<void> audioDataToBytes(Uint8List fileBytes, fileName) async {
    print('1');
    String? result = await magoSttApi.uploadAndProcessAudio(fileBytes, fileName);
    print('2');
    print(result);
    setState(() {
      if(result != null){
        requestResult = result;
      }
      else{
        requestResult = 'Error';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropTarget(
          onDragDone: (detail) async {
            debugPrint('onDragDone:');
            if( detail != null && detail.files.isNotEmpty ){
              audioFileName = detail.files.first.name;
              audioFile = await detail.files.first.readAsBytes();
              print(audioFileName);
              setState(() {
                showFileName = "Now File Name: $audioFileName";
              });
              /*
          do jobs
          */
            }
          },
          onDragEntered: (detail) {
            setState(() {
              debugPrint('onDragEntered:');
              _dragging = true;
            });
          },
          onDragExited: (detail) {
            debugPrint('onDragExited:');
            setState(() {
              _dragging = false;
            });
          },
          child: makeDropZone(),
        ),
        const SizedBox(height: 20,),
        audioFile.isNotEmpty
            ? ElevatedButton(onPressed: () => audioDataToBytes(audioFile, audioFileName), child: const Text('request'))
            : const Text('파일을 업로드 해주세요.'),
        const SizedBox(height: 20,),
        Container(
          height: 300,
          width: 500,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(width: 5, color: Colors.blue,),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: requestResult != ''
              ? Text(requestResult!)
              : const Text('결과 출력 전입니다.', ),
        )
      ],
    );
  }
}

class MagoSttApi {
  String apiUrl;
  String resultType = 'json';

  MagoSttApi(this.apiUrl);

  // 음성 인식 요청
  Future<String?> uploadAndProcessAudio(Uint8List fileBytes, String audioFileName) async {
    print('3');
    // 음성 파일 업로드
    try {
      print('4');
      // 파일 업로드
      String? id = await upload(fileBytes, audioFileName);
      print('Uploaded with ID: $id');

      // upload에서 받아온 id를 넣어줌
      String? message =  await batch(id!);
      print('Batch Process: $message');

      // 결과 가져오기
      String? result = await getResult(id);
      print('Result: $result');
      return result;

    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  Future<String?> upload(Uint8List audioData, String fileName) async {
    List<int> audioDataList = audioData.toList();
    print(fileName);
    print('6');
    try {
      print('7');
      var request = http.MultipartRequest('POST', Uri.parse('$apiUrl/upload'))
        ..headers['accept'] = 'application/json'
        ..files.add(http.MultipartFile.fromBytes(
          'speech',
          audioDataList,
          filename: fileName,
          contentType: MediaType('audio', 'wav'),
        ));

      var response = await request.send();
      print('response.statusCode: ${response.statusCode}');

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