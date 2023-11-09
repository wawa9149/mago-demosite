import 'dart:typed_data';

import 'package:comet/widget_design/barChart.dart';
import 'package:comet/widget_design/mutipleAxes.dart';
import 'package:comet/widget_design/appBar.dart';
import 'package:comet/widget_design/emotionsGraphWidget.dart';
import 'package:comet/widget_design/soundQualityGraphWidget.dart';
import 'package:comet/widget_design/textResultBox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'apiRequestPage.dart';
import 'demo/graphWidget.dart';
import 'demo/imageResult.dart';

class ApiResultPage extends StatelessWidget {
  ApiResultPage({required this.result, required this.audioSource, Key? key}) : super(key: key);

  List<String?> result = [];
  Uint8List audioSource = Uint8List(0);

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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            //AudioPlayerWidget(audioSource: audioSource,),
              const SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RadialBarChartSample(result: result,),
                  //ColumnRounded(),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              SoundQualityGraph(
                result: result,
              ),
              //MultipleAxesChart(),
              SizedBox(
                height: 100,
              ),
              ProgressBar(result: result),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('<음성 인식 결과>',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  TextResultBox(result[0] ?? 'N/A'),
                  SizedBox(height: 50),
                  Text('<Acoustic BioMarker 결과>',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  TextResultBox(result[1] ?? 'N/A'),
                  SizedBox(height: 50),
                  Text('<감정 인식 결과>',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  TextResultBox(result[2] ?? 'N/A'),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              ImageResult(id: result[3]),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Go Back'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(const ApiRequestPage());
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const ApiRequestPage()),
                  // );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(250, 65),
                  textStyle:
                  const TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                  foregroundColor: Color.fromRGBO(49, 81, 63, 1),
                  backgroundColor: Colors.white,
                  // 버튼 텍스트의 색상을 흰색으로 설정
                  shadowColor: Colors.black,
                  elevation: 10,
                  // 그림자의 깊이를 나타냄
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Get Started', // 표시할 텍스트
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'NEXONLv1GothicBold',
                      color: Color.fromRGBO(49, 81, 63, 1)), // 텍스트 스타일 조절
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
