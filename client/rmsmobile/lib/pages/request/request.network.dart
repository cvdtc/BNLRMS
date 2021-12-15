import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/request/request.model.dart';

final String _apiService = ApiService().baseUrl;
List<RequestModel> parsePermintaan(String responseBody) {
  var listSite = json.decode(responseBody)['data'] as List<dynamic>;
  print(listSite);
  return listSite.map((e) => RequestModel.fromJson(e)).toList();
}

Future<List<RequestModel>> fetchPermintaan(String token) async {
  var url = Uri.parse(_apiService + 'permintaan');
  var response = await http.get(url, headers: {
    'content-type': 'application/json',
    // ++ fyi : sending token with BEARER
    'Authorization': 'Bearer ' + token
  });
  print("NETWORK permintaan? " + response.body);
  // return compute(parseSite, response.body);
  if (response.statusCode == 200) {
    return compute(parsePermintaan, response.body);
  } else {
    print("REQUEST STATUS CODE?" + response.statusCode.toString());
    // return compute(null, null);
    return throw Exception(response.statusCode);
  }
}
