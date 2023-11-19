import 'dart:convert';
import 'dart:developer';

class ApiResultParser {
  static String? getResultFromJson(
      String api, String jsonResponse, String status) {
    try {
      Map<String, dynamic> jsonObject = json.decode(jsonResponse);

      if (status == 'upload') {
        return _getResult(_getUploadResult, jsonObject);
      }

      if (status == 'result') {
        if (api == 's2t') {
          return _getResult(_getS2tResult, jsonObject);
        } else if (api == 'abm') {
          return _getResult(_getAbmResult, jsonObject);
        } else if (api == 'emo') {
          return _getResult(_getEmoResult, jsonObject);
        }
      }
    } catch (e) {
      log('Error parsing result: $e');
    }

    return 'Failed to get result';
  }

  static String? _getResult(
      String? Function(Map<String, dynamic>) getResultFunction,
      Map<String, dynamic> jsonObject) {
    try {
      return getResultFunction(jsonObject['contents']);
    } catch (e) {
      log('Error getting result: $e');
      return null;
    }
  }

  static String? _getUploadResult(Map<String, dynamic> contentsObject) {
    return contentsObject['id'];
  }

  static String? _getS2tResult(Map<String, dynamic> contentsObject) {
    if (contentsObject.containsKey('results')) {
      Map<String, dynamic> results = contentsObject['results'];
      return json.encode(results['text']);
    }
    return null;
  }

  static String? _getAbmResult(Map<String, dynamic> contentsObject) {
    if (contentsObject.containsKey('results')) {
      Map<String, dynamic> results = contentsObject['results'];
      if (results.containsKey('biomarkers') &&
          results['biomarkers'] is Map<String, dynamic>) {
        return json.encode(results['biomarkers']);
      }
    } else if (contentsObject.containsKey('detail')) {
      return 'Failed:(';
    }
    return null;
  }

  static String? _getEmoResult(Map<String, dynamic> contentsObject) {
    if (contentsObject.containsKey('results')) {
      Map<String, dynamic> resultsObject = contentsObject['results'];
      return json.encode(resultsObject['utterances']);
    }
    return null;
  }
}
