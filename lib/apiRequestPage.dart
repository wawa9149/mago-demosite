import 'package:flutter/material.dart';
import 'package:comet/widget_design/appBar.dart';
import 'demo/dnd.dart';

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                  child: ExampleDragTarget(),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
