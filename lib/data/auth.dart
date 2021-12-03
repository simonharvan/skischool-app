import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skischool/data/api.dart';
import 'package:skischool/data/result.dart';
import 'package:skischool/data/shared_prefs.dart';
import 'package:skischool/models/instructor.dart';
import 'package:skischool/models/lesson.dart';
import 'package:skischool/models/token.dart';
import 'package:skischool/utils/logger.dart';

class Auth extends ChangeNotifier {
  static const PAGE_SIZE = 15;

  Instructor _user;
  Token _token;
  Result<List<Lesson>> _lessons = Result<List<Lesson>>(data: []);

  bool alreadySend = false;

  String _firebaseToken;

  Instructor get user => _user;

  Token get token => _token;

  Result<List<Lesson>> get lessons => _lessons;

  void loadSettings() async {
    try {
      _user = await SharedPref.getInstructor();

      _token = await SharedPref.getToken();

      if (_token != null) {
        getLessons();
      }

      notifyListeners();
    } catch (e) {
      Log.w("User Not Found: $e");
    }
  }

  Future<Instructor> getMe(String token) async {
    try {
      Log.d("Getting me: ${_token.token}");
      var instructor = await Api.me(token);
      _user = instructor;
      SharedPref.saveInstructor(instructor);
      return instructor;
    } catch (e) {
      Log.w("Could not load me: $e");
      return null;
    }
  }

  Future<List<Lesson>> getLessons({int offset = 0}) async {
    _lessons.state = ResultState.loading;
    notifyListeners();
    try {
      Log.d("Getting lessons: ${_token.token}");
      var lessons = await Api.lessons(_token.token, offset, PAGE_SIZE);
      _lessons.data = lessons;
      _lessons.state = ResultState.standard;
      notifyListeners();
      return lessons;
    } catch (e) {
      Log.w("Could not load lessons: $e");
      _lessons.state = ResultState.error;
      notifyListeners();
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
    _lessons.data = [];
    _lessons.state = ResultState.standard;
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
