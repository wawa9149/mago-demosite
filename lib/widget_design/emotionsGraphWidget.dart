import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RadialBarChartSample extends StatefulWidget {
  List<String?> result = [];

  RadialBarChartSample({required this.result, Key? key}) : super(key: key);

  @override
  RadialBarChartSampleState createState() => RadialBarChartSampleState();
}

class RadialBarChartSampleState extends State<RadialBarChartSample> {
  late TooltipBehavior _tooltipBehavior;
  late List<ChartSampleData> _data;
  late String? jsonData = widget.result[2];

  double? getResultFromJson(String status) {
    // JSON 문자열을 파싱하여 List<Map<String, dynamic>> 형태로 변환
    List<dynamic> jsonObject = json.decode(jsonData!);

    // 첫 번째 객체에 접근한 후 "nbest" 키를 사용하여 내부의 객체 배열에 접근
    List<dynamic> nbest = jsonObject[0]['nbest'];

    if (nbest != null) {
      // "nbest" 배열에서 "emotion" 값이 "ANGRY"인 객체를 찾음
      Map<String, dynamic>? emotion;
      for (var entry in nbest) {
        if (entry['emotion'] == status) {
          emotion = entry;
          break;
        }
      }
      if (emotion != null) {
        // "emotion"이 "ANGRY"인 객체가 존재할 경우 해당 객체를 사용할 수 있음
        double score = emotion['score'];
        print('Emotion: $status, Score: $score');
        return score * 100;
      } else {
        print('Emotion이 $status인 객체를 찾을 수 없습니다.');
        return 0;
      }
    } else {
      print('"nbest" 데이터를 찾을 수 없습니다.');
    }
  }

  String selectImage() {
    List<dynamic> jsonObject = json.decode(jsonData!);
    String text = jsonObject[0]['text'];

    if (text == 'NEUTRAL') {
      return 'assets/images/neutral_rabbit.jpeg';
    } else if (text == 'ANGRY') {
      return 'assets/images/angry_rabbit.jpeg';
    } else if (text == 'SADNESS') {
      return 'assets/images/sad_rabbit.jpeg';
    } else if (text == 'HAPPINESS') {
      return 'assets/images/happy_rabbit.jpeg';
    } else {
      return 'assets/images/neutral_rabbit.jpeg';
    }
  }

  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, format: 'point.x : point.y%');
    _data = <ChartSampleData>[
      ChartSampleData(
          x: 'Neutral',
          y: getResultFromJson('NEUTRAL')!,
          text: '100%',
          pointColor: const Color.fromRGBO(248, 177, 149, 1.0)),
      ChartSampleData(
          x: 'Angry',
          y: getResultFromJson('ANGRY')!,
          text: '100%',
          pointColor: const Color.fromRGBO(246, 114, 128, 1.0)),
      ChartSampleData(
          x: 'Sadness',
          y: getResultFromJson('SADNESS')!,
          text: '100%',
          pointColor: const Color.fromRGBO(61, 205, 171, 1.0)),
      ChartSampleData(
          x: 'Happiness',
          y: getResultFromJson('HAPPINESS')!,
          text: '100%',
          pointColor: const Color.fromRGBO(1, 174, 190, 1.0)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('당신의 음성 유형은?',
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
        SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              child: Image.asset(
                selectImage(),
              ),
            ),
            SizedBox(
              width: 50,
            ),
            Container(
              width: 400,
              height: 400,
              child: SfCircularChart(
                title: ChartTitle(text: 'Emotions'),
                series: _getRadialBarDefaultSeries(),
                tooltipBehavior: _tooltipBehavior,
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<RadialBarSeries<ChartSampleData, String>> _getRadialBarDefaultSeries() {
    return <RadialBarSeries<ChartSampleData, String>>[
      RadialBarSeries<ChartSampleData, String>(
        maximumValue: 100,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(fontSize: 15.0),
        ),
        dataSource: _data,
        cornerStyle: CornerStyle.bothCurve,
        gap: '5%',
        radius: '90%',
        xValueMapper: (ChartSampleData data, _) => data.x as String,
        yValueMapper: (ChartSampleData data, _) => data.y,
        pointRadiusMapper: (ChartSampleData data, _) => data.text,
        pointColorMapper: (ChartSampleData data, _) => data.pointColor,
        dataLabelMapper: (ChartSampleData data, _) => data.x as String,
      ),
    ];
  }
}

class ChartSampleData {
  ChartSampleData(
      {required this.x,
      required this.y,
      required this.text,
      required this.pointColor});

  final dynamic x;
  final double y;
  final String text;
  final Color pointColor;
}
