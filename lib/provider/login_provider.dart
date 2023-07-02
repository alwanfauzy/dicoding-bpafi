import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_ku/data/api/api_service.dart';
import 'package:story_ku/util/enums.dart';

class LoginProvider extends ChangeNotifier {
  final ApiService apiService;

  LoginProvider(this.apiService);

  late ResultState _loginState;
  late ResultState _registerState;

  ResultState get loginState => _loginState;
  ResultState get registerState => _registerState;

  String _loginMessage = "";
  String _registerMessage = "";

  String get loginMessage => _loginMessage;
  String get registerMessage => _registerMessage;

  Future<dynamic> login() async {
    try {
      _loginState = ResultState.loading;
      notifyListeners();

      final loginResult = await apiService.login();

      if (loginResult.error != true) {
        _loginState = ResultState.hasData;
        notifyListeners();

        return _loginMessage = loginResult.message ?? "Login Success";
      } else {
        _loginState = ResultState.noData;
        notifyListeners();

        return _loginMessage = loginResult.message ?? "Login Failed";
      }
    } on SocketException {
      _loginState = ResultState.error;
      notifyListeners();

      return _loginMessage = "Error: No Internet Connection";
    } catch (e) {
      _loginState = ResultState.error;
      notifyListeners();

      return _loginMessage = "Error: $e";
    }
  }

  Future<dynamic> register() async {
    try {
      _registerState = ResultState.loading;
      notifyListeners();

      final registerResult = await apiService.register();

      if (registerResult.error != true) {
        _registerState = ResultState.hasData;
        notifyListeners();

        return _registerMessage = registerResult.message ?? "Account Created";
      } else {
        _registerState = ResultState.noData;
        notifyListeners();

        return _registerMessage = registerResult.message ?? "Register Failed";
      }
    } on SocketException {
      _registerState = ResultState.error;
      notifyListeners();

      return _loginMessage = "Error: No Internet Connection";
    } catch (e) {
      _registerState = ResultState.error;
      notifyListeners();

      return _loginMessage = "Error: $e";
    }
  }
}
