import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_ku/data/api/api_service.dart';
import 'package:story_ku/data/model/request/login_request.dart';
import 'package:story_ku/data/pref/token_pref.dart';
import 'package:story_ku/util/enums.dart';

class LoginProvider extends ChangeNotifier {
  final ApiService apiService;
  final TokenPref tokenPref;

  LoginProvider(this.apiService, this.tokenPref);

  ResultState? _loginState;
  ResultState? get loginState => _loginState;

  String _loginMessage = "";
  String get loginMessage => _loginMessage;

  Future<dynamic> login(LoginRequest request) async {
    try {
      _loginState = ResultState.loading;
      notifyListeners();

      final loginResult = await apiService.login(request);

      if (loginResult.error != true) {
        _loginState = ResultState.hasData;
        tokenPref.setToken(loginResult.loginResult?.token ?? "");

        _loginMessage = loginResult.message ?? "Login Success";
      } else {
        _loginState = ResultState.noData;

        _loginMessage = loginResult.message ?? "Login Failed";
      }
    } on SocketException {
      _loginState = ResultState.error;

      _loginMessage = "Error: No Internet Connection";
    } catch (e) {
      _loginState = ResultState.error;

      _loginMessage = "Error: $e";
    } finally {
      notifyListeners();
    }
  }
}
