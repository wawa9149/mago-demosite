import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';

import '../page/file_upload_page.dart';

class DropZoneContainer extends StatelessWidget {
  final Uint8List audioFile;
  final String audioFileName;
  final Function(Uint8List, String) onFileSelected;

  const DropZoneContainer({
    Key? key,
    required this.audioFile,
    required this.audioFileName,
    required this.onFileSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // change color when dragging
    Color color =
        context.findAncestorStateOfType<ExampleDragTargetState>()!.dragging
            ? const Color.fromRGBO(71, 105, 31, 0.5)
            : Colors.grey[600]!;

    return Container(
      height: 380,
      width: 580,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Drop Your ",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NEXONLv1GothicBold',
                  fontSize: 25,
                ),
              ),
              Text(
                "File(wav, aac, flac, ...)",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NEXONLv1GothicBold',
                  fontSize: 25,
                ),
              ),
              Text(
                " Here",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NEXONLv1GothicBold',
                  fontSize: 25,
                ),
              ),
            ],
          ),
          SizedBox(height: 40),
          // drag and drop zone
          InkWell(
            hoverColor: Color.fromRGBO(0, 0, 0, 0),
            splashColor: Colors.blue[300],
            child: DottedBorder(
              dashPattern: [20, 15],
              strokeWidth: 3,
              strokeCap: StrokeCap.round,
              borderType: BorderType.RRect,
              color: Color.fromRGBO(71, 105, 31, 0.5),
              radius: Radius.circular(20),
              child: Container(
                width: 310,
                height: 210,
                child: ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['aac', 'mp3', 'wav', 'flac', 'm4a'],
                    );
                    if (result != null && result.files.isNotEmpty) {
                      onFileSelected(
                          result.files.first.bytes!, result.files.first.name);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide.none,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/Icon_file.png",
                      ),
                      SizedBox(height: 20),
                      Text(
                        "or Browse Files",
                        style: TextStyle(
                          color: Colors.grey[600]!,
                          fontFamily: 'NEXONLv1GothicBold',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            context
                .findAncestorStateOfType<ExampleDragTargetState>()!
                .showFileName,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
