import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nota/models/user.dart';
import 'package:nota/services/dio.dart';

class Auth extends ChangeNotifier {
  String? token;
  bool? authenticated;

  User? user;

  String? authMessage;

  final storage = const FlutterSecureStorage();

  void login(Map creds) async {
    try {
      Response response = await dio().post("login", data: creds);

      if (response.statusCode == 200) {
        authenticated = true;
        user = User.fromJson(response.data['user']);
        await storage.write(key: "token", value: response.data['token']);
        token = response.data['token'];
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 401) {
        authenticated = false;
        authMessage = e.response!.data['message'];
      }
      authenticated = false;
      authMessage = e.response!.statusMessage;
    }

    notifyListeners();
  }

  void getUserData(token) async {
    try {
      Response response = await dio(token: token).get('me');

      if (response.statusCode == 200) {
        authenticated = true;
        user = User.fromJson(response.data['user']);
        this.token = token;
      }
    } on DioError catch (e) {
      await storage.delete(key: "token");
      if (e.response!.statusCode == 401) {
        authenticated = false;
        authMessage = e.response!.data['message'];
      }
      authenticated = false;
      authMessage = e.response!.statusMessage;
    }

    notifyListeners();
  }

  void updateUser(data) {
    user = User.fromJson(data);

    notifyListeners();
  }

  void logout() async {
    try {
      Response response = await dio(token: token).get('logout');

      if (response.statusCode == 200) {
        await storage.delete(key: "token");
        authenticated = null;
        token = null;
      }
    } on DioError catch (e) {
      print(e.response!.statusMessage);
    }
    notifyListeners();
  }
}
