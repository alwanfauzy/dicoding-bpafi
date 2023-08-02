import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_ku/data/api/api_service.dart';
import 'package:story_ku/util/enums.dart';

class DetailStoryProvider extends ChangeNotifier {
  final ApiService apiService;

  DetailStoryProvider(this.apiService);

  ResultState? _state;
  ResultState? get state => _state;

  String _message = "";
  String get message => _message;

  Future<dynamic> getDetailStory(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final detailStoryResult = await apiService.getDetailStory(id);

      if (detailStoryResult.story != null) {
        _state = ResultState.hasData;

        _message = detailStoryResult.message ?? "Get Detail Story Success";
      } else {
        _state = ResultState.noData;

        _message = detailStoryResult.message ?? "Get Detail Story Failed";
      }
    } on SocketException {
      _state = ResultState.error;

      _message = "Error: No Internet Connection";
    } catch (e) {
      _state = ResultState.error;

      _message = "Error: $e";
    } finally {
      notifyListeners();
    }
  }
}
