import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GraphResult extends StatefulWidget {
  List<String?> result = [];

  GraphResult({required this.result, Key? key}) : super(key: key);

  @override
  State<GraphResult> createState() => _GraphResultState();
}

class _GraphResultState extends State<GraphResult> {
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
        print(contentsObject);
        print('ABM energy: ok');
        double scaledRMS = (contentsObject['rms'] * 10);

        // 소수점 1자리까지 나타내는 문자열로 변환
        scaledRMSString = scaledRMS.toStringAsFixed(1);

        // 다시 double로 파싱
        double rms = double.parse(scaledRMSString);

        print('Scaled RMS 값 (1자리까지): $rms');
        return rms;
      } else if (status == 'snr') {
        Map<String, dynamic> contentsObject = jsonObject['energy'];
        print(contentsObject);
        print('ABM energy: ok');
        double scaledSNR = (contentsObject['snr']);

        // 소수점 1자리까지 나타내는 문자열로 변환
        scaledSNRString = scaledSNR.toStringAsFixed(1);

        // 다시 double로 파싱
        double snr = double.parse(scaledSNRString);

        print('Scaled RMS 값 (1자리까지): $snr');
        return snr;
      } else if (status == 'shimmer') {
        Map<String, dynamic> contentsObject = jsonObject['energy'];
        print(contentsObject);
        print('ABM energy: ok');
        double scaledSNR = (contentsObject['snr'] * 100);

        // 소수점 1자리까지 나타내는 문자열로 변환
        scaledSNRString = scaledSNR.toStringAsFixed(1);

        // 다시 double로 파싱
        double snr = double.parse(scaledSNRString);

        print('Scaled RMS 값 (1자리까지): $snr');
        return snr;
      }
      return null;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 250,
          width: 250,
            child: SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(minimum: 0, maximum: 0.3, ranges: <GaugeRange>[
            GaugeRange(startValue: 0, endValue: 0.1, color: Color.fromRGBO(228, 233, 190, 0.5)),
            GaugeRange(startValue: 0.1, endValue: 0.3, color: Color.fromRGBO(49, 81, 63, 1))
          ], pointers: <GaugePointer>[
            NeedlePointer(value: getResultFromJson('rms')!)
          ], annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                widget: Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Text(scaledRMSString,
                        style:
                            TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                    Text("음성 크기",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))
                  ],
                )),
                angle: 90,
                positionFactor: 0.5)
          ])
        ])),
      SizedBox(width: 50,),
      Container(
          height: 250,
          width: 250,
          child: SfRadialGauge(axes: <RadialAxis>[
            RadialAxis(minimum: -5, maximum: 20, ranges: <GaugeRange>[
              GaugeRange(startValue: -5, endValue: 0, color: Color.fromRGBO(228, 233, 190, 0.5)),
              GaugeRange(startValue: 0, endValue: 5, color: Color.fromRGBO(188, 193, 150, 1)),
              GaugeRange(startValue: 5, endValue: 10, color: Color.fromRGBO(89, 121, 80, 1)),
              GaugeRange(startValue: 10, endValue: 20, color: Color.fromRGBO(49, 81, 63, 1))
            ], pointers: <GaugePointer>[
              NeedlePointer(value: getResultFromJson('snr')!)
            ], annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Text(scaledSNRString,
                              style:
                              TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                          Text("노이즈",
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))
                        ],
                      )),
                  angle: 90,
                  positionFactor: 0.5)
            ])
          ])),
        SizedBox(width: 50,),
        Container(
            height: 250,
            width: 250,
            child: SfRadialGauge(axes: <RadialAxis>[
              RadialAxis(minimum: 0, maximum: 150, ranges: <GaugeRange>[
                GaugeRange(startValue: 0, endValue: 15, color: Color.fromRGBO(228, 233, 190, 0.5)),
                GaugeRange(startValue: 15, endValue: 75, color: Color.fromRGBO(89, 121, 80, 1)),
                GaugeRange(startValue: 75, endValue: 150, color: Color.fromRGBO(49, 81, 63, 1)),
              ], pointers: <GaugePointer>[
                NeedlePointer(value: getResultFromJson('shimmer')!)
              ], annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            Text(scaledRMSString,
                                style:
                                TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                            Text("발성",
                                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))
                          ],
                        )),
                    angle: 90,
                    positionFactor: 0.5)
              ])
            ])),
      ],
    );

    // return Padding(
    //   padding: EdgeInsets.all(16.0),
    //   child: PieChart(
    //     PieChartData(
    //       sectionsSpace: 10,
    //       centerSpaceRadius: 40,
    //       sections: [
    //         PieChartSectionData(
    //           color: Colors.blue,
    //           value: data['utterance_duration'],
    //           title: '${data['음성 크기']}',
    //           radius: 50,
    //           titleStyle: TextStyle(
    //             fontSize: 18,
    //             fontWeight: FontWeight.bold,
    //             color: const Color(0xffffffff),
    //           ),
    //         ),
    //         PieChartSectionData(
    //           color: Colors.green,
    //           value: data['silence_duration_mean'],
    //           title: '${data['silence_duration_mean']}',
    //           radius: 50,
    //           titleStyle: TextStyle(
    //             fontSize: 18,
    //             fontWeight: FontWeight.bold,
    //             color: const Color(0xffffffff),
    //           ),
    //         ),
    //         PieChartSectionData(
    //           color: Colors.yellow,
    //           value: data['silence_duration_std'],
    //           title: '${data['silence_duration_std']}',
    //           radius: 50,
    //           titleStyle: TextStyle(
    //             fontSize: 18,
    //             fontWeight: FontWeight.bold,
    //             color: const Color(0xffffffff),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
