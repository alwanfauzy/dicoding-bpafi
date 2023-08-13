import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_ku/data/api/api_service.dart';
import 'package:story_ku/util/enums.dart';

class MapProvider extends ChangeNotifier {
  final ApiService apiService;
  final LatLng location;

  MapProvider(this.apiService, this.location) {
    getAddress(location);
  }

  ResultState? _state;
  ResultState? get state => _state;

  String _address = "-";
  String get address => _address;

  String _message = "Success";
  String get message => _message;

  Future<dynamic> getAddress(LatLng location) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final addressResult = await apiService.getAddress(location);

      _state = ResultState.hasData;

      _address = addressResult;
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
