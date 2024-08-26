import 'package:flutter/material.dart';

import '../api.dart';
import '../hive_service.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  final API _apiService;
  final HiveService _hiveService;

  UserProvider(this._hiveService, this._apiService);

  bool _isAuthenticated = false;

  User? get user => _hiveService.getUserBox();

  bool get isAuthenticated => _isAuthenticated;

  Future<void> signup(String email, String password) async {
    // _email = email;
    //_isAuthenticated = true;

    notifyListeners(); // Notify widgets listening to this provider
  }

  Future<void> login(String email, String password) async {
    return _apiService.login(email, password).then((data) {
      _isAuthenticated = true;
      _apiService.fetchUser(data.token).then((updatedUser) {
        print('$updatedUser');
        updatedUser.token = data.token;
        _hiveService.saveUserData(updatedUser);
        notifyListeners();
      });
    });
  }

  // Logout logic
  void logout() {
    _isAuthenticated = false;
    _hiveService.saveUserData(null);

    notifyListeners();
  }
}
