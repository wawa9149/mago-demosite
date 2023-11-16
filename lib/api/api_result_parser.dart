import 'dart:convert';
import 'dart:developer';

class ApiResultParser {

  static String? getResultFromJson(
      String api, String jsonResponse, String status) {
    String message = 'Failed to get result';

    try {
      Map<String, dynamic> jsonObject = json.decode(jsonResponse);

      if (status == 'upload') {
        return _getUploadResult(jsonObject);
      }

      if (status == 'result') {
        if (api == 's2t') {
          return _getS2tResult(jsonObject);
        } else if (api == 'abm') {
          return _getAbmResult(jsonObject);
        } else if (api == 'emo') {
          return _getEmoResult(jsonObject);
        }
      }
    } catch (e) {
      log('Error parsing result: $e');
    }

    return message;
  }

  static String _getUploadResult(Map<String, dynamic> jsonObject) {
    String message = 'Failed to get id';
    try {
      Map<String, dynamic> contentsObject = jsonObject['contents'];
      return contentsObject['id'];
    } catch (e) {
      log('Error getting upload result: $e');
      return message;
    }
  }

  static String? _getS2tResult(Map<String, dynamic> jsonObject) {
    //String message = 'Failed:(';
    try {
      Map<String, dynamic> contentsObject = jsonObject['contents'];
      if (contentsObject.containsKey('results')) {
        Map<String, dynamic> results = contentsObject['results'];
        return json.encode(results['text']);
      } else {
        return null;
      }
    } catch (e) {
      log('Error getting s2t result: $e');
      return null;
    }
  }

  static String? _getAbmResult(Map<String, dynamic> jsonObject) {
    String message = 'Failed:(';
    try {
      Map<String, dynamic> contentsObject = jsonObject['contents'];
      if (contentsObject.containsKey('results')) {
        Map<String, dynamic> results = contentsObject['results'];
        if (results.containsKey('biomarkers') &&
            results['biomarkers'] is Map<String, dynamic>) {
          String contentsJsonString = json.encode(results['biomarkers']);
          return contentsJsonString;
        } else {
          return message;
        }
      } else if (contentsObject.containsKey('detail')) {
        return message;
      } else {
        return null;
      }
    } catch (e) {
      log('Error parsing result: $e');
      return null;
    }
  }

  static String? _getEmoResult(Map<String, dynamic> jsonObject) {
    try {
      Map<String, dynamic> contentsObject = jsonObject['contents'];
      Map<String, dynamic> resultsObject = contentsObject['results'];
      return json.encode(resultsObject['utterances']);
    } catch (e) {
      log('Error getting emo result: $e');
      return null;
    }
  }
}
