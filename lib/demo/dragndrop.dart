import 'dart:developer';

//import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Drop Your ",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NEXONLv1GothicBold',
                  fontSize: 25,
                ),
              ),
              Text(
                "File(wav, aac, flac, ...)",
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NEXONLv1GothicBold',
                  fontSize: 25,
                ),
              ),
              Text(
                " Here",
                style: TextStyle(
                  color: color!,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NEXONLv1GothicBold',
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
                      log('실행');
                      //uploadFile(result.files.first.bytes!, result.files.first.extension!);

                      setState(() {
                        showFileName = "Now File Name: $audioFileName";
                        log('file');
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
                          fontFamily: 'NEXONLv1GothicBold',
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

  void showInvalidFileAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid File'),
          content: Text('Only audio files (mp3, wav, flac) are allowed.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '음성 파일 업로드',
            style: TextStyle(
              fontFamily: 'NanumSquare_EB',
              fontWeight: FontWeight.bold,
              fontSize: 40,
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
                //audioFile = await detail.files.first.readAsBytes();
                // 파일의 확장자 확인
                if (isAllowedFileExtension(audioFileName)) {
                  Uint8List fileBytes = await detail.files.first.readAsBytes();
                  setState(() {
                    showFileName = "Now File Name: $audioFileName";
                    audioFile = fileBytes;
                  });
                } else {
                  debugPrint('Invalid file extension. File not processed.');
                  showInvalidFileAlert();
                }
                // setState(() {
                //   showFileName = "Now File Name: $audioFileName";
                // });
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
                //버튼을 누르면 음성 인식 요청
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
                                // 성별 선택 버튼
                                return Container(
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      alignment: Alignment.bottomCenter,
                                      image: AssetImage(
                                          'assets/images/background_file.png'), // 배경 이미지
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const DefaultTextStyle(
                                        style: TextStyle(
                                            fontSize: 45,
                                            fontWeight: FontWeight.bold,
                                            ),
                                        child: Text('당신의 음성 유형은?'),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      const DefaultTextStyle(
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            ),
                                        child: Text('성별을 선택하시면 결과 페이지로 이동합니다.'),
                                      ),
                                      const SizedBox(
                                        height: 80,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Get.to(ApiResultPage(
                                                  result: snapshot.data!,
                                                  audioSource: audioFile,
                                                  gender: '남'));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: Size(100, 80),
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      71, 105, 31, 0.5),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const Text(
                                              '남',
                                              style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 100,
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Get.to(ApiResultPage(
                                                  result: snapshot.data!,
                                                  audioSource: audioFile,
                                                  gender: '여'));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: Size(100, 80),
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      71, 105, 31, 0.5),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const Text(
                                              '여',
                                              style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                                // 데이터를 받아왔을 때 표시할 위젯
                                // 결과 받아오기 버튼과 함께 버튼 입력하면 결과 페이지로 이동
                                //Get.to(ApiResultPage(result: snapshot.data!, audioSource: audioFile));
                                // return ApiResultPage(
                                //   result: snapshot.data!,
                                //   audioSource: audioFile,
                                // );
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
                        color: Colors.white,
                      ),
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  bool isAllowedFileExtension(String fileName) {
    List<String> allowedExtensions = ['mp3', 'wav', 'flac']; // 허용되는 확장자 목록
    String extension = fileName.split('.').last.toLowerCase();
    return allowedExtensions.contains(extension);
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
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
    );

    return Scaffold(
      appBar: AppBarMenu(textButtonStyle),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
            image: AssetImage('assets/images/background_file.png'), // 배경 이미지
          ),
        ),
        child: Center(
          child: SpinKitWave(
            color: Color.fromRGBO(71, 105, 31, 0.5), // 로딩 색상 설정
            size: 80.0, // 로딩 크기 설정
          ),
        ),
      ),
    );
  }
}
