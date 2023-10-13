import 'dart:html';
import 'package:flutter/material.dart';

import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

import 'recording.dart' as recording;

class ExampleDragTarget extends StatefulWidget {
  final void Function(String)? onFileSelected; // Function to receive file path

  const ExampleDragTarget({Key? key, this.onFileSelected}) : super(key: key);

  @override
  _ExampleDragTargetState createState() => _ExampleDragTargetState();
}

class _ExampleDragTargetState extends State<ExampleDragTarget> {
  final List<XFile> _list = [];

  bool _dragging = false;

  //String? _filePath;

  Offset? offset;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (detail) async {
        // if (detail.files.isNotEmpty) {
        //   final FileDragHoverEvent fileEvent = detail.files.first as FileDragHoverEvent;
        //   final String filePath = fileEvent.file.path;
        //   // 이제 filePath를 사용하여 API 요청 또는 파일 처리를 수행할 수 있습니다.
        //   print(filePath);
        //   setState(() {
        //     _fileContent = content;
        //   });
        //   print('File Content: $_fileContent');
        // }

        // setState(() {
        //   for (var file in detail.files) {
        //     if (file.mimeType!.startsWith('audio/')) {
        //       _list.add(file);
        //     }
        //   }
        //   String filePath = detail.files[0].path;
        //   print(filePath);
        // //   for (var file in detail.files)
        // //     if (file.mimeType!.startsWith('audio/')) {
        // //       _list.add(file);
        // //       String filePath = detail.files[0].path;
        // //       widget.onFileSelected?.call(filePath); // Call the callback function with file path
        // //     }
        // //   //}
        //   widget.onFileSelected?.call(filePath); // Call the callback function with file path
        // });

        debugPrint('onDragDone:');
          for (final file in _list) {
          debugPrint('  ${file.path} ${file.name}'
          '  ${await file.lastModified()}'
          '  ${await file.length()}'
          '  ${file.mimeType}');
          }
      },
      onDragUpdated: (details) {
        setState(() {
          offset = details.localPosition;
        });
      },
      onDragEntered: (detail) {
        setState(() {
          _dragging = true;
          offset = detail.localPosition;
        });
      },
      onDragExited: (detail) {
        setState(() {
          _dragging = false;
          offset = null;
        });
      },
      child: Container(
        height: 200,
        width: 500,
        color: _dragging ? Colors.blue.withOpacity(0.4) : Colors.black26,
        child: Stack(
          children: [
            if (_list.isEmpty)
              const Center(child: Text("Drop here"))
            else
              Text(_list.map((e) => e.name).join("\n")),
            if (offset != null)
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  '$offset',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodySmall,
                ),
              )
          ],
        ),
      ),
    );
  }
}