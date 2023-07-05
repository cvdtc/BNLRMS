import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/perpanjangan/perpanjangan.model.dart';
import 'package:rmsmobile/model/request/request.model.dart';

final String _apiService = ApiService().baseUrl;
List<PerpanjanganModel> parsePerpanjangan(String responseBody) {
  var listSite = json.decode(responseBody)['data'] as List<dynamic>;
  return listSite.map((e) => PerpanjanganModel.fromJson(e)).toList();
}

Future<List<PerpanjanganModel>> fetchPerpanjangan(String token) async {
  var url = Uri.parse(_apiService + 'perpanjangan');
  var response = await http.get(url, headers: {
    'content-type': 'application/json',
    // ++ fyi : sending token with BEARER
    'Authorization': 'Bearer ' + token
  });
  if (response.statusCode == 200) {
    return compute(parsePerpanjangan, response.body);
  } else {
    return throw Exception(response.statusCode);
  }
}
