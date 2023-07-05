import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:story_ku/data/model/base_response.dart';
import 'package:story_ku/data/model/login.dart';
import 'package:story_ku/data/model/request/login_request.dart';
import 'package:story_ku/data/model/request/register_request.dart';

class ApiService {
  static const String _baseUrl = "https://story-api.dicoding.dev/v1";

  static final Uri _loginEndpoint = Uri.parse("$_baseUrl/login");
  static final Uri _registerEndpoint = Uri.parse("$_baseUrl/register");
  static final Uri _storiesEndpoint = Uri.parse("$_baseUrl/stories");

  Uri _detailStoryEndpoint(String id) => Uri.parse("$_baseUrl/stories/$id");

  Future<Login> login(LoginRequest request) async {
    final response = await http.post(_loginEndpoint, body: request.toJson());
    var login = Login.fromJson(json.decode(response.body));

    if (_isResponseSuccess(response.statusCode)) {
      return login;
    } else {
      throw Exception("${response.statusCode} - ${login.message}");
    }
  }

  Future<BaseResponse> register(RegisterRequest request) async {
    final response = await http.post(_registerEndpoint, body: request.toJson());
    var baseResponse = BaseResponse.fromJson(json.decode(response.body));

    if (_isResponseSuccess(response.statusCode)) {
      return baseResponse;
    } else {
      throw Exception("${response.statusCode} - ${baseResponse.message}");
    }
  }

  _isResponseSuccess(int statusCode) => (statusCode >= 200 && statusCode < 300);
}
