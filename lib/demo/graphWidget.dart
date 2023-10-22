import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';

class Mygraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String jsonData = '''
      {
        "utterance_duration":3.257,
        "silence_duration_mean":2,
        "silence_duration_std":5
      }
    ''';

    Map<String, dynamic> data = json.decode(jsonData);

    return Padding(
          padding: EdgeInsets.all(16.0),
          child: PieChart(
            PieChartData(
              sectionsSpace: 10,
              centerSpaceRadius: 40,
              sections: [
                PieChartSectionData(
                  color: Colors.blue,
                  value: data['utterance_duration'],
                  title: '${data['utterance_duration']}',
                  radius: 50,
                  titleStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffffffff),
                  ),
                ),
                PieChartSectionData(
                  color: Colors.green,
                  value: data['silence_duration_mean'],
                  title: '${data['silence_duration_mean']}',
                  radius: 50,
                  titleStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffffffff),
                  ),
                ),
                PieChartSectionData(
                  color: Colors.yellow,
                  value: data['silence_duration_std'],
                  title: '${data['silence_duration_std']}',
                  radius: 50,
                  titleStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffffffff),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}