import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/pengguna/pengguna.model.dart';

final String _apiService = ApiService().baseUrl;
List<PenggunaModel> parsePengguna(String responseBody) {
  var listSite = json.decode(responseBody)['data'] as List<dynamic>;
  print(listSite);
  return listSite.map((e) => PenggunaModel.fromJson(e)).toList();
}

Future<List<PenggunaModel>> fetchPengguna(String token) async {
  var url = Uri.parse(_apiService + 'pengguna');
  var response = await http.get(url, headers: {
    'content-type': 'application/json',
    // ++ fyi : sending token with BEARER
    'Authorization': 'Bearer ' + token
  });
  print("NETWORK permintaan? " + token);
  if (response.statusCode == 200) {
    print('Success?');
    return compute(parsePengguna, response.body);
  } else {
    throw Exception(response.statusCode);
  }
}
