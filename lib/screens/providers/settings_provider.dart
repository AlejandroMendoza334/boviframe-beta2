import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  String? _userName;
  String? _userEmail;
  String? _userCompany;

  String get userName    => _userName ?? '';
  String get userEmail   => _userEmail ?? '';
  String get userCompany => _userCompany ?? '';

  /// Llama a este método cuando obtengas el nombre, correo y empresa del usuario
  setUserData({
    required String name,
    required String email,
    required String company,
  }) {
    _userName    = name;
    _userEmail   = email;
    _userCompany = company;
    notifyListeners();
  }
}
