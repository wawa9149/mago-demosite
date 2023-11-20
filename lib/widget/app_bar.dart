import 'package:flutter/material.dart';

AppBar AppBarMenu() {
  final ButtonStyle textButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.white,
    minimumSize: const Size(120, 0),
    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
  );

  // Custom back button action
  // void _customBackButtonAction() {
  //   log('Custom back button pressed');
  // }

  // Build text button with given text
  Widget buildTextButton(String text) {
    return TextButton(
      style: textButtonStyle,
      onPressed: () {},
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  return AppBar(
    toolbarHeight: 80,
    backgroundColor: const Color.fromRGBO(49, 81, 63, 1),
    // Leading icon button
    // leading: IconButton(
    //   icon: Icon(Icons.arrow_back),
    //   onPressed: _customBackButtonAction,
    // ),
    actions: <Widget>[
      // MAGO logo
      Padding(
        padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
        child: Image.asset(
          'assets/images/mago-word-dark.png',
          color: Colors.white,
          width: 150,
        ),
      ),
      const Spacer(),
      // Text button for '음성 바이오마커'
      buildTextButton('음성 바이오마커'),
      const VerticalDivider(
        indent: 20,
        endIndent: 20,
        color: Colors.white,
        thickness: 1,
      ),
      // Text button for '기술 설명'
      buildTextButton('기술 설명'),
      const VerticalDivider(
        indent: 20,
        endIndent: 20,
        color: Colors.white,
        thickness: 1,
      ),
      // Text button for 'About MAGO'
      buildTextButton('About MAGO'),
    ],
  );
}
