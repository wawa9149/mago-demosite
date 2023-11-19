import 'dart:typed_data';

import 'package:comet/page/detail_result_page.dart';
import 'package:comet/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'animal_type_result_page.dart';

class ApiResultPage extends StatelessWidget {
  ApiResultPage({required this.result, required this.audioSource, required this.gender, Key? key}) : super(key: key);

  List<String?> result = [];
  String gender = '';
  Uint8List audioSource = Uint8List(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMenu(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
            image: AssetImage('assets/images/background_file.png'), // 배경 이미지
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //AudioPlayerWidget(audioSource: audioSource,),
                // 동물 유형 페이지
                AnimalTypeResult(result: result, gender: gender),
                const SizedBox(
                  height: 50,
                ),
                // detailPage로 이동
                ElevatedButton(
                  onPressed: () {
                    Get.to(DetailPage(result: result));
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 65),
                    foregroundColor: Color.fromRGBO(49, 81, 63, 1),
                    backgroundColor: Colors.white,
                    // 버튼 텍스트의 색상을 흰색으로 설정
                    shadowColor: Colors.black,
                    elevation: 10,
                    // 그림자의 깊이를 나타냄
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    '상세 결과 확인', // 표시할 텍스트
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold,
                        fontFamily: 'NEXONLv1GothicBold',
                        color: Color.fromRGBO(49, 81, 63, 1)), // 텍스트 스타일 조절
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
