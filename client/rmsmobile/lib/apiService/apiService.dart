import 'dart:convert';
import 'package:http/http.dart';
import 'package:rmsmobile/model/dashboard/dashboard.model.dart';
import 'package:rmsmobile/model/login/loginModel.dart';
import 'package:rmsmobile/model/login/loginResult.model.dart';
import 'package:rmsmobile/model/merekinternasional/dashboard.merekinternasional.dart';
import 'package:rmsmobile/model/pengguna/pengguna.model.dart';
import 'package:rmsmobile/model/pengguna/pengguna.model.gantipassword.dart';
import 'package:rmsmobile/model/perpanjangan/perpanjangan.model.dart';
import 'package:rmsmobile/model/progress/progress.model.dart';
import 'package:rmsmobile/model/request/request.model.dart';
import 'package:rmsmobile/model/response/responsecode.dart';
import 'package:rmsmobile/model/timeline/timeline.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = "http://server.bnl.id:9990/api/v1/"; // ++ for server
  // final String baseUrl =
  //     "http://192.168.1.213:9990/api/v1/"; // ++ for development
  Client client = Client();
  String? token = "";

  ResponseCode responseCode = ResponseCode();

//  LOGIN
  Future<bool> loginIn(LoginModel data) async {
    var url = Uri.parse(baseUrl + 'login');
    var response = await client.post(url,
        headers: {'content-type': 'application/json'}, body: loginToJson(data));

    Map resultLogin = jsonDecode(response.body);
    var loginresult = LoginResult.fromJson(resultLogin);

    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
//      Share Preference
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString("access_token", "${loginresult.access_token}");
      sp.setString("refresh_token", "${loginresult.refresh_token}");
      sp.setString("username", "${loginresult.username}");
      sp.setString("jabatan", "${loginresult.jabatan}");
      sp.setString("nama", "${loginresult.nama}");
      sp.setString("idpengguna", '${loginresult.idpengguna.toString()}');
      sp.setBool("notif_permintaan", true);
      sp.setBool("notif_progress", true);
      return true;
    } else {
      return false;
    }
  }

  ///////////////////// MODEL ALL REQUEST : GET, PUT, POST, DEL ////////////////////////////////

  Future<List<RequestModel>?> getListRequest(String token) async {
    var url = Uri.parse(baseUrl + 'permintaand');
    var response = await client.get(url, headers: {
      'content-type': 'application/json',
      // ++ fyi : sending token with BEARER
      'Authorization': 'Bearer ' + token
    });
    // ++ fyi : for getting response message from api
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return RequestModelFromJson(response.body);
    } else {
      return null;
    }
  }

  // ! Add Data Request
  Future<bool> addRequest(String token, RequestModel data) async {
    var url = Uri.parse(baseUrl + 'addpermintaan');
    var response = await client.post(url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${token}'
        },
        body: RequestModelToJson(data));
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addRequestDanProgress(
      String token,
      String keterangan,
      String kategori,
      String due_date,
      String flag_selesai,
      String url_web,
      String next_idpengguna,
      String keterangan_progress) async {
    var url = Uri.parse(baseUrl + 'addpermintaandanprogress');
    var response = await client.post(url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${token}'
        },
        body: jsonEncode(<String, String>{
          "keterangan": keterangan,
          "kategori": kategori,
          "due_date": due_date,
          "flag_selesai": flag_selesai,
          "url_web": url_web,
          "next_idpengguna": next_idpengguna,
          "keterangan_progress": keterangan_progress,
        }));
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> ubahRequest(
      String token, String idpermintaan, RequestModel data) async {
    var url = Uri.parse(baseUrl + 'permintaan' + '/' + idpermintaan);
    var response = await client.put(url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${token}'
        },
        body: RequestModelToJson(data));
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> hapusRequest(String token, String idpermintaan) async {
    var url = Uri.parse(baseUrl + 'permintaan/' + idpermintaan.toString());
    var response = await client.delete(url, headers: {
      'content-type': 'application/json',
      'Authorization': 'Bearer ${token}'
    });
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  ///////////////////// END MODEL ALL REQUEST : GET, PUT, POST, DEL ////////////////////////////////

  // ! Add Data Request
  Future<bool> addProgres(String token, ProgressModel data) async {
    var url = Uri.parse(baseUrl + 'progress');
    var response = await client.post(url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${token}'
        },
        body: ProgressToJson(data));
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    print('RESPON ADD PROGRESS' + response.body);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<ProgressModel>?> getListProgres(String token) async {
    var url = Uri.parse(baseUrl + 'progress');
    var response = await client.get(url, headers: {
      'content-type': 'application/json',
      // ++ fyi : sending token with BEARER
      'Authorization': 'Bearer ' + token
    });
    // ++ fyi : for getting response message from api
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);

    if (response.statusCode == 200) {
      return ProgressModelFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<bool> ubahProgres(
      String token, String idprogress, ProgressModel data) async {
    var url = Uri.parse(baseUrl + 'progress' + '/' + idprogress);
    var response = await client.put(url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${token}'
        },
        body: ProgressToJson(data));
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<PenggunaModel>?> getPengguna(String token) async {
    var url = Uri.parse(baseUrl + 'pengguna');
    var response = await client.get(url, headers: {
      'content-type': 'application/json',
      // ++ fyi : sending token with BEARER
      'Authorization': 'Bearer ' + token
    });
    // ++ fyi : for getting response message from api
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return PenggunaModelFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<bool> ubahPassword(String token, ChangePassword data) async {
    var url = Uri.parse(baseUrl + 'pengguna');
    var response = await client.put(url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${token}'
        },
        body: ChangePasswordToJson(data));
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<TimelineModel>?> getListTimeline(
      String token, String idpermintaan) async {
    var url = Uri.parse(baseUrl + 'timeline/' + idpermintaan);
    var response = await client.get(url, headers: {
      'content-type': 'application/json',
      // ++ fyi : sending token with BEARER
      'Authorization': 'Bearer ' + token
    });
    // ++ fyi : for getting response message from api
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return timelineFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<List<DashboardModel>?> getDashboard(String token) async {
    var url = Uri.parse(baseUrl + 'dashboard');
    var response = await client.get(url, headers: {
      'content-type': 'application/json',
      // ++ fyi : sending token with BEARER
      'Authorization': 'Bearer ' + token
    });
    // ++ fyi : for getting response message from api
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return dashboardFromJson(response.body);
      // return compute(parseDashboard, response.body);
    } else {
      return null;
      // throw Exception(response.statusCode);
    }
  }

  Future<List<PerpanjanganModel>?> getListPerpanjangan(String token) async {
    var url = Uri.parse(baseUrl + 'perpanjangan');
    var response = await client.get(url, headers: {
      'content-type': 'application/json',
      // ++ fyi : sending token with BEARER
      'Authorization': 'Bearer ' + token
    });
    // ++ fyi : for getting response message from api
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);

    if (response.statusCode == 200) {
      return PerpanjanganModelFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<List<DataDashboardMerekInternasionalModel>?>
      getListDashboardMerekInternasional(String token) async {
    var url = Uri.parse(baseUrl + 'dashboardmerekinternasional');
    var response = await client.get(url, headers: {
      'content-type': 'application/json',
      // ++ fyi : sending token with BEARER
      'Authorization': 'Bearer ' + token
    });
    // ++ fyi : for getting response message from api
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);

    if (response.statusCode == 200) {
      return DashboardMerekInternasionalModelFromJson(response.body);
    } else {
      return null;
    }
  }
}
