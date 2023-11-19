import 'dart:developer';

import 'package:comet/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'page/api_request_page.dart';

void main() async {
  log('시작');
  runApp(const GetMaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const Scaffold(
        body: MyWidget(),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromRGBO(49, 81, 63, 1);

    const titleTextStyle = TextStyle(
      fontSize: 50,
      fontFamily: 'NanumSquareEB',
      fontWeight: FontWeight.bold,
    );

    const subtitleTextStyle = TextStyle(
      fontSize: 30,
      fontFamily: 'NanumSquareR',
    );

    const buttonTextStyle = TextStyle(
      fontSize: 25,
      fontFamily: 'NEXONLv1GothicBold',
      fontWeight: FontWeight.bold,
      color: primaryColor,
    );

    return Scaffold(
      appBar: AppBarMenu(),
      body: Stack(
        children: [
          // background image
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              'assets/images/background_main.png',
              width: 600,
            ),
          ),
          // main page
          Padding(
            padding: const EdgeInsets.fromLTRB(150, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // title
                Text(
                  "Voice BioMarker",
                  style: titleTextStyle,
                ),
                const SizedBox(height: 30),
                // subtitle
                const Text(
                  '음성 분석 데모 사이트!',
                  style: subtitleTextStyle,
                ),
                const SizedBox(height: 200),
                // get started button
                ElevatedButton(
                  onPressed: () {
                    Get.to(const ApiRequestPage());
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(250, 65),
                    textStyle: buttonTextStyle,
                    foregroundColor: primaryColor,
                    backgroundColor: Colors.white,
                    shadowColor: Colors.black,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
