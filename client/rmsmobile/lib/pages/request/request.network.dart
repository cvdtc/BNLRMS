import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rmsmobile/apiService/apiService.dart';
import 'package:rmsmobile/model/request/filterrequest.model.dart';
import 'package:rmsmobile/model/request/request.model.dart';

final String _apiService = ApiService().baseUrl;
List<RequestModel> parsePermintaan(String responseBody) {
  var listSite = json.decode(responseBody)['data'] as List<dynamic>;
  return listSite.map((e) => RequestModel.fromJson(e)).toList();
}

Future<List<RequestModel>> fetchPermintaan(
    String token, FilterRequest data) async {
  print('xxxx' + data.toString());
  var url = Uri.parse(_apiService + 'permintaan');
  var response = await http.post(url,
      headers: {
        'content-type': 'application/json',
        // ++ fyi : sending token with BEARER
        'Authorization': 'Bearer ' + token
      },
      body: filterRequestToJson(data));
  print(data.toString());
  if (response.statusCode == 200) {
    return compute(parsePermintaan, response.body);
  } else {
    print(response.statusCode);
    return throw Exception(response.statusCode);
  }
}
