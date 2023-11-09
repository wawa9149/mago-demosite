/// Flutter package imports
import 'dart:convert';

import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Renders the progress bar showcase sample.
class ProgressBar extends StatefulWidget {
  List<String?> result = [];

  ProgressBar({required this.result, Key? key}) : super(key: key);

  @override
  ProgressBarState createState() => ProgressBarState();
}

/// State class of progress bar sample.
class ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    String? jsonData = widget.result[1];
    String scaledRMSString = '0.0';
    String scaledSNRString = '0.0';
    const double progressvalue = 41.467;

    double? getResultFromJson(String status) {
      Map<String, dynamic> jsonObject = json.decode(jsonData!);

      // status에 따라서 다른 결과를 반환
      if (status == 'rms') {
        Map<String, dynamic> contentsObject = jsonObject['energy'];
        print(contentsObject);
        print('ABM energy: ok');
        double scaledRMS = (contentsObject['rms']);

        // 소수점 1자리까지 나타내는 문자열로 변환
        scaledRMSString = scaledRMS.toStringAsFixed(2);

        // 다시 double로 파싱
        double rms = double.parse(scaledRMSString);

        if (rms >= 0.3) {
          rms = 0.3;
        } else if (rms <= 0.1) {
          rms = 0.1;
        }

        print('Scaled RMS 값 (1자리까지): $rms');
        return rms;
      } else if (status == 'snr') {
        Map<String, dynamic> contentsObject = jsonObject['energy'];
        print(contentsObject);
        print('ABM energy: ok');
        double scaledSNR = contentsObject['snr'];

        // 소수점 1자리까지 나타내는 문자열로 변환
        scaledSNRString = scaledSNR.toStringAsFixed(1);

        // 다시 double로 파싱
        double snr = double.parse(scaledSNRString);

        if (snr >= 30) {
          snr = 30;
        } else if (snr <= -5) {
          snr = -5;
        }

        print('Scaled SNR 값 (1자리까지): $snr');
        return snr;
      } else if (status == 'shimmer') {
        Map<String, dynamic> contentsObject = jsonObject['energy'];
        print(contentsObject);
        print('ABM energy: ok');
        double scaledSNR = contentsObject['snr'];

        // 소수점 1자리까지 나타내는 문자열로 변환
        scaledSNRString = scaledSNR.toStringAsFixed(1);

        // 다시 double로 파싱
        double snr = double.parse(scaledSNRString);

        print('Scaled RMS 값 (1자리까지): $snr');
        return snr;
      }
      return null;
    }

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: SizedBox(
            height: 60,
            width: 500,
            child: SfLinearGauge(
              showTicks: false,
              showLabels: false,
              animateAxis: true,
              axisTrackStyle: LinearAxisTrackStyle(
                thickness: 30,
                edgeStyle: LinearEdgeStyle.bothCurve,
                borderWidth: 1,
                borderColor: Colors.white,
              ),
              barPointers: <LinearBarPointer>[
                LinearBarPointer(
                  value: progressvalue,
                  thickness: 30,
                  edgeStyle: LinearEdgeStyle.bothCurve,
                  color: Colors.blue,
                  position: LinearElementPosition.outside, // LinearElementPosition 열거형 사용
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Text(
              progressvalue.toStringAsFixed(2) + '%',
              style: TextStyle(fontSize: 14, color: Color(0xff000000)),
            ),
          ),
        ),
      ],
    );
  }
}
