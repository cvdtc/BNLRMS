import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rmsmobile/model/merekinternasional/merekinternasional.dart';
import 'package:rmsmobile/model/merekinternasional/timeline.merekinternasional.dart';
import '../../../apiService/apiService.dart';

final String _apiService = ApiService().baseUrl;
List<DataMerekInternasionalModel> parseMerekInternasional(String responseBody) {
  var listSite = json.decode(responseBody)['data'] as List<dynamic>;
  return listSite.map((e) => DataMerekInternasionalModel.fromJson(e)).toList();
}

Future<List<DataMerekInternasionalModel>> fetchMerekInternasional(
    String token) async {
  var url = Uri.parse(_apiService + 'merekinternasional');
  var response = await http.get(url, headers: {
    'content-type': 'application/json',
    // ++ fyi : sending token with BEARER
    'Authorization': 'Bearer ' + token
  });
  print(response.body);
  if (response.statusCode == 200) {
    return compute(parseMerekInternasional, response.body);
  } else {
    return throw Exception(response.statusCode);
  }
}

List<TimelineMerekInternasionalModel> parseTimelineMerekInternasional(
    String responseBody) {
  var listSite = json.decode(responseBody)['data'] as List<dynamic>;
  return listSite
      .map((e) => TimelineMerekInternasionalModel.fromJson(e))
      .toList();
}

Future<List<TimelineMerekInternasionalModel>> fetchTimelineMerekInternasional(
    String kode, String token) async {
  var url = Uri.parse(_apiService + 'timelinemerekinternasional/' + kode);
  var response = await http.get(url, headers: {
    'content-type': 'application/json',
    // ++ fyi : sending token with BEARER
    'Authorization': 'Bearer ' + token
  });
  if (response.statusCode == 200) {
    return compute(parseTimelineMerekInternasional, response.body);
  } else {
    return throw Exception(response.statusCode);
  }
}
