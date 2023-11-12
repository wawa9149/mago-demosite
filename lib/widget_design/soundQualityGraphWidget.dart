import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SoundQualityGraph extends StatefulWidget {
  List<String?> result = [];

  SoundQualityGraph({required this.result, Key? key}) : super(key: key);

  @override
  State<SoundQualityGraph> createState() => SoundQualityGraphState();
}

class SoundQualityGraphState extends State<SoundQualityGraph> {
  double doubleValue = 0.0;

  @override
  Widget build(BuildContext context) {
    String? jsonData = widget.result[1];
    String scaledRMSString = '0.0';
    String scaledSNRString = '0.0';

    double? getResultFromJson(String status) {
      Map<String, dynamic> jsonObject = json.decode(jsonData!);

      // status에 따라서 다른 결과를 반환
      if (status == 'rms') {
        Map<String, dynamic> contentsObject = jsonObject['energy'];
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

        return rms;
      } else if (status == 'snr') {
        Map<String, dynamic> contentsObject = jsonObject['energy'];
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

        return snr;
      } else {
        return null;
      }
    }

    return Container(
      width: 850,
      height: 200,
      color: Color.fromRGBO(243, 243, 232, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("💡 노이즈가 너무 크고 음성의 수치가 너무 높거나, 낮은 경우 테스트 정확도가 떨어질 수 있습니다."),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '음성',
                    style: TextStyle(fontSize: 20),
                  ),
                  Container(
                      child: SfLinearGauge(
                    minimum: 0,
                    maximum: 0.3,
                    markerPointers: [
                      LinearShapePointer(value: getResultFromJson('rms')!)
                    ],
                    minorTicksPerInterval: 4,
                    useRangeColorForAxis: true,
                    animateAxis: true,
                    axisTrackStyle: LinearAxisTrackStyle(thickness: 1),
                    ranges: <LinearGaugeRange>[
                      LinearGaugeRange(
                          startValue: 0,
                          endValue: 0.1,
                          position: LinearElementPosition.outside,
                          color: Color(0xffF45656)),
                      LinearGaugeRange(
                          startValue: 0.1,
                          endValue: 0.2,
                          position: LinearElementPosition.outside,
                          color: Color(0xffFFC93E)),
                      LinearGaugeRange(
                          startValue: 0.2,
                          endValue: 0.3,
                          position: LinearElementPosition.outside,
                          color: Color(0xff0DC9AB)),
                    ],
                  )),
                ],
              ),
              SizedBox(
                width: 150,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '노이즈',
                    style: TextStyle(fontSize: 20),
                  ),
                  Container(
                    child: SfLinearGauge(
                      minimum: -5,
                      maximum: 30,
                      markerPointers: [
                        LinearShapePointer(value: getResultFromJson('snr')!)
                      ],
                      minorTicksPerInterval: 4,
                      useRangeColorForAxis: true,
                      animateAxis: true,
                      axisTrackStyle: LinearAxisTrackStyle(thickness: 1),
                      ranges: <LinearGaugeRange>[
                        LinearGaugeRange(
                            startValue: -5,
                            endValue: 10,
                            position: LinearElementPosition.outside,
                            color: Color(0xffF45656)),
                        LinearGaugeRange(
                            startValue: 10,
                            endValue: 20,
                            position: LinearElementPosition.outside,
                            color: Color(0xffFFC93E)),
                        LinearGaugeRange(
                          startValue: 20,
                          endValue: 30,
                          position: LinearElementPosition.outside,
                          color: Color(0xff0DC9AB),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
