import 'package:comet/widget_design/appBar.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'apiRequestPage.dart';
//import 'firebase_options.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  print('시작');
  runApp(const GetMaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: MyWidget(),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle textButtonStyle = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      minimumSize: Size(120, 0),
      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
    );
    return Scaffold(
      appBar: AppBarMenu(textButtonStyle),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight, // 이미지를 우측 하단에 배치
            child: Image.asset(
              'assets/images/background_main.png',
              width: 600,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(150, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Voice BioMarker",
                  style: TextStyle(fontSize: 50, fontFamily: 'NanumSquareEB', fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  '음성 분석 데모 사이트!',
                  style: TextStyle(fontSize: 30, fontFamily: 'NanumSquareR', ),
                ),
                const SizedBox(
                  height: 200,
                ),
                //Align(
                //alignment: Alignment(-0.8, 0.55),
                //child: ElevatedButton(
                ElevatedButton(
                  onPressed: () {
                    Get.to(const ApiRequestPage());
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const ApiRequestPage()),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(250, 65),
                    textStyle: const TextStyle(
                        fontSize: 45, fontWeight: FontWeight.bold),
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
                    'Get Started', // 표시할 텍스트
                    style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'NEXONLv1GothicBold',
                        color: Color.fromRGBO(49, 81, 63, 1)), // 텍스트 스타일 조절
                  ),
                ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
