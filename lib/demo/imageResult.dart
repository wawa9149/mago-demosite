import 'dart:developer';
import 'dart:typed_data';

import 'package:comet/api/getApiResult.dart';
import 'package:flutter/material.dart';
import 'package:comet/api/mago_abm.dart';

class ImageResult extends StatefulWidget {
  ImageResult({required this.id,  Key? key}) : super(key: key);

  String? id = '';

  @override
  State<ImageResult> createState() => ImageResultState();
}

const List<Widget> featureName = <Widget>[
  Text('Pitch'),
  Text('MFCC'),
  Text('Spectrogram'),
  Text('MelSpectrogram'),
  Text('SpectralCentroid')
];

class ImageResultState extends State<ImageResult> {
  var magoABM = MagoABM('http://saturn.mago52.com:9104/abm'); // API 객체
  final List<bool> _selectedFeatures = <bool>[true, false, false, false, false];
  final List<String> features = <String>[
    'Pitch',
    'MFCC',
    'Spectrogram',
    'MelSpectrogram',
    'SpectralCentroid'
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Center(
      child: Column(
        children: <Widget>[

          const SizedBox(
            height: 50,
          ),
          // ToggleButtons with a single selection.
          Text('<원하시는 이미지를 선택해주세요>', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ToggleButtons(
            //direction: vertical ? Axis.vertical : Axis.horizontal,
            onPressed: (int index) {
              print('index: $index');
              setState(() {
                // The button that is tapped is set to true, and the others to false.
                for (int i = 0; i < _selectedFeatures.length; i++) {
                  _selectedFeatures[i] = i == index;
                }
              });

              // 버튼을 누를 때마다 API 요청을 보냅니다.
              _requestImage();
            },
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedBorderColor: Color.fromRGBO(71, 105, 31, 0.5),
            selectedColor: Colors.white,
            fillColor: Color.fromRGBO(71, 105, 31, 0.5),
            color: Color.fromRGBO(71, 105, 31, 0.5),
            constraints: const BoxConstraints(
              minHeight: 40.0,
              minWidth: 130.0,
            ),
            isSelected: _selectedFeatures,
            children: featureName,
          ),
          const SizedBox(height: 50),
          Container(
            height: 300,
            width: 900,
            alignment: Alignment.center,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white, // 배경색
              borderRadius: BorderRadius.circular(20), // 테두리의 모서리를 둥글게 만듦
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey, // 그림자의 색상
                  offset: Offset(0, 5), // 그림자의 위치 (가로, 세로)
                  blurRadius: 10, // 그림자의 흐림 정도
                  spreadRadius: 2, // 그림자의 확산 정도
                ),
              ],
            ),
            child: FutureBuilder<Uint8List?>(
              // 이미지 요청 부분은 FutureBuilder 내에서 호출됩니다.
              future: _requestImage(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('이미지 결과 창');
                } else if (snapshot.hasData) {
                  return Image.memory(
                    snapshot.data!,
                    width: 1000, // 이미지의 폭을 조절할 수 있습니다.
                    height: 400, // 이미지의 높이를 조절할 수 있습니다.
                  );
                } else {
                  return Text('No image data');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<Uint8List?> _requestImage() async {
    try {
      print('widget.id: ${widget.id}');
      Uint8List? imageBytes = await magoABM.plotRequest(
          features[_selectedFeatures.indexOf(true)].toString(), widget.id!);
      print('imageBytes: $imageBytes');
      print('2');
      return imageBytes;
    } catch (e) {
      print('Error requesting image: $e');
      return null;
    }
  }
}
