import 'package:flutter/material.dart';
import 'package:comet/widget/app_bar.dart';

import 'file_upload_page.dart';

class ApiRequestPage extends StatelessWidget {
  const ApiRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // 배경색을 투명으로 설정
      appBar: AppBarMenu(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
            image: AssetImage('assets/images/background_file.png'), // 배경 이미지
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ExampleDragTarget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
