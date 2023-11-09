import 'package:flutter/material.dart';

AppBar AppBarMenu(ButtonStyle textButtonStyle) {

  void _customBackButtonAction() {
    // 뒤로가기 버튼을 눌렀을 때 수행할 커스텀 동작 추가
    print('Custom back button pressed');
    // 여기에 원하는 동작 추가
  }

  return AppBar(
    toolbarHeight: 80,
    backgroundColor: Color.fromRGBO(49, 81, 63, 1),
    leading: IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        // 뒤로가기 버튼을 누를 때 커스텀 동작 수행
        _customBackButtonAction();
      },
    ),
    actions: <Widget>[
      Padding(
        padding: EdgeInsets.fromLTRB(60, 0, 0, 0),
        child: Image.asset(
          'assets/images/mago-word-dark.png',
          color: Colors.white,
          width: 150,
        ),
      ),
      const Spacer(),
      TextButton(
        style: textButtonStyle,
        onPressed: () {},
        child: const Text(
          '음성 바이오마커',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold), // 텍스트 스타일 조절
        ),
      ),
      const VerticalDivider(
        indent: 20,
        endIndent: 20,
        color: Colors.white, // 세로 선의 색상 조절
        thickness: 1, // 세로 선의 두께 조절
      ),
      TextButton(
        style: textButtonStyle,
        onPressed: () {},
        child: const Text(
          '기술 설명',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold), // 텍스트 스타일 조절
        ),
      ),
      const VerticalDivider(
        indent: 20,
        endIndent: 20,
        color: Colors.white, // 세로 선의 색상 조절
        thickness: 1, // 세로 선의 두께 조절
      ),
      TextButton(
        style: textButtonStyle,
        onPressed: () {},
        child: const Text(
          'About MAGO',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold), // 텍스트 스타일 조절
        ),
      ),
    ],
  );
}
