import 'dart:convert';
import 'package:http/http.dart';
import 'package:rmsmobile/model/login/loginModel.dart';
import 'package:rmsmobile/model/login/loginResult.model.dart';
import 'package:rmsmobile/model/response/responsecode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {

  final String baseUrl = "http://server.bnl.id:9990/api/v1/";
  Client client = Client();
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
    print('Value Login ' + resultLogin.toString());
    print('tes rcode ${response.body}');
    print('tes jcode ${response.statusCode}');
    if (response.statusCode == 200) {
//      Share Preference
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString("access_token", "${loginresult.access_token}");
      sp.setString("username", "${loginresult.username}");
      sp.setString("jabatan", "${loginresult.jabatan}");
      // sp.setString("refresh_token", "${loginresult.refresh_token}");
      // sp.setString("nama", "${loginresult.nama}");
      return true;
    } else {
      return false;
    }
  }

 
}