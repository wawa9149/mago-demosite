import 'dart:typed_data';

import 'mago_abm.dart';
import 'mago_emo.dart';
import 'mago_s2t.dart';

class GetApiResult {
  var magoStt = MagoSttApi('http://saturn.mago52.com:9003/speech2text'); // API 객체
  var magoABM = MagoABM('http://saturn.mago52.com:9104/abm'); // API 객체
  var magoEMO = MagoEMO('http://saturn.mago52.com:9105/emo'); // API 객체

  // late String? s2tRequestResult = '';
  // late String? abmRequestResult = '';
  // late String? emoRequestResult = '';

  Uint8List audioData = Uint8List(0);
  String audioFileName = '';

  GetApiResult(this.audioData, this.audioFileName);

  // API 요청
  Future<List<String?>> getApiResult() async {
    List<Future<String?>> futures = [
      magoStt.uploadAndProcessAudio(audioData, audioFileName),
      magoABM.uploadAndProcessAudio(audioData, audioFileName),
      magoEMO.uploadAndProcessAudio(audioData, audioFileName),
      magoABM.upload(audioData, audioFileName), //같은 파일의 id가 필요하기 때문에 처음 파일 요청할때 같이 요청
    ];

    List<String?> results = await Future.wait(futures);
    results[3] = magoABM.getId();

    if (results.every((result) => result != null)) {
      // 결과가 모두 null이 아니면 처리
      // s2tRequestResult = results[0]!;
      // abmRequestResult = results[1]!;
      // emoRequestResult = results[2]!;

      return results;
    } else {
      // 결과 중 하나라도 null이면 예외 처리
      print('요청: error');
      throw Exception('API 요청 중 에러가 발생했습니다.');
    }
  }
}