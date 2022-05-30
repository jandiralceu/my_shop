import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Helpers/url.dart';
import '../Domain/Models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expireDate;
  String? _userId;

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

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
