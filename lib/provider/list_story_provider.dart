import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_ku/data/api/api_service.dart';
import 'package:story_ku/data/model/story.dart';
import 'package:story_ku/util/enums.dart';

class ListStoryProvider extends ChangeNotifier {
  final ApiService apiService;

  ListStoryProvider(this.apiService) {
    getStories();
  }

  ResultState? _state;
  ResultState? get state => _state;

  String _message = "";
  String get message => _message;

  final List<Story> _stories = [];
  List<Story> get stories => _stories;

  int page = 1;
  int size = 20;

  Future<dynamic> getStories({bool isRefresh = false}) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      if (isRefresh) {
        page = 1;
        _stories.clear();
      }
      final storiesResult = await apiService.getStories(page, size);

      if (storiesResult.listStory?.isNotEmpty == true) {
        _state = ResultState.hasData;
        _stories.addAll(storiesResult.listStory ?? List.empty());

        _message = storiesResult.message ?? "Get Stories Success";
        page++;
      } else {
        _state = ResultState.noData;

        _message = storiesResult.message ?? "Get Stories Failed";
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
