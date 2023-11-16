import 'package:flutter/material.dart';
import 'package:comet/widget_design/appBar.dart';
import 'demo/drag_n_drop.dart';

class ApiRequestPage extends StatelessWidget {
  const ApiRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle textButtonStyle = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      minimumSize: Size(120, 0),
      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
    );
    return Scaffold(
      backgroundColor: Colors.transparent, // 배경색을 투명으로 설정
      appBar: AppBarMenu(textButtonStyle),
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
