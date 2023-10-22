import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:async';
import 'package:comet/demo/mago_s2t.dart';
import 'package:comet/demo/mago_abm.dart';

import '../apiResultPage.dart';
import 'mago_emo.dart';

class ExampleDragTarget extends StatefulWidget {
  const ExampleDragTarget({Key? key}) : super(key: key);

  @override
  ExampleDragTargetState createState() => ExampleDragTargetState();
}

//
const List<Widget> featureName = <Widget>[
  Text('Pitch'),
  Text('MFCC'),
  Text('Spectrogram'),
  Text('MelSpectrogram'),
  Text('SpectralCentroid')
];

class ExampleDragTargetState extends State<ExampleDragTarget> {
  String showFileName = "";
  bool _dragging = false;
  var magoSttApi =
      MagoSttApi('http://saturn.mago52.com:9003/speech2text'); // API 객체
  var magoABM = MagoABM('http://saturn.mago52.com:9104/abm'); // API 객체
  var magoEMO = MagoEMO('http://saturn.mago52.com:9105/emo'); // API 객체
  late String? s2tRequestResult = '';
  late String? abmRequestResult = '';
  late String? emoRequestResult = '';
  late Uint8List audioFile = Uint8List(0);
  late String audioFileName = '';
  final List<bool> _selectedFeatures = <bool>[true, false, false, false, false];
  final List<String> features = <String>[
    'Pitch',
    'MFCC',
    'Spectrogram',
    'MelSpectrogram',
    'SpectralCentroid'
  ];

  // 드래그 영역
  Container makeDropZone() {
    // 드래그 중일 때와 아닐 때의 색상을 다르게 설정
    Color color = _dragging ? Colors.blue[400]! : Colors.grey[400]!;
    return Container(
      height: 300,
      width: 500,
      decoration: BoxDecoration(
        border: Border.all(
          width: 5,
          color: color,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Drop Your ",
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                ),
              ),
              Text(
                "Audio File",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 20,
                ),
              ),
              Icon(
                Icons.insert_drive_file_rounded,
                color: color,
              ),
              Text(
                " Here",
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          // InkWell은 클릭 시 효과를 줄 수 있는 위젯
          InkWell(
            //hoverColor: Colors.yellow[100],
            hoverColor: Color.fromRGBO(0, 0, 0, 0),
            splashColor: Colors.blue[300],
            // 클릭 시 파일 선택
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['aac', 'mp3', 'wav', 'flac'],
              );
              if (result != null && result.files.isNotEmpty) {
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
                Text(
                  "or ",
                  style: TextStyle(
                    color: color,
                  ),
                ),
                Text(
                  "Find and Upload",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 20,
                  ),
                ),
                Icon(
                  Icons.upload_rounded,
                  color: color,
                ),
              ],
            ),
          ),
          Text(
            "('.aac' or '.mp3' or '.wav')",
            style: TextStyle(
              color: color,
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

  // API 요청
  Future<void> getApiResult(Uint8List fileBytes, fileName) async {
    String? s2tResult =
        await magoSttApi.uploadAndProcessAudio(fileBytes, fileName);
    String? abmResult =
        await magoABM.uploadAndProcessAudio(fileBytes, fileName);
    String? emoResult =
        await magoEMO.uploadAndProcessAudio(fileBytes, fileName);

    setState(() {
      // 결과가 있으면 결과를, 없으면 에러를 출력
      if (s2tResult != "" && abmResult != "") {
        s2tRequestResult = s2tResult;
        abmRequestResult = abmResult;
        emoRequestResult = emoResult;
      } else {
        s2tRequestResult = 'error';
        abmRequestResult = 'error';
        emoRequestResult = 'error';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
          height: 50,
        ),
        // 요청 버튼
        audioFile.isNotEmpty
            // 버튼을 누르면 음성 인식 요청
            ? ElevatedButton(
                onPressed: () async {
                  await getApiResult(audioFile, audioFileName);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ApiResultPage()),
                  );
                },
                child: const Text('request'))
            : const Text('파일을 업로드 해주세요.'),
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              width: 300,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 5,
                  color: Colors.blue,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                  // 스크롤 가능
                  child: Center(child: Text(s2tRequestResult!)) // 결과 출력
                  ),
            ),
            SizedBox(width: 20),
            Container(
              height: 300,
              width: 300,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 5,
                  color: Colors.blue,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                  // 스크롤 가능
                  child: Text(abmRequestResult!) // 결과 출력
                  ),
            ),
            SizedBox(width: 20),
            Container(
              height: 300,
              width: 300,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 5,
                  color: Colors.blue,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                  // 스크롤 가능
                  child: Text(emoRequestResult!) // 결과 출력
                  ),
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        // ToggleButtons with a single selection.
        Text('< 원하시는 이미지를 선택해주세요 >', style: theme.textTheme.titleSmall),
        const SizedBox(height: 20),
        ToggleButtons(
          //direction: vertical ? Axis.vertical : Axis.horizontal,
          onPressed: (int index) {
            setState(() {
              // The button that is tapped is set to true, and the others to false.
              for (int i = 0; i < _selectedFeatures.length; i++) {
                _selectedFeatures[i] = i == index;
              }
            });
          },
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          selectedBorderColor: Colors.red[700],
          selectedColor: Colors.white,
          fillColor: Colors.red[200],
          color: Colors.red[400],
          constraints: const BoxConstraints(
            minHeight: 40.0,
            minWidth: 130.0,
          ),
          isSelected: _selectedFeatures,
          children: featureName,
        ),
        const SizedBox(height: 50),
        Container(
          height: 400,
          width: 1000,
          alignment: Alignment.center,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(
              width: 5,
              color: Colors.blue,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: FutureBuilder<Uint8List?>(
            future: magoABM.plotRequest(
                features[_selectedFeatures.indexOf(true)].toString()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('이미지 결과 창');
              } else if (snapshot.hasData) {
                return Image.memory(
                  snapshot.data!,
                  width: 1000, // 이미지의 폭을 조절할 수 있습니다.
                  height: 400, // 이미지의 높이를 조절할 수 있습니다.
                );
              } else {
                return Text('No image data');
              }
            },
          ),
        ),
      ],
    );
  }
}
