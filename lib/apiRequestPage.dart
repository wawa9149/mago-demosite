import 'package:flutter/material.dart';
import 'package:comet/widget_design/appBar.dart';
import 'demo/dnd.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: ApiRequestPage(),
      ),
    );
  }
}

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
      appBar: AppBarMenu(textButtonStyle),
      body: const SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Center(
                  child: ExampleDragTarget(),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Center()
            ],
          ),
        ),
      ),
    );
  }
}
