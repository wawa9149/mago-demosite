import 'package:flutter/material.dart';
import 'demo/dnd.dart' as dnd;
import 'demo/recording.dart' as recording;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //String? selectedFilePath; // Variable to store selected file path

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Demo page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 200,
                width: 500,
                child: dnd.ExampleDragTarget(
                  // onFileSelected: (filePath) {
                  //   selectedFilePath = filePath;
                  // },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 200,
                width: 500,
                child: recording.Recording(),//filePath: selectedFilePath),
              ),
            ],
          ),
        ),
      ),
    );
  }
}