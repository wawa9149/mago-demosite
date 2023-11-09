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
        add('말의 속도', '느림', '빠름', 70),
        add('말의 빈도', '적음', '많음', 50),
        add('음성의 떨림', '적음', '많음', 30),
        add('음역대', '낮음', '높음', 80),
      ],
    );
  }
}

SizedBox add(String feature, String less, String more, double data){
    return SizedBox(
      height: 130,
      width: 800,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(feature, style: TextStyle(fontSize: 20),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(less, style: TextStyle(fontSize: 20),),
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
                        data.toStringAsFixed(1) + '%',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffFFFFFF)),
                      ),
                    ),
                  ),
                ],
              ),
              Text(more, style: TextStyle(fontSize: 20),),
            ],
          ),
        ],
      ),
    );
  }
