import 'dart:convert';

import 'package:firebase_cloud_messaging/firebase_cloud_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skishool/data/api.dart';
import 'package:skishool/data/shared_prefs.dart';
import 'package:skishool/models/instructor.dart';
import 'package:skishool/models/lesson.dart';
import 'package:skishool/models/token.dart';

class Auth extends ChangeNotifier {
  Instructor _user;
  Token _token;
  List<Lesson> _lessons = [];

  bool _alreadySend = false;

  String _firebaseToken;

  Instructor get user => _user;

  Token get token => _token;

  List<Lesson> get lessons => _lessons;

  bool get alreadySend => _alreadySend;

  set alreadySend(bool alreadySend) {
    _alreadySend = alreadySend;
  }

  void loadSettings() async {
    try {
      _user = await SharedPref.getInstructor();

      _token = await SharedPref.getToken();

      if (_token != null) {
        getLessons();
      }

      notifyListeners();
    } catch (e) {
      print("User Not Found: $e");
    }
  }

  Future<Instructor> getMe(String token) async {
    try {
      print("Getting me: ${_token.token}");
      var instructor = await Api.me(token);
      _user = instructor;
      SharedPref.saveInstructor(instructor);
      return instructor;
    } catch (e) {
      print("Could Not Load Data: $e");
      return null;
    }
  }

  Future<List<Lesson>> getLessons() async {
    try {
      print("Getting lessons: ${_token.token}");
      var lessons = await Api.lessons(_token.token);
      _lessons = lessons;
      notifyListeners();
      return lessons;
    } catch (e) {
      print("Could Not Load Data: $e");
      return null;
    }
  }

  Future<bool> login(
    String email,
    String password,
  ) async {
    Token token = await Api.login(email, password);
    _token = token;
    SharedPref.saveToken(token);

    if (!alreadySend) {
      postFirebaseToken(_firebaseToken);
    }

    // Get Info For User
    Instructor _instructor = await getMe(token.token);
    if (_instructor != null) {
      _user = _instructor;
      notifyListeners();
    }
    getLessons();

    if (token == null || _user == null) return false;
    return true;
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    _lessons = [];
    SharedPref.deleteToken();
    SharedPref.deleteInstructor();
    notifyListeners();
    return;
  }

  void postFirebaseToken(String firebaseToken) {
    if (token != null) {
      Api.firebaseToken(token.token, firebaseToken);
      alreadySend = true;
    }
  }

  void setFirebaseToken(String token) {
    _firebaseToken = token;
  }


}
