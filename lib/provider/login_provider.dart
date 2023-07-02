import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_ku/data/api/api_service.dart';
import 'package:story_ku/util/enums.dart';

class LoginProvider extends ChangeNotifier {
  final ApiService apiService;

  LoginProvider(this.apiService);

  ResultState? _loginState;
  ResultState? get loginState => _loginState;

  String _loginMessage = "";
  String get loginMessage => _loginMessage;

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
}
