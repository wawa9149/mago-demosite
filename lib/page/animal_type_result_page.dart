import 'dart:convert';

import 'package:comet/result/emo_graph_result.dart';
import 'package:comet/result/abm_progressbar_graph_result.dart';
import 'package:comet/result/sound_quality_graph_result.dart';
import 'package:flutter/material.dart';

class AnimalTypeResult extends StatefulWidget {
  List<String?> result = [];
  String gender = '';

  AnimalTypeResult({required this.result, required this.gender, Key? key}) : super(key: key);

  @override
  State<AnimalTypeResult> createState() => AnimalTypeResultState();
}

class AnimalTypeResultState extends State<AnimalTypeResult> {
  late String? s2tjsonData = widget.result[0];
  late String? abmjsonData = widget.result[1];
  late List<double> abmResult;

  @override
  void initState() {
    super.initState();
    // abmResult에 결과 저장
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
  double pitch = abmResult[1];
  double shimmer = abmResult[2];

  const double malePitchThreshold = 125;
  const double femalePitchThreshold = 205;
  const double speedThreshold = 50;
  const double shimmerThreshold = 50;

  String animal = '';

  // Determine pitch threshold based on gender
  double pitchThreshold = (gender == '남') ? malePitchThreshold : femalePitchThreshold;

  // Determine animal based on criteria
  if (speed < speedThreshold) {
    if (pitch < pitchThreshold && shimmer < shimmerThreshold) {
      animal = '달팽이';
    } else if (pitch < pitchThreshold && shimmer > shimmerThreshold) {
      animal = '소';
    } else if (pitch > pitchThreshold && shimmer < shimmerThreshold) {
      animal = '백조';
    } else if (pitch > pitchThreshold && shimmer > shimmerThreshold) {
      animal = '양';
    }
  } else {
    if (pitch < pitchThreshold && shimmer < shimmerThreshold) {
      animal = '사자';
    } else if (pitch > pitchThreshold && shimmer < shimmerThreshold) {
      animal = '두더지';
    } else if (pitch < pitchThreshold && shimmer > shimmerThreshold) {
      animal = '햄스터';
    } else if (pitch > pitchThreshold && shimmer > shimmerThreshold) {
      animal = '참새';
    }
  }

  return animal;
}


