import 'package:flutter/material.dart';
import 'demo/dnd.dart';
import 'demo/magoS2t.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch : Colors.blue,),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo page'),
      ),
      body: const SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Center(
                child: ExampleDragTarget(),
              ),
              SizedBox(
                height: 50,
              ),
              // Center(
              //   child: Container(
              //     color: Colors.amber,
              //     child: const Text('hello world'),
              //   ),
              // ),
            ],
          )
      )
    );
  }
}