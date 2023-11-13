import 'package:comet/widget_design/appBar.dart';
import 'package:comet/widget_design/textResultBox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'apiRequestPage.dart';
import 'demo/imageResult.dart';

class DetailPage extends StatelessWidget {
  DetailPage({required this.result, Key? key}) : super(key: key);
  List<String?> result = [];

  @override
  Widget build(BuildContext context) {
    final ButtonStyle textButtonStyle = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      minimumSize: Size(120, 0),
      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
    );
    return Scaffold(
      appBar: AppBarMenu(textButtonStyle),
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
                const SizedBox(
                  height: 100,
                ),
                const Text('<음성 인식 결과>',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextResultBox(result[0] ?? 'N/A'),
                const SizedBox(height: 50),
                const Text('<Acoustic BioMarker 결과>',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextResultBox(result[1] ?? 'N/A'),
                const SizedBox(height: 50),
                const Text('<감정 인식 결과>',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextResultBox(result[2] ?? 'N/A'),
                const SizedBox(
                  height: 50,
                ),
                ImageResult(id: result[3]),
                const SizedBox(
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
