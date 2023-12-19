import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'api_result_page.dart';
import '../api/api_request.dart';
import '../widget/app_bar.dart';
import 'loading_page.dart';

class SelectedGender extends StatelessWidget {
  SelectedGender(
      {required this.audioFileName, required this.audioFile, super.key});

  String audioFileName = '';
  Uint8List audioFile = Uint8List(0);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      minimumSize: Size(100, 80),
      backgroundColor: const Color.fromRGBO(71, 105, 31, 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

    ElevatedButton api(String gender) {
      return ElevatedButton(
        onPressed: () async {
          try {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FutureBuilder<List<String?>>(
                  future: GetApiResult(audioFile, audioFileName)
                      .getApiResult()
                      .timeout(const Duration(seconds: 10)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // 로딩 중일 때 표시할 위젯 (로딩창)
                      return Center(child: LoadingPage());
                    } else if (snapshot.hasError) {
                      // 에러 발생 시 표시할 위젯
                      return Center(child: Text('에러 발생: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      return ApiResultPage(
                        result: snapshot.data!,
                        audioSource: audioFile,
                        gender: gender,
                      );
                    } else {
                      // 다른 예외 상황 처리 (데이터가 없는 경우 등)
                      return Center(child: Text('예외 상황 처리'));
                    }
                  },
                ),
              ),
            );
          } catch (e) {
            print('에러 발생: $e');
            Fluttertoast.showToast(
              msg: '작업이 타임아웃되었습니다.',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          }
        },
        style: buttonStyle,
        child: Text(
          gender,
          style: const TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBarMenu(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
            image: AssetImage('assets/images/background_file.png'), // 배경 이미지
          ),
        ),
        child: Center(
          child: Container(
            // 상단 여백 조절
            height: 400,
            width: 580,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white, // 배경색
              borderRadius: BorderRadius.circular(10), // 테두리의 모서리를 둥글게 만듦
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey, // 그림자의 색상
                  offset: Offset(0, 5), // 그림자의 위치 (가로, 세로)
                  blurRadius: 10, // 그림자의 흐림 정도
                  spreadRadius: 2, // 그림자의 확산 정도
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  child: Text('당신의 음성 유형은?'),
                ),
                SizedBox(
                  height: 25,
                ),
                const DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(102, 102, 102, 1),
                  ),
                  child: Text('성별을 선택하시면 결과 페이지로 이동합니다.'),
                ),
                const SizedBox(
                  height: 80,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    api('남'),
                    SizedBox(
                      width: 100,
                    ),
                    api('여'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
