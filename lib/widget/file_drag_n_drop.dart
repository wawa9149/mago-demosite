import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';

import '../page/file_upload_page.dart';
import 'file_picker.dart';

class DropZoneWidget extends StatelessWidget {
  final Uint8List audioFile;
  final String audioFileName;
  final Function(Uint8List, String) onFileSelected;

  const DropZoneWidget({
    Key? key,
    required this.audioFile,
    required this.audioFileName,
    required this.onFileSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      // Called when the drag operation is completed
      onDragDone: (detail) async {
        if (detail.files.isNotEmpty) {
          // If files are present after the drag operation
          String fileName = detail.files.first.name;
          // Check the file extension
          if (isAllowedFileExtension(fileName)) {
            // If the extension is allowed
            Uint8List fileBytes = await detail.files.first.readAsBytes();
            // Convert the file to bytes
            onFileSelected(fileBytes, fileName);
          } else {
            // If the extension is not allowed
            showInvalidFileAlert(context);
          }
        }
      },
      // Called when a drag operation enters the target area
      onDragEntered: (detail) {
        // When the drag operation starts
        _setDraggingState(context, true);
      },
      // Called when a drag operation exits the target area
      onDragExited: (detail) {
        // When the drag operation ends
        _setDraggingState(context, true);
      },
      child: DropZoneContainer(
        audioFile: audioFile,
        audioFileName: audioFileName,
        onFileSelected: onFileSelected,
      ),
    );
  }

  // Check if the file extension is allowed
  bool isAllowedFileExtension(String fileName) {
    List<String> allowedExtensions = ['mp3', 'wav', 'flac', 'aac', 'm4a'];
    String extension = fileName.split('.').last.toLowerCase();
    return allowedExtensions.contains(extension);
  }

  // Show alert for invalid file
  void showInvalidFileAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid File'),
          content: const Text(
              'Only audio files (mp3, wav, aac, flac, m4a) are allowed.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Set dragging state
  void _setDraggingState(BuildContext context, bool dragging) {
    ExampleDragTargetState state =
    context.findAncestorStateOfType<ExampleDragTargetState>()!;
    state.setState(() {
      state.dragging = dragging;
    });
  }
}
