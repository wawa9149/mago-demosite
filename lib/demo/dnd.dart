import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AudioPlayerWidget(),
    );
  }
}

class AudioPlayerWidget extends StatefulWidget {
  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final _player = AudioPlayer();
  String audioFileName = "No File Selected";
  Uint8List audioFile = Uint8List(0);

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void playAudio() async {
    // Create an in-memory audio source from Uint8List
    var inMemorySource = AudioSource.uri(
      Uri.dataFromString(
        String.fromCharCodes(audioFile), // Convert Uint8List to String
        mimeType: 'audio/mpeg', // Adjust the mimeType according to your audio format
      ),
      tag: AudioMetadata(
        album: 'Album Name',
        title: 'Audio Title',
      ),
    );

    // Set the in-memory source as the audio source
    await _player.setAudioSource(inMemorySource);
    _player.play();
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
              onPressed: playAudio,
              child: Text('Play Audio'),
            ),
            SizedBox(height: 20),
            Text(audioFileName),
          ],
        ),
      ),
    );
  }
}
