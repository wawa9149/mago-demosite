import 'package:flutter/material.dart';
import 'apiRequestPage.dart';
import 'demo/dnd.dart';
import 'demo/graphWidget.dart';

void main() {
  runApp(const MyApp());
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
    final ButtonStyle style = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      minimumSize: Size(100, 0),
    );
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Image.asset(
            'assets/images/mago-word-dark.png',
            height: 5,
            width: 5,
          ),
          TextButton(
            style: style,
            onPressed: () {},
            child: const Text('Action 1'),
          ),
          const VerticalDivider(
            indent: 7,
            endIndent: 7,
            color: Colors.white, // 세로 선의 색상 조절
            width: 1, // 세로 선의 두께 조절
          ),
          TextButton(
            style: style,
            onPressed: () {},
            child: const Text('Action 2'),
          ),
          const VerticalDivider(
            indent: 7,
            endIndent: 7,
            color: Colors.white, // 세로 선의 색상 조절
            width: 1, // 세로 선의 두께 조절
          ),
          TextButton(
            style: style,
            onPressed: () {},
            child: const Text('Action 3'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ApiRequestPage()),
                );
              },
              child: const Text('데모 실행'),
            ),
          ],
        ),
      ),
    );
  }
}
