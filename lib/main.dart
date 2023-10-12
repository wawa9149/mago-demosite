import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Recorder',
      home: VoiceRecorderScreen(),
    );
  }
}

class VoiceRecorderScreen extends StatefulWidget {
  @override
  _VoiceRecorderScreenState createState() => _VoiceRecorderScreenState();
}

class _VoiceRecorderScreenState extends State<VoiceRecorderScreen> {
  late FlutterSoundPlayer _player;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = FlutterSoundPlayer();
  }

  Future<void> _playRecording(List<int> audioData) async {
    await _player.startPlayer(
      fromDataBuffer: Uint8List.fromList(audioData),
      codec: Codec.pcm16WAV,
      whenFinished: () {
        setState(() {
          _isPlaying = false;
        });
      },
    );
    setState(() {
      _isPlaying = true;
    });
  }


  void _stopPlaying() async {
    await _player.stopPlayer();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  void dispose() {
    _player.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Recorder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DragTarget<List<int>>(
              onAccept: (data) {
                // 드롭한 파일 처리 로직
                _playRecording(data);
              },
              builder: (BuildContext context, List candidateData, List rejectedData) {
                return Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: const Center(
                    child: Text('Drop Audio File Here'),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _isPlaying
                ? ElevatedButton(
              onPressed: _stopPlaying,
              child: Text('Stop Playing'),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
