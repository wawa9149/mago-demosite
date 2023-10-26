import 'dart:html' as html;
import 'dart:html';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/services.dart';

import '../apiResultPage.dart';
import '../api/getApiResult.dart';
import '../widget_design/appBar.dart';

class ExampleDragTarget extends StatefulWidget {
  const ExampleDragTarget({Key? key}) : super(key: key);

  @override
  ExampleDragTargetState createState() => ExampleDragTargetState();
}

class ExampleDragTargetState extends State<ExampleDragTarget> {
  String showFileName = "";
  bool _dragging = false;

  late Uint8List audioFile = Uint8List(0);
  late String audioFilePath = '';
  late String audioFileName = '';
  bool _isUploading = false;

  ///FUNCTION UPLOAD the file to the storage
  Future<void> uploadFile(Uint8List data, String extension) async {
    ///Start uploading
    firebase_storage.Reference reference = firebase_storage
        .FirebaseStorage.instance
        .ref('docs/namefile.$extension');

    ///Show the status of the upload
    firebase_storage.TaskSnapshot uploadTask = await reference.putData(data);

    ///Get the download url of the file
    String url = await uploadTask.ref.getDownloadURL();

    if (uploadTask.state == firebase_storage.TaskState.success) {
      print('done');
      print('URL: $url');
    } else {
      print(uploadTask.state);
    }
  }

  // 드래그 영역
  Container makeDropZone() {
    // 드래그 중일 때와 아닐 때의 색상을 다르게 설정
    Color color =
        _dragging ? const Color.fromRGBO(71, 105, 31, 0.5) : Colors.grey[600]!;
    return Container(
      height: 380,
      width: 580,
      decoration: BoxDecoration(
        color: Colors.white, // 배경색
        borderRadius: BorderRadius.circular(20), // 테두리의 모서리를 둥글게 만듦
        boxShadow: const [
          BoxShadow(
            color: Colors.grey, // 그림자의 색상
            offset: Offset(0, 5), // 그림자의 위치 (가로, 세로)
            blurRadius: 10, // 그림자의 흐림 정도
            spreadRadius: 2, // 그림자의 확산 정도
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Drop Your ",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Text(
                "File(wav, aac, flac, ...)",
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Text(
                " Here",
                style: TextStyle(
                  color: color!,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          // InkWell은 클릭 시 효과를 줄 수 있는 위젯
          InkWell(
            //hoverColor: Colors.yellow[100],
            hoverColor: Color.fromRGBO(0, 0, 0, 0),
            splashColor: Colors.blue[300],
            //클릭 시 파일 선택
            // onTap: () async {
            //   FilePickerResult? result = await FilePicker.platform.pickFiles(
            //     type: FileType.custom,
            //     allowedExtensions: ['aac', 'mp3', 'wav', 'flac'],
            //   );
            //   if (result != null && result.files.isNotEmpty) {
            //     audioFileName = result.files.first.name;
            //     audioFile = result.files.first.bytes!;
            //    
            //     uploadFile(result.files.first.bytes!, result.files.first.extension!);
            //
            //     setState(() {
            //       showFileName = "Now File Name: $audioFileName";
            //     });
            //   }
            //},
            child: DottedBorder(
              dashPattern: [20, 15],
              strokeWidth: 3,
              strokeCap: StrokeCap.round,
              borderType: BorderType.RRect,
              color: Color.fromRGBO(71, 105, 31, 0.5),
              radius: Radius.circular(20),
              child: Container(
                width: 310,
                height: 210,
                child: ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['aac', 'mp3', 'wav', 'flac'],
                    );
                    if (result != null && result.files.isNotEmpty) {
                      audioFileName = result.files.first.name;
                      audioFile = result.files.first.bytes!;
                      print('실행');
                      uploadFile(result.files.first.bytes!, result.files.first.extension!);

                      setState(() {
                        showFileName = "Now File Name: $audioFileName";
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide.none,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/Icon_file.png",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "or Browse Files",
                        style: TextStyle(
                          color: Colors.grey[600]!,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            showFileName,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '음성 파일 업로드',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        // 드래그 영역
        DropTarget(
          onDragDone: (detail) async {
            debugPrint('onDragDone:');
            if (detail.files.isNotEmpty) {
              audioFileName = detail.files.first.name;
              audioFile = await detail.files.first.readAsBytes();
              setState(() {
                showFileName = "Now File Name: $audioFileName";
              });
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
        const SizedBox(
          height: 30,
        ),
        // 요청 버튼
        Container(
          width: 200,
          height: 50,
          child: audioFile.isNotEmpty
              // 버튼을 누르면 음성 인식 요청
              ? ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FutureBuilder<List<String?>>(
                          future: GetApiResult(audioFile, audioFileName)
                              .getApiResult(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // 로딩 중일 때 표시할 위젯 (로딩창)
                              return Center(child: LoadingPage());
                            } else if (snapshot.hasError) {
                              // 에러 발생 시 표시할 위젯
                              return Center(
                                  child: Text('에러 발생: ${snapshot.error}'));
                            } else if (snapshot.hasData) {
                              // 데이터를 받아왔을 때 표시할 위젯
                              return ApiResultPage(result: snapshot.data!);
                            } else {
                              // 다른 예외 상황 처리 (데이터가 없는 경우 등)
                              return Center(child: Text('예외 상황 처리'));
                            }
                          },
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(71, 105, 31, 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    '결과 확인',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              : Container(),
        ),
      ],
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ButtonStyle textButtonStyle = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      minimumSize: Size(120, 0),
      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
    );

    return Scaffold(
      appBar: AppBarMenu(textButtonStyle),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
