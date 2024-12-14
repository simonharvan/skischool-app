import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:skischool/models/instructor.dart';
import 'package:skischool/models/token.dart';
import 'package:skischool/utils/logger.dart';

class SharedPref {
  static const String TOKEN = 'token_data';
  static const String INSTRUCTOR = 'instructor_data';

  static saveToken(Token token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _save = json.encode(token.toJson());
    Log.d("Save data TOKEN: $_save");
    prefs.setString(TOKEN, _save);
  }

  static deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(TOKEN);
  }

  static Future<Token?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _saved = prefs.getString(TOKEN);
    if (_saved == null) {
      return null;
    }
    return Token.fromJson(json.decode(_saved));
  }

  static saveInstructor(Instructor instructor) async {
    if (instructor == null) {
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _save = json.encode(instructor.toJson());
    Log.d("Save data INSTRUCTOR: $_save");
    prefs.setString(INSTRUCTOR, _save);
  }

  static deleteInstructor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(INSTRUCTOR);
  }

  static Future<Instructor?> getInstructor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _saved = prefs.getString(INSTRUCTOR);
    if (_saved == null) {
      return null;
    }
    return Instructor.fromJson(json.decode(_saved));
  }
}
