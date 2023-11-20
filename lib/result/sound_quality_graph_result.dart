import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SoundQualityGraph extends StatefulWidget {
  final List<String?> result;

  const SoundQualityGraph({required this.result, Key? key}) : super(key: key);

  @override
  State<SoundQualityGraph> createState() => SoundQualityGraphState();
}

class SoundQualityGraphState extends State<SoundQualityGraph> {
  late String jsonData;
  late String scaledRMSString;
  late String scaledSNRString;

  @override
  void initState() {
    super.initState();
    jsonData = widget.result[1]!;
    scaledRMSString = '0.0';
    scaledSNRString = '0.0';
  }

  double? getResultFromJson(String status) {
    Map<String, dynamic> jsonObject = json.decode(jsonData);

    if (status == 'rms') {
      double scaledRMS = (jsonObject['energy']['rms']);
      scaledRMSString = scaledRMS.toStringAsFixed(2);
      double rms = double.parse(scaledRMSString);
      return (rms >= 0.3) ? 0.3 : (rms <= 0.1) ? 0.1 : rms;
    } else if (status == 'snr') {
      double scaledSNR = jsonObject['energy']['snr'];
      scaledSNRString = scaledSNR.toStringAsFixed(1);
      double snr = double.parse(scaledSNRString);
      return (snr >= 30) ? 30 : (snr <= -5) ? -5 : snr;
    } else {
      return null;
    }
  }

  Widget buildGauge(String label, String status, double min, double max) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(fontSize: 20)),
        SfLinearGauge(
          minimum: min,
          maximum: max,
          markerPointers: [
            LinearShapePointer(value: getResultFromJson(status)!)
          ],
          minorTicksPerInterval: 4,
          useRangeColorForAxis: true,
          animateAxis: true,
          axisTrackStyle: LinearAxisTrackStyle(thickness: 1),
          ranges: <LinearGaugeRange>[
            LinearGaugeRange(
              startValue: min,
              endValue: (max - min) / 3,
              position: LinearElementPosition.outside,
              color: Color(0xffF45656),
            ),
            LinearGaugeRange(
              startValue: (max - min) / 3,
              endValue: (max - min) * 2 / 3,
              position: LinearElementPosition.outside,
              color: Color(0xffFFC93E),
            ),
            LinearGaugeRange(
              startValue: (max - min) * 2 / 3,
              endValue: max,
              position: LinearElementPosition.outside,
              color: Color(0xff0DC9AB),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 850,
      height: 200,
      color: Color.fromRGBO(243, 243, 232, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("💡 명료도의 수치가 너무 낮고 음성의 수치가 너무 높거나, 낮은 경우 테스트 정확도가 떨어질 수 있습니다."),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildGauge('음성', 'rms', 0, 0.3),
              SizedBox(width: 150),
              buildGauge('명료도', 'snr', -5, 30),
            ],
          ),
        ],
      ),
    );
  }
}
