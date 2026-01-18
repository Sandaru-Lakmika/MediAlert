import 'package:flutter/foundation.dart';

/// A singleton notifier to trigger progress updates across the app
class ProgressNotifier extends ChangeNotifier {
  static final ProgressNotifier _instance = ProgressNotifier._internal();

  factory ProgressNotifier() {
    return _instance;
  }

  ProgressNotifier._internal();

  /// Call this method whenever a medicine activity occurs
  void notifyProgressUpdate() {
    notifyListeners();
  }
}
