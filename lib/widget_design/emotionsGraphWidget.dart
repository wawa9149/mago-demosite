import 'dart:convert';

import 'package:comet/widget_design/progressBarWidget.dart';
import 'package:comet/widget_design/soundQualityGraphWidget.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class EmotionsGraph extends StatefulWidget {
  List<String?> result = [];
  String animal = '';
  List<double> abmResult = [];

  EmotionsGraph(
      {required this.result,
      required this.abmResult,
      required this.animal,
      Key? key})
      : super(key: key);

  @override
  EmotionsGraphState createState() => EmotionsGraphState();
}

class EmotionsGraphState extends State<EmotionsGraph> {
  late TooltipBehavior _tooltipBehavior;
  late List<ChartSampleData> _data;
  late String? jsonData = widget.result[2];
  List<AnimalType> animalList = [];

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

  String? animalType(String animal) {
    List<dynamic> jsonObject = json.decode(jsonData!);
    String text = jsonObject[0]['text'];

    String emotionPrefix = '';
    String emotionImage = '';
    String emotionResultText = '';

    switch (text) {
      case 'NEUTRAL':
        emotionPrefix = '평온한';
        emotionImage = 'assets/images/neutral_rabbit.jpeg';
        emotionResultText = '결과 텍스트';
        break;
      case 'ANGRY':
        emotionPrefix = '뿔난';
        emotionImage = 'assets/images/angry_rabbit.jpeg';
        emotionResultText = '결과 텍스트';
        break;
      case 'SADNESS':
        emotionPrefix = '슬픈';
        emotionImage = 'assets/images/sad_rabbit.jpeg';
        emotionResultText = '결과 텍스트';
        break;
      case 'HAPPINESS':
        emotionPrefix = '행복한';
        emotionImage = 'assets/images/happy_rabbit.jpeg';
        emotionResultText = '결과 텍스트';
        break;
      default:
        return null; // 처리하지 않은 감정인 경우 null 반환 또는 예외 처리 추가
    }

    if (animal.isNotEmpty) {
      animalList.add(AnimalType(
        animal: '$emotionPrefix $animal',
        image: emotionImage,
        resultText: emotionResultText,
      ));
    }

    return emotionPrefix;
  }

  String? selectData(String data, String status) {
    // 원하는 객체를 찾아서 image 속성 가져오기
    String? value;
    AnimalType? desiredAnimal;

    print(data);
    if (status == 'image') {
      for (AnimalType animal in animalList) {
        if (animal.animal == data) {
          desiredAnimal = animal;
          value = animal.image;
          return value;
        }
      }
    } else if (status == 'resultText') {
      for (AnimalType animal in animalList) {
        if (animal.animal == data) {
          desiredAnimal = animal;
          value = animal.resultText;
          return value;
        }
      }
    }

// 원하는 객체가 있다면 image 속성 출력
    if (desiredAnimal != null) {
      status == 'image' ? print('이미지: $value') : print('결과 텍스트: $value');
    } else {
      print('원하는 동물을 찾지 못했습니다.');
    }
  }

  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, format: 'point.x : point.y%');
    _data = <ChartSampleData>[
      ChartSampleData(
          x: '중립',
          y: getResultFromJson('NEUTRAL')!,
          text: '100%',
          pointColor: const Color.fromRGBO(248, 177, 149, 1.0)),
      ChartSampleData(
          x: '화남',
          y: getResultFromJson('ANGRY')!,
          text: '100%',
          pointColor: const Color.fromRGBO(246, 114, 128, 1.0)),
      ChartSampleData(
          x: '슬픔',
          y: getResultFromJson('SADNESS')!,
          text: '100%',
          pointColor: const Color.fromRGBO(61, 205, 171, 1.0)),
      ChartSampleData(
          x: '행복',
          y: getResultFromJson('HAPPINESS')!,
          text: '100%',
          pointColor: const Color.fromRGBO(1, 174, 190, 1.0)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 100),
        Text('당신의 음성 유형은?',
            style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        Text('"' + animalType(widget.animal)! + " " + widget.animal! + '" 입니다!',
            style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
        SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              child: Image.asset(
                selectData(
                    animalType(widget.animal)! + " " + widget.animal, 'image')!,
              ),
            ),
            SizedBox(
              width: 50,
            ),
            Container(
              width: 400,
              height: 400,
              child: SfCircularChart(
                title: ChartTitle(
                    text: '감정 결과',
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                series: _getRadialBarDefaultSeries(),
                tooltipBehavior: _tooltipBehavior,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 50,
        ),
        SoundQualityGraph(
          result: widget.result,
        ),
        const SizedBox(
          height: 50,
        ),
        ProgressBar(result: widget.abmResult),
        const SizedBox(
          height: 50,
        ),
        Container(
          height: 250,
          width: 800,
          padding: EdgeInsets.all(16.0),
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
          child: SingleChildScrollView(
            // 스크롤 가능
            child: Center(
              child: Text(
                  selectData("${animalType(widget.animal)!} ${widget.animal}",
                      'resultText')!,
                  style: const TextStyle(
                    fontSize: 20,
                  )), // 결과 출력
            ),
          ),
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

class AnimalType {
  AnimalType(
      {required this.animal, required this.image, required this.resultText});

  String animal;
  String image;
  String resultText;
}
