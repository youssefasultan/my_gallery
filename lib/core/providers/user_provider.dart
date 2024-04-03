import 'package:flutter/material.dart';
import 'package:my_gallery/src/auth/data/models/user_modal.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  void initUser(UserModel? user) {
    if (user != _user) _user = user;
    Future.delayed(Duration.zero, notifyListeners);
  }

  void logout() {
    _user = null;
    Future.delayed(Duration.zero, notifyListeners);
  }
}
