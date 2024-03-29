import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:thinktank_mobile/api/firebase_message_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';

class ApiAuthentication {
  static Future<bool> logOut() async {
    Account? account = await SharedPreferencesHelper.getInfo();
    if (account == null) return false;
    final response = await http.post(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/accounts/token-revoke?userId=${account.id}'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      await SharedPreferencesHelper.removeAllofLogout();
      return true;
    } else {
      print("logout loi");
      return false;
    }
  }

  static Future<bool> forgotpassword(String username, String email) async {
    final response = await http.post(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/accounts/forgotten-password?Email=$email&Username=$username'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<Account?> loginWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        String? fcmToken = await FirebaseMessageAPI().getToken();
        print("fcm:" + (fcmToken ?? "khong co"));
        Map<String, String> loginData = {
          "googleId": googleSignInAccount.id,
          "fcm": fcmToken ?? "",
          "avatar": googleSignInAccount.photoUrl ?? "",
          "email": googleSignInAccount.email,
          "fullName": googleSignInAccount.displayName ?? "Anonymous"
        };

        String jsonBody = jsonEncode(loginData);

        print(jsonBody);

        final response = await http.post(
          Uri.parse(
              'https://thinktank-sep490.azurewebsites.net/api/accounts/google-authentication'),
          headers: {'Content-Type': 'application/json'},
          body: jsonBody,
        );

        print("Robinho " + jsonBody);
        print(response.statusCode);

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          return Account.fromJson(jsonData);
        } else {
          return null;
        }
      } else {
        print('loi dang nhap');
        return null;
      }
    } catch (error) {
      print('loi :' + error.toString());
      return null;
    }
  }

  static Future<Account?> reLogin() async {
    Account? account = await SharedPreferencesHelper.getInfo();
    if (account == null) return null;

    Map<String, String?> data = {
      "accessToken": account.accessToken,
      "refreshToken": account.refreshToken,
    };
    String jsonBody = jsonEncode(data);
    final response = await http.post(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/accounts/token-verification'),
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      await SharedPreferencesHelper.saveInfo(Account.fromJson(jsonData));
      return Account.fromJson(jsonData);
    } else if (response.statusCode == 401 || response.body != null) {
      final jsonData2 = json.decode(response.body);
      if (jsonData2['error'].toString() == "Unauthorized") {
        await SharedPreferencesHelper.saveInfo(account);
        return account;
      } else {
        await SharedPreferencesHelper.removeInfo();
        return null;
      }
    } else {
      await SharedPreferencesHelper.removeInfo();
      return null;
    }
  }

  static Future<Account?> login(
      String username, String password, String fcmToken) async {
    Map<String, String> loginData = {
      "userName": username,
      "password": password,
      "fcm": fcmToken
    };
    String jsonBody = jsonEncode(loginData);

    final response = await http.post(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/accounts/authentication-player'),
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      FirebaseRealTime.setOnline(Account.fromJson(jsonData).id, true);
      return Account.fromJson(jsonData);
    } else {
      return null;
    }
  }

  static Future<http.Response> register(
      String fullname, String username, String email, String password) async {
    Map<String, String?> data = {
      "fullName": fullname,
      "userName": username,
      "email": email,
      "password": password,
      "fcm": null,
      "googleId": null
    };
    String jsonBody = jsonEncode(data);
    final response = await http.post(
      Uri.parse('https://thinktank-sep490.azurewebsites.net/api/accounts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );
    return response;
  }

  static Future<Account?> refreshToken(
    String? refreshToken,
    String? accessToken,
  ) async {
    Map<String, String?> data = {
      "accessToken": accessToken,
      "refreshToken": refreshToken,
    };
    String jsonBody = jsonEncode(data);
    final response = await http.post(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/accounts/token-verification'),
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Account.fromJson(jsonData);
    } else {
      return null;
    }
  }
}
