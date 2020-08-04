import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:skishool/models/instructor.dart';
import 'package:skishool/models/lesson.dart';
import 'package:skishool/models/token.dart';

const String API_URL = 'http://api.skischool.bero.tech/api';

class Api {
  static Future<Token> login(String email, String password) async {
    final response = await http.post(
      API_URL + '/instructor/auth/login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'instructor': {
          'email': email,
          'password': password
        },
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 CREATED response,
      // then parse the JSON.
      return Token.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      print('Response from API ' + response.statusCode.toString());
      print(response.body);
      throw Exception(response);
    }
  }

  static Future<Instructor> me(String token) async {
    final response = await http.get(
      API_URL + '/instructor/me',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token,
      }
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 CREATED response,
      // then parse the JSON.
      print('Response from API ${response.body}');
      Instructor instructor = Instructor.fromJson(json.decode(response.body));

      return instructor;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      print('Response from API ' + response.statusCode.toString());
      print(response.body);
      throw Exception(response);
    }
  }

  static Future<List<Lesson>> lessons(String token) async {
    final response = await http.get(
        API_URL + '/instructor/lessons',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token,
        }
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 CREATED response,
      // then parse the JSON.
      List<Lesson> lessons = Lesson.arrayFromJson(json.decode(response.body)['lessons']);

      print('Response from API ${response.body}');
      return lessons;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      print('Response from API ' + response.statusCode.toString());
      print(response.body);
      throw Exception(response);
    }
  }
}