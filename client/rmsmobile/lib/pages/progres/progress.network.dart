import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/progress/progress.model.dart';

final String _apiService = ApiService().baseUrl;
List<ProgressModel> parseSite(String responseBody) {
  var listSite = json.decode(responseBody)['data'] as List<dynamic>;
  print(listSite);
  return listSite.map((e) => ProgressModel.fromJson(e)).toList();
}

Future<List<ProgressModel>> fetchProgress(String token) async {
  var url = Uri.parse(_apiService + 'progress');
  var response = await http.get(url, headers: {
    'content-type': 'application/json',
    // ++ fyi : sending token with BEARER
    'Authorization': 'Bearer ' + token
  });
  print("NETWORK permintaan? " + token);
  if (response.statusCode == 200) {
    print('Success?');
    return compute(parseSite, response.body);
  } else if(response.statusCode == 401){
    print('Gagal dsini!');
    return compute(parseSite, response.body[401]);
  }else{
    print('Gagal ! ${response.statusCode}');
    throw Exception(response.statusCode);
  }
}
