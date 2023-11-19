import 'dart:developer';
import 'dart:typed_data';
import 'package:comet/api/api_request.dart';
import 'package:flutter/material.dart';
import 'package:comet/api/mago_abm.dart';

class ImageResult extends StatefulWidget {
  ImageResult({required this.id, Key? key}) : super(key: key);

  String? id = '';

  @override
  State<ImageResult> createState() => ImageResultState();
}

class ImageResultState extends State<ImageResult> {
  static const List<Widget> featureName = <Widget>[
    Text('Pitch'),
    Text('MFCC'),
    Text('Spectrogram'),
    Text('MelSpectrogram'),
    Text('SpectralCentroid')
  ];

  final MagoABM magoABM = MagoABM('https://abm.magostar.com/abm', 'eadc5d8d-ahno-9559-yesa-8c053e0f1f69');
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
    return Center(
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 50,
          ),
          Text('<원하시는 이미지를 선택해주세요>', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ToggleButtons(
            onPressed: (int index) {
              print('index: $index');
              setState(() {
                for (int i = 0; i < _selectedFeatures.length; i++) {
                  _selectedFeatures[i] = i == index;
                }
              });
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
            child: FutureBuilder<Uint8List?>(
              future: _requestImage(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('이미지 결과 창');
                } else if (snapshot.hasData) {
                  return Image.memory(
                    snapshot.data!,
                    width: 1000,
                    height: 400,
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
      return await magoABM.plotRequest(features[_selectedFeatures.indexOf(true)].toString(), widget.id!);
    } catch (e) {
      log('Error requesting image: $e');
      return null;
    }
  }
}
