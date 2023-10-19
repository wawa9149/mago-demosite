import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('MAGO Demo page'),
      ),
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
