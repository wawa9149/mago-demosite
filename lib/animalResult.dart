import 'dart:convert';

import 'package:comet/widget_design/emotionsGraphWidget.dart';
import 'package:comet/widget_design/progressBarWidget.dart';
import 'package:comet/widget_design/soundQualityGraphWidget.dart';
import 'package:flutter/material.dart';

class AnimalResult extends StatefulWidget {
  List<String?> result = [];
  String gender = '';

  AnimalResult({required this.result, required this.gender, Key? key}) : super(key: key);

  @override
  State<AnimalResult> createState() => _AnimalResultState();
}

class _AnimalResultState extends State<AnimalResult> {
  late String? s2tjsonData = widget.result[0];
  late String? abmjsonData = widget.result[1];
  late List<double> abmResult;

  @override
  void initState() {
    super.initState();
    abmResult = getResultFromJson();
  }

  List<double> getResultFromJson() {
    Map<String, dynamic> abmJsonObject = json.decode(abmjsonData!);
    Map<String, dynamic> abcContentsObject = abmJsonObject['speech_related'];
    double speechDuration = abcContentsObject['speech_duration'];
    String? text = s2tjsonData;
    // speed
    text = text?.replaceAll(RegExp(r'["\s]'), '');
    double speed = text!.length / speechDuration;
    // frequency
    double utteranceDuration = abcContentsObject['utterance_duration'];
    double frequency = speechDuration / utteranceDuration;
    // shimmer
    Map<String, dynamic> vocalShimmer = abmJsonObject['VocalShimmer'];
    double shimmer = vocalShimmer['localShimmer'];
    // pitch
    Map<String, dynamic> LibrosaPitch = abmJsonObject['LibrosaPitch'];
    double pitch = LibrosaPitch['f0_mean'];

    abmResult = [speed * 10, frequency * 100, shimmer * 1000, pitch];

    return abmResult;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          EmotionsGraph(result: widget.result, abmResult: abmResult, animal: AnimalTestResult(abmResult, widget.gender)),
        ],
      ),
    );
  }
}

String AnimalTestResult(List<double> abmResult, String gender) {
  double speed = abmResult[0];
  double frequency = abmResult[1];
  double shimmer = abmResult[2];
  double pitch = abmResult[3];
  String animal = '';

  print('speed: $speed');

  if(gender == '남'){
    if(speed < 50 && pitch < 125 && shimmer < 50){
      animal = '달팽이';
    }
    else if(speed < 50 && pitch < 125 && shimmer > 50){
      animal = '소';
    }
    else if(speed < 50 && pitch > 125 && shimmer < 50){
      animal = '백조';
    }
    else if(speed < 50 && pitch > 125 && shimmer > 50){
      animal = '양';
    }
    else if(speed > 50 && pitch < 125 && shimmer < 50){
      animal = '사자';
    }
    else if(speed > 50 && pitch > 125 && shimmer < 50){
      animal = '두더지';
    }
    else if(speed > 50 && pitch < 125 && shimmer > 50){
      animal = '햄스터';
    }
    else if(speed > 50 && pitch > 125 && shimmer > 50){
      animal = '참새';
    }
  } else if(gender == '여'){
    if(speed < 50 && pitch < 205 && shimmer < 50){
      animal = '달팽이';
    }
    else if(speed < 50 && pitch < 205 && shimmer > 50){
      animal = '소';
    }
    else if(speed < 50 && pitch > 205 && shimmer < 50){
      animal = '백조';
    }
    else if(speed < 50 && pitch > 205 && shimmer > 50){
      animal = '양';
    }
    else if(speed > 50 && pitch < 205 && shimmer < 50){
      animal = '사자';
    }
    else if(speed > 50 && pitch > 205 && shimmer < 50){
      animal = '두더지';
    }
    else if(speed > 50 && pitch < 205 && shimmer > 50){
      animal = '햄스터';
    }
    else if(speed > 50 && pitch > 205 && shimmer > 50){
      animal = '참새';
    }
  }
  return animal;
}


