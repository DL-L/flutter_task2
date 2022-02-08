import 'package:flutter/material.dart';

class SingleNotifier extends ChangeNotifier {
  String? _currentStatus;
  SingleNotifier();

  String? get currentStatus => _currentStatus;

  updateStatus(String value) {
    if (value != _currentStatus) {
      _currentStatus = value;
      notifyListeners();
    }
  }
}
