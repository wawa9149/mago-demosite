import 'package:comet/page/user_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../widget/file_drag_n_drop.dart';

class ExampleDragTarget extends StatefulWidget {
  const ExampleDragTarget({Key? key}) : super(key: key);

  @override
  ExampleDragTargetState createState() => ExampleDragTargetState();
}

class ExampleDragTargetState extends State<ExampleDragTarget> {
  late Uint8List audioFile = Uint8List(0);
  late String audioFileName = '';
  String showFileName = '';
  bool dragging = false;

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
          const SizedBox(height: 30),
          DropZoneWidget(
            audioFile: audioFile,
            audioFileName: audioFileName,
            onFileSelected: (Uint8List fileBytes, String fileName) {
              setState(() {
                showFileName = "Now File Name: $fileName";
                audioFile = fileBytes;
                audioFileName = fileName;
              });
            },
          ),
          const SizedBox(height: 30),
          RequestButtonWidget(
            audioFile: audioFile,
            audioFileName: audioFileName,
          ),
        ],
      ),
    );
  }
}

class RequestButtonWidget extends StatelessWidget {
  final Uint8List audioFile;
  final String audioFileName;

  const RequestButtonWidget({
    Key? key,
    required this.audioFile,
    required this.audioFileName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 50,
      child: audioFile.isNotEmpty
          ? ElevatedButton(
              onPressed: () {
                Get.to(SelectedGender(
                    audioFile: audioFile, audioFileName: audioFileName));
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
    );
  }
}
