import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerWidget extends StatefulWidget {
  final Uint8List audioData; // API에서 받아온 오디오 데이터
  AudioPlayerWidget({required this.audioData});

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      // 오디오 데이터를 메모리에서 읽어옴
      await _audioPlayer.setAudioSource(
        ConcatenatingAudioSource(
          children: [
            AudioSource.memory(widget.audioData,
                tag: MediaItem(id: 'unique_id', album: 'Album Name', title: 'Audio Title')),
          ],
        ),
      );
    } catch (e) {
      print('Error loading audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await _audioPlayer.play();
              },
              child: Text('Play Audio'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
