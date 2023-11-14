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
        emotionImage = 'assets/images/neutral_$animal.png';
        switch (animal){
          case 'snail': emotionResultText = '"평온한 달팽이"\n당신은 여유 있고 안정적인 목소리를 갖고 있네요.\n말투가 부드럽고, 느긋하며, 무엇이든지 차분하게 말하는 스타일이에요.\n크게 톤의 변화가 없고 없고 여유 있는 말투로 주변 사람들이 안정감을 느끼게 해요.';
          case 'cow': emotionResultText = '"평온한 소"\n당신은 느긋하고 깊은 목소리를 갖고 있네요.\n목소리에 약간의 떨림이 있지만 음역대가 낮고 여유있는 말투의 소유자입니다.\n';
          case 'swan': emotionResultText = '"평온한 수면 위의 백조"\n당신은 우아하고 안정적인 목소리를 갖고 있네요.\n목소리에 자신감이 넘치고, 높은 음역대로 뛰어난 전달력을 가지고 있어요.\n';
          case 'sheep': emotionResultText = '"평온한 들판 위의 양"\n당신은 느긋하고 명랑한 목소리를 갖고 있네요.\n목소리에 약간의 떨림이 있지만 음역대가 높고 여유있는 말투의 소유자입니다.';
          case 'lion': emotionResultText = '"여유롭게 낮잠 자는 사자"\n당신은 용맹하고 우렁찬 목소리를 가지고 있네요.\n목소리에 자신감이 넘치고, 모두가 알아들을 수 있는 정확한 발음의 소유자입니다. 담백한 저음이 매력적이네요.\n빠르고 올곧은 말투가 주변 사람들에게 신뢰를 주어, 무리에서 이끄는 역할을 하기 제격이에요.';
          case 'mole': emotionResultText = '"땅굴 속에서 낮잠 자는 두더지"\n당신은 목소리가 낮고 떨림이 있으며 말이 빠른편입니다.';
          case 'hamster': emotionResultText = '"빠르게 쳇바퀴를 굴리는 햄스터"\n당신은 목소리가 높고 안정감이 있으며 말이 빠른편입니다.';
          case 'bird': emotionResultText = '"종알종알 지저귀는 참새"\n당신은 목소리가 높고 떨림이 있으며 말이 빠른편입니다.';
        }
        break;
      case 'ANGRY':
        emotionPrefix = '뿔난';
        emotionImage = 'assets/images/angry_$animal.png';
        switch (animal){
          case 'snail': emotionResultText = '"뿔난 달팽이"\n당신은 여유 있고 안정적인 목소리를 갖고 있네요.\n말투가 부드럽고, 느긋하며, 무엇이든지 차분하게 말하는 스타일이에요.\n크게 톤의 변화가 없고 없고 여유 있는 말투로 주변 사람들이 안정감을 느끼게 해요.\n하지만 지금, 화난 당신의 감정을 알아차리기 힘들 수 있어요. 차분한 말투로 대화하되 상대방이 당신의 감정을 정확하게 이해할 수 있도록 전달하는 게 중요해요.';
          case 'cow': emotionResultText = '"씩씩거리는 소"\n당신은 느긋하고 깊은 목소리를 갖고 있네요.\n목소리에 약간의 떨림이 있지만 음역대가 낮고 여유있는 말투의 소유자입니다.\n';
          case 'swan': emotionResultText = '"날개를 퍼덕이는 백조"\n당신은 우아하고 안정적인 목소리를 갖고 있네요.\n목소리에 자신감이 넘치고, 높은 음역대로 뛰어난 전달력을 가지고 있어요.\n';
          case 'sheep': emotionResultText = '"뿔난 양"\n당신은 느긋하고 명랑한 목소리를 갖고 있네요.\n목소리에 약간의 떨림이 있지만 음역대가 높고 여유있는 말투의 소유자입니다.';
          case 'lion': emotionResultText = '"으르렁 거리는 사자"\n당신은 용맹하고 우렁찬 목소리를 가지고 있네요.\n목소리에 자신감이 넘치고, 모두가 알아들을 수 있는 정확한 발음의 소유자입니다. 담백한 저음이 매력적이네요.\n빠르고 올곧은 말투가 주변 사람들에게 신뢰를 주어, 무리에서 이끄는 역할을 하기 제격이에요.\n하지만 지금, 으르렁대는 당신을 누군가는 무서워할 수 있으니 차분하게 대화할 필요가 있어요.';
          case 'mole': emotionResultText = '"빠르게 굴을 파는 두더지"\n당신은 목소리가 낮고 떨림이 있으며 말이 빠른편입니다.';
          case 'hamster': emotionResultText = '"빠르게 쳇바퀴를 굴리는 햄스터"\n당신은 목소리가 높고 안정감이 있으며 말이 빠른편입니다.';
          case 'bird': emotionResultText = '"종알종알 지저귀는 참새"\n당신은 목소리가 높고 떨림이 있으며 말이 빠른편입니다.';
        }
        break;
      case 'SADNESS':
        emotionPrefix = '슬픈';
        emotionImage = 'assets/images/sad_$animal.png';
        switch (animal){
          case 'snail': emotionResultText = '"슬픈 달팽이"\n당신은 여유 있고 안정적인 목소리를 갖고 있네요.\n말투가 부드럽고, 느긋하며, 무엇이든지 차분하게 말하는 스타일이에요.\n크게 톤의 변화가 없고 없고 여유 있는 말투로 주변 사람들이 안정감을 느끼게 해요.\n하지만 지금, 슬픈 당신의 감정을 알아차리기 힘들 수 있어요. 차분한 말투로 대화하되 상대방이 당신의 감정을 정확하게 이해할 수 있도록 전달하는 게 중요해요.';
          case 'cow': emotionResultText = '"슬픈 소"\n당신은 느긋하고 깊은 목소리를 갖고 있네요.\n목소리에 약간의 떨림이 있지만 음역대가 낮고 여유있는 말투의 소유자입니다.';
          case 'swan': emotionResultText = '"슬픈 백조"\n당신은 우아하고 안정적인 목소리를 갖고 있네요.\n목소리에 자신감이 넘치고, 높은 음역대로 뛰어난 전달력을 가지고 있어요.\n';
          case 'sheep': emotionResultText = '"슬픈 양"\n당신은 느긋하고 명랑한 목소리를 갖고 있네요.\n목소리에 약간의 떨림이 있지만 음역대가 높고 여유있는 말투의 소유자입니다.';
          case 'lion': emotionResultText = '"슬픈 사자"\n당신은 용맹하고 우렁찬 목소리를 가지고 있네요.\n목소리에 자신감이 넘치고, 모두가 알아들을 수 있는 정확한 발음의 소유자입니다. 담백한 저음이 매력적이네요.\n빠르고 올곧은 말투가 주변 사람들에게 신뢰를 주어, 무리에서 이끄는 역할을 하기 제격이에요.';
          case 'mole': emotionResultText = '"슬픈 두더지"\n당신은 목소리가 낮고 떨림이 있으며 말이 빠른편입니다.';
          case 'hamster': emotionResultText = '"슬픈 햄스터"\n당신은 목소리가 높고 안정감이 있으며 말이 빠른편입니다.';
          case 'bird': emotionResultText = '"슬픈 참새"\n당신은 목소리가 높고 떨림이 있으며 말이 빠른편입니다.';
        }
        break;
      case 'HAPPINESS':
        emotionPrefix = '행복한';
        emotionImage = 'assets/images/happy_$animal.png';
        switch (animal){
          case 'snail': emotionResultText = '"행복한 달팽이"\n당신은 여유 있고 안정적인 목소리를 갖고 있네요.\n말투가 부드럽고, 느긋하며, 무엇이든지 차분하게 말하는 스타일이에요.\n크게 톤의 변화가 없고 없고 여유 있는 말투로 주변 사람들이 안정감을 느끼게 해요.\n차분한 말투로 대화하되 상대방이 당신의 감정을 정확하게 이해할 수 있도록 전달하는 게 중요해요.';
          case 'cow': emotionResultText = '"행복한 소"\n당신은 느긋하고 깊은 목소리를 갖고 있네요.\n목소리에 약간의 떨림이 있지만 음역대가 낮고 여유있는 말투의 소유자입니다.';
          case 'swan': emotionResultText = '"행복한 백조"\n당신은 우아하고 안정적인 목소리를 갖고 있네요.\n목소리에 자신감이 넘치고, 높은 음역대로 뛰어난 전달력을 가지고 있어요.\n';
          case 'sheep': emotionResultText = '"행복한 양"\n당신은 느긋하고 명랑한 목소리를 갖고 있네요.\n목소리에 약간의 떨림이 있지만 음역대가 높고 여유있는 말투의 소유자입니다.';
          case 'lion': emotionResultText = '"행복한 사자"\n당신은 용맹하고 우렁찬 목소리를 가지고 있네요.\n목소리에 자신감이 넘치고, 모두가 알아들을 수 있는 정확한 발음의 소유자입니다. 담백한 저음이 매력적이네요.\n빠르고 올곧은 말투가 주변 사람들에게 신뢰를 주어, 무리에서 이끄는 역할을 하기 제격이에요.';
          case 'mole': emotionResultText = '"행복한 두더지"\n당신은 목소리가 낮고 떨림이 있으며 말이 빠른편입니다.';
          case 'hamster': emotionResultText = '"행복한 햄스터"\n당신은 목소리가 높고 안정감이 있으며 말이 빠른편입니다.';
          case 'bird': emotionResultText = '"행복한 참새"\n당신은 목소리가 높고 떨림이 있으며 말이 빠른편입니다.';
        }
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

  String animalName(String animal){
    String name = '';
    switch (animal){
      case 'snail': name = '달팽이';
      case 'cow': name = '소';
      case 'swan': name = '백조';
      case 'sheep': name = '양';
      case 'lion': name = '사자';
      case 'mole': name = '두더지';
      case 'hamster': name = '햄스터';
      case 'bird': name = '새';
    }
    return name;
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
            style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        Text('"' + animalType(widget.animal)! + " " + animalName(widget.animal!) + '" 입니다!',
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
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
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                    selectData("${animalType(widget.animal)!} ${widget.animal}",
                        'resultText')!,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                ), // 결과 출력
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
