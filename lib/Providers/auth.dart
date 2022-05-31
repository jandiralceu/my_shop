import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Helpers/url.dart';
import '../Domain/Models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expireDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get userId {
    return _userId;
  }

  String? get token {
    if (_expireDate != null &&
        _expireDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token as String;
    }

    return null;
  }

  Future<void> signup(String email, String password) async {
    try {
      final response = await http.post(UrlHelper.signupUrl(),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      final response = await http.post(UrlHelper.signInUrl(),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expireDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));

      autoSignout();
      notifyListeners();

      final preferences = await SharedPreferences.getInstance();
      // final userData = json.encode({
      //   'token': _token,
      //   'userId': _userId,
      //   'expiryDate': _expireDate!.toIso8601String(),
      // });

      preferences.setString(
          'userData',
          json.encode({
            'token': _token,
            'userId': _userId,
            'expiryDate': _expireDate!.toIso8601String(),
          }));
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signout() async {
    _token = null;
    _userId = null;
    _expireDate = null;

    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }

    notifyListeners();

    final preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  void autoSignout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expireDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), signout);
  }

  Future<bool> tryAutoSignIn() async {
    final preferences = await SharedPreferences.getInstance();

    if (!preferences.containsKey('userData')) return false;

    final extractedUserData = json.decode(
      preferences.getString('userData') as String,
    ) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate'] as String);

    if (_expireDate!.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'] as String;
    _userId = extractedUserData['userId'] as String;
    _expireDate = expiryDate;

    notifyListeners();
    autoSignout();

    return true;
  }
}
