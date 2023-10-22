import 'package:flutter/material.dart';
import 'package:comet/widget_design/appBar.dart';
import 'demo/dnd.dart';
import 'demo/graphWidget.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: ApiResultPage(),
      ),
    );
  }
}

class ApiResultPage extends StatelessWidget {
  const ApiResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle textButtonStyle = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      minimumSize: Size(120, 0),
      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
    );
    return Scaffold(
      appBar: AppBarMenu(textButtonStyle),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: MenuBar(
                      children: <Widget>[
                        SubmenuButton(
                          menuChildren: <Widget>[
                            MenuItemButton(
                              onPressed: () {
                                showAboutDialog(
                                  context: context,
                                  applicationName: 'MenuBar Sample',
                                  applicationVersion: '1.0.0',
                                );
                              },
                              child: const MenuAcceleratorLabel('&About'),
                            ),
                            MenuItemButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Saved!'),
                                  ),
                                );
                              },
                              child: const MenuAcceleratorLabel('&Save'),
                            ),
                          ],
                          child: const MenuAcceleratorLabel('&File'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Center(
                  // child: ExampleDragTarget(),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Center(),
              Container(
                  width: 500,
                  height: 500,
                  child: Mygraph()
              ),
            ],
          ),
        ),
      ),
    );
  }
}
