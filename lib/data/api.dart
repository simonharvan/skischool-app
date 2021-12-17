import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:skischool/models/instructor.dart';
import 'package:skischool/models/lesson.dart';
import 'package:skischool/models/token.dart';
import 'package:skischool/utils/logger.dart';

const String API_URL = 'https://api.skischool.bero.tech/api';

class Api {
  static Future<Token> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(API_URL + '/instructor/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'instructor': {'email': email, 'password': password},
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 CREATED response,
      // then parse the JSON.
      return Token.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      Log.d('Response from API ' + response.statusCode.toString());
      Log.d(response.body);
      throw Exception(response);
    }
  }

  static Future<Instructor> me(String token) async {
    final response =
        await http.get(Uri.parse(API_URL + '/instructor/me'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + token,
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 GET response,
      // then parse the JSON.
      Log.d('Response from API ${response.body}');
      Instructor instructor = Instructor.fromJson(json.decode(response.body));

      return instructor;
    } else {
      // If the server did not return a 200 GET response,
      // then throw an exception.
      Log.d('Response from API ' + response.statusCode.toString());
      Log.d(response.body);
      throw Exception(response);
    }
  }

  static Future<List<Lesson>> lessons(
      String token, int page, int pageSize) async {
    String offset = page.toString();
    String limit = pageSize.toString();
    Uri uri = Uri.parse(API_URL + '/instructor/lessons?offset=' + offset + '&limit=' + limit);
    final response = await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + token,
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 CREATED response,
      // then parse the JSON.
      List<Lesson> lessons =
          Lesson.arrayFromJson(json.decode(response.body)['lessons']);

      Log.d('Response from API ${response.body}');
      return lessons;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      Log.d('Response from API ' + response.statusCode.toString());
      Log.d(response.body);
      throw Exception(response);
    }
  }

  static Future<void> firebaseToken(String token, String firebaseToken) async {
    final response = await http.post(Uri.parse(API_URL + '/instructor/devices'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token,
        },
        body: jsonEncode(<String, dynamic>{
          'device': {
            'token': firebaseToken,
            'type': defaultTargetPlatform == TargetPlatform.android
                ? 'android'
                : 'ios'
          },
        }));
    if (response.statusCode == 200) {
      Log.d('Response from API ${response.body}');
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      Log.d('Response from API ' + response.statusCode.toString());
      Log.d(response.body);
    }
  }
}
