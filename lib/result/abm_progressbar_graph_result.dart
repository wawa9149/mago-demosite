/// Flutter package imports
import 'dart:convert';

import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Renders the progress bar showcase sample.
class ProgressBar extends StatefulWidget {
  List<double?> result = [];
  //String gender = '';

  ProgressBar({required this.result, Key? key}) : super(key: key);

  @override
  ProgressBarState createState() => ProgressBarState();
}

/// State class of progress bar sample.
class ProgressBarState extends State<ProgressBar> {


  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        add('말의 속도', '느림', '빠름', widget.result[0]!),
        add('말의 빈도', '적음', '많음', widget.result[1]!),
        add('음성의 떨림', '적음', '많음', widget.result[2]!),
        add('음역대', '낮음', '높음', widget.result[3]!),
      ],
    );
  }
}

TextStyle _textStyle = const TextStyle(
    fontSize: 20, fontFamily: "NanumSquare_acB.ttf", color: Colors.black
);

SizedBox add(String feature, String less, String more, double data) {
  return SizedBox(
    height: 130,
    width: 800,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          feature,
          style: _textStyle,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              less,
              style: _textStyle,
            ),
            Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        height: 45,
                        width: 600,
                        child: SfLinearGauge(
                          showTicks: false,
                          showLabels: false,
                          animateAxis: true,
                          axisTrackStyle: LinearAxisTrackStyle(
                            thickness: 45,
                            edgeStyle: LinearEdgeStyle.bothCurve,
                            borderWidth: 1,
                            borderColor: Colors.grey[350],
                            color: Colors.grey[350],
                          ),
                          barPointers: <LinearBarPointer>[
                            LinearBarPointer(
                                value: data,
                                thickness: 45,
                                edgeStyle: LinearEdgeStyle.bothCurve,
                                color: Color.fromRGBO(49, 81, 63, 1)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(40, 30, 30, 30),
                    child: Text(
                      resultText(feature, data),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffFFFFFF)),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              more,
              style: _textStyle,
            ),
          ],
        ),
      ],
    ),
  );
}

String resultText(String status, double data){
  if(status == '말의 속도'){
    return data.toStringAsFixed(1) + '%';
  }
  else if(status == '말의 빈도'){
    return data.toStringAsFixed(1) + '%';
  }
  else if(status == '음성의 떨림'){
    return data.toStringAsFixed(1);
  }
  else if(status == '음역대'){
    return data.toStringAsFixed(1);
  }
  else{
    return '측정 불가';
  }
}
