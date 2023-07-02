import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:story_ku/data/model/base_response.dart';
import 'package:story_ku/data/model/login.dart';
import 'package:story_ku/data/model/request/register_request.dart';

class ApiService {
  static const String _baseUrl = "https://story-api.dicoding.dev/v1";

  static final Uri _loginEndpoint = Uri.parse("$_baseUrl/login");
  static final Uri _registerEndpoint = Uri.parse("$_baseUrl/register");
  static final Uri _storiesEndpoint = Uri.parse("$_baseUrl/stories");

  Uri _detailStoryEndpoint(String id) => Uri.parse("$_baseUrl/stories/$id");

  Future<Login> login() async {
    final response = await http.get(_loginEndpoint);
    if (response.statusCode == 200) {
      return Login.fromJson(json.decode(response.body));
    } else {
      throw Exception("${response.statusCode} - ${response.body}");
    }
  }

  Future<BaseResponse> register(RegisterRequest request) async {
    final response = await http.post(_registerEndpoint, body: request.toJson());
    if (response.statusCode == 200) {
      return BaseResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception("${response.statusCode} - ${response.body}");
    }
  }
}
