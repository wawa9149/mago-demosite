import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:comet/result/sound_quality_graph_result.dart';
import 'package:comet/result/abm_progressbar_graph_result.dart';
import '../data/emo_chart_data.dart';
import '../data/animal_type_data.dart';

class EmotionsGraph extends StatefulWidget {
  final List<String?> result;
  final String animal;
  final List<double> abmResult;

  const EmotionsGraph({
    required this.result,
    required this.abmResult,
    required this.animal,
    Key? key,
  }) : super(key: key);

  @override
  EmotionsGraphState createState() => EmotionsGraphState();
}

class EmotionsGraphState extends State<EmotionsGraph> {
  late TooltipBehavior _tooltipBehavior;
  late List<ChartSampleData> _data;
  late String jsonData;
  List<AnimalType> animalList = [];

  @override
  void initState() {
    super.initState();
    jsonData = widget.result[2]!;
    _tooltipBehavior = TooltipBehavior(enable: true, format: 'point.x : point.y%');
    _data = <ChartSampleData>[
      ChartSampleData(x: '중립', y: getResultFromJson('NEUTRAL'), text: '100%', pointColor: const Color.fromRGBO(248, 177, 149, 1.0)),
      ChartSampleData(x: '화남', y: getResultFromJson('ANGRY'), text: '100%', pointColor: const Color.fromRGBO(246, 114, 128, 1.0)),
      ChartSampleData(x: '슬픔', y: getResultFromJson('SADNESS'), text: '100%', pointColor: const Color.fromRGBO(61, 205, 171, 1.0)),
      ChartSampleData(x: '행복', y: getResultFromJson('HAPPINESS'), text: '100%', pointColor: const Color.fromRGBO(1, 174, 190, 1.0)),
    ];
  }

  double getResultFromJson(String status) {
    List<dynamic> jsonObject = json.decode(jsonData);
    List<dynamic> nbest = jsonObject[0]['nbest'] ?? [];

    for (var entry in nbest) {
      if (entry['emotion'] == status) {
        return entry['score'] * 100;
      }
    }

    return 0;
  }

  String? animalType(String animal) {
    List<dynamic> jsonObject = json.decode(jsonData);
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
        return null;
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
    AnimalType? desiredAnimal;

    if (status == 'image') {
      for (AnimalType animal in animalList) {
        if (animal.animal == data) {
          desiredAnimal = animal;
          return animal.image;
        }
      }
    } else if (status == 'resultText') {
      for (AnimalType animal in animalList) {
        if (animal.animal == data) {
          desiredAnimal = animal;
          return animal.resultText;
        }
      }
    }

    if (desiredAnimal != null) {
      status == 'image' ? print('이미지: ${desiredAnimal.image}') : print('결과 텍스트: ${desiredAnimal.resultText}');
    } else {
      print('원하는 동물을 찾지 못했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 100),
        Text(
          '당신의 음성 유형은?',
          style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text(
          '"' + animalType(widget.animal)! + " " + widget.animal! + '" 입니다!',
          style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              child: Image.asset(
                selectData(animalType(widget.animal)! + " " + widget.animal, 'image')!,
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
                  textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                series: _getRadialBarDefaultSeries(),
                tooltipBehavior: _tooltipBehavior,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 50,
        ),
        SoundQualityGraph(result: widget.result),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Text(
                selectData("${animalType(widget.animal)!} ${widget.animal}", 'resultText')!,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
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
