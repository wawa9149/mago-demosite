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

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, format: 'point.x : point.y%');
    _data = <ChartSampleData>[
      ChartSampleData(x: 'Neutral', y: 10, text: '100%', pointColor: const Color.fromRGBO(248, 177, 149, 1.0)),
      ChartSampleData(x: 'Angry', y: 11, text: '100%', pointColor: const Color.fromRGBO(246, 114, 128, 1.0)),
      ChartSampleData(x: 'Sadness', y: 12, text: '100%', pointColor: const Color.fromRGBO(61, 205, 171, 1.0)),
      ChartSampleData(x: 'Happiness', y: 13, text: '100%', pointColor: const Color.fromRGBO(1, 174, 190, 1.0)),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('당신의 음성 유형은?', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
        SizedBox(height: 50),
        Row(
mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              child: Image.asset(
                'assets/images/happy_rabbit.jpeg',
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
        maximumValue: 15,
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
  ChartSampleData({required this.x, required this.y, required this.text, required this.pointColor});
  final dynamic x;
  final double y;
  final String text;
  final Color pointColor;
}