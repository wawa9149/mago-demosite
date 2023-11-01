import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RadialBarChartSample extends StatefulWidget {
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
      ChartSampleData(x: 'John', y: 10, text: '100%', pointColor: const Color.fromRGBO(248, 177, 149, 1.0)),
      ChartSampleData(x: 'Almaida', y: 11, text: '100%', pointColor: const Color.fromRGBO(246, 114, 128, 1.0)),
      ChartSampleData(x: 'Don', y: 12, text: '100%', pointColor: const Color.fromRGBO(61, 205, 171, 1.0)),
      ChartSampleData(x: 'Tom', y: 13, text: '100%', pointColor: const Color.fromRGBO(1, 174, 190, 1.0)),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
        child: SfCircularChart(
          title: ChartTitle(text: 'Shot put distance'),
          series: _getRadialBarDefaultSeries(),
          tooltipBehavior: _tooltipBehavior,
        ),
    );
  }

  List<RadialBarSeries<ChartSampleData, String>> _getRadialBarDefaultSeries() {
    return <RadialBarSeries<ChartSampleData, String>>[
      RadialBarSeries<ChartSampleData, String>(
        maximumValue: 15,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(fontSize: 10.0),
        ),
        dataSource: _data,
        cornerStyle: CornerStyle.bothCurve,
        gap: '10%',
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