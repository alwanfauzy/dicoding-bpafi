import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:story_ku/data/model/base_response.dart';
import 'package:story_ku/data/model/detail_story.dart';
import 'package:story_ku/data/model/login.dart';
import 'package:story_ku/data/model/request/login_request.dart';
import 'package:story_ku/data/model/request/register_request.dart';
import 'package:story_ku/data/model/request/add_story_request.dart';
import 'package:story_ku/data/model/stories.dart';
import 'package:story_ku/data/pref/token_pref.dart';

class ApiService {
  static const String _baseUrl = "https://story-api.dicoding.dev/v1";

  static final Uri _loginEndpoint = Uri.parse("$_baseUrl/login");
  static final Uri _registerEndpoint = Uri.parse("$_baseUrl/register");
  static final Uri _storiesEndpoint = Uri.parse("$_baseUrl/stories");

  Uri _detailStoryEndpoint(String id) => Uri.parse("$_baseUrl/stories/$id");

  Future<Login> login(LoginRequest request) async {
    final response = await http
        .post(_loginEndpoint, body: request.toJson())
        .timeout(const Duration(seconds: 10));
    var login = Login.fromJson(json.decode(response.body));

    if (_isResponseSuccess(response.statusCode)) {
      return login;
    } else {
      throw Exception("${response.statusCode} - ${login.message}");
    }
  }

  Future<BaseResponse> register(RegisterRequest request) async {
    final response = await http
        .post(_registerEndpoint, body: request.toJson())
        .timeout(const Duration(seconds: 10));

    var baseResponse = BaseResponse.fromJson(json.decode(response.body));

    if (_isResponseSuccess(response.statusCode)) {
      return baseResponse;
    } else {
      throw Exception("${response.statusCode} - ${baseResponse.message}");
    }
  }

  Future<Stories> getStories() async {
    var tokenPref = TokenPref();
    var token = await tokenPref.getToken();

    final response = await http.get(_storiesEndpoint, headers: {
      'Authorization': 'Bearer $token',
    }).timeout(const Duration(seconds: 10));

    var stories = Stories.fromJson(json.decode(response.body));

    if (_isResponseSuccess(response.statusCode)) {
      return stories;
    } else {
      throw Exception("${response.statusCode} - ${stories.message}");
    }
  }

  Future<DetailStory> getDetailStory(String id) async {
    var tokenPref = TokenPref();
    var token = await tokenPref.getToken();

    final response = await http.get(_detailStoryEndpoint(id), headers: {
      'Authorization': 'Bearer $token',
    }).timeout(const Duration(seconds: 10));

    var detailStory = DetailStory.fromJson(json.decode(response.body));

    if (_isResponseSuccess(response.statusCode)) {
      return detailStory;
    } else {
      throw Exception("${response.statusCode} - ${detailStory.message}");
    }
  }

  Future<BaseResponse> addStory(AddStoryRequest story) async {
    var tokenPref = TokenPref();
    var token = await tokenPref.getToken();

    final request = http.MultipartRequest('POST', _storiesEndpoint);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['description'] = story.description;
    request.files.add(http.MultipartFile(
      'photo',
      story.photo.readAsBytes().asStream(),
      story.photo.lengthSync(),
      filename: story.photo.path.split('/').last,
    ));
    if (story.lat != null) {
      request.fields['lat'] = story.lat.toString();
      request.fields['lon'] = story.lon.toString();
    }

    final response = await request.send();

    if (_isResponseSuccess(response.statusCode)) {
      String responseBody = await response.stream.bytesToString();
      return BaseResponse.fromJson(json.decode(responseBody));
    } else {
      throw Exception("${response.statusCode} - Error when upload story");
    }
  }

  _isResponseSuccess(int statusCode) => (statusCode >= 200 && statusCode < 300);
}
