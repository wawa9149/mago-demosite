import 'dart:typed_data';

import 'package:comet/widget_design/mutipleAxes.dart';
import 'package:comet/widget_design/appBar.dart';
import 'package:comet/widget_design/barChart.dart';
import 'package:comet/widget_design/sparklineChart.dart';
import 'package:comet/widget_design/textResultBox.dart';
import 'package:flutter/material.dart';
import 'package:comet/api/mago_abm.dart';

import 'demo/graphWidget.dart';
import 'demo/imageResult.dart';

class ApiResultPage extends StatelessWidget {
  ApiResultPage({required this.result, Key? key}) : super(key: key);

  List<String?> result = [];

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
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.red, // 배경색
                ),
              )
              // const SizedBox(
              //   height: 100,
              // ),
              // GraphResult(
              //   result: result,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     RadialBarChartSample(),
              //     ColumnRounded(),
              //   ],
              // ),
              // MultipleAxesChart(),
              // SizedBox(
              //   height: 100,
              // ),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text('<음성 인식 결과>',
              //         style:
              //             TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              //     SizedBox(height: 20),
              //     TextResultBox(result[0] ?? 'N/A'),
              //     SizedBox(height: 50),
              //     Text('<Acoustic BioMarker 결과>',
              //         style:
              //             TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              //     SizedBox(height: 20),
              //     TextResultBox(result[1] ?? 'N/A'),
              //     SizedBox(height: 50),
              //     Text('<감정 인식 결과>',
              //         style:
              //             TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              //     SizedBox(height: 20),
              //     TextResultBox(result[2] ?? 'N/A'),
              //   ],
              // ),
              // const SizedBox(
              //   height: 50,
              // ),
              // ImageResult(id: result[3]),
              // const SizedBox(
              //   height: 50,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
