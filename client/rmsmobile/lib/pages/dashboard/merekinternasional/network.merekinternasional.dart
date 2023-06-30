import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:rmsmobile/model/merekinternasional/dashboard.merekinternasional.dart';

import 'package:http/http.dart' as http;
import '../../../apiService/apiService.dart';

final String _apiService = ApiService().baseUrl;
List<DashboardMerekInternasionalModel> parseDashboardMerekInternasional(
    String responseBody) {
  var listSite = json.decode(responseBody)['data'] as List<dynamic>;
  return listSite
      .map((e) => DashboardMerekInternasionalModel.fromJson(e))
      .toList();
}

Future<List<DashboardMerekInternasionalModel>> fetchDashboardMerekInternasional(
    String token) async {
  var url = Uri.parse(_apiService + 'dashboardmerekinternasional');
  var response = await http.get(url, headers: {
    'content-type': 'application/json',
    // ++ fyi : sending token with BEARER
    'Authorization': 'Bearer ' + token
  });
  if (response.statusCode == 200) {
    return compute(parseDashboardMerekInternasional, response.body);
  } else {
    return throw Exception(response.statusCode);
  }
}
