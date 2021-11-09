import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:skischool/models/client.dart';
import 'package:skischool/models/instructor.dart';

part 'lesson.g.dart';

@JsonSerializable()
class Lesson {
  final String STATUS_PAID = 'paid';
  final String STATUS_NOT_PAID = 'unpaid';

  int id;
  String from;
  String to;
  String name;
  String type;
  double price;
  String status;
  Instructor instructor;
  Client client;

  Lesson(this.id, this.from, this.to, this.name, this.type, this.price,
      this.status, this.instructor, this.client);

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);

  Map<String, dynamic> toJson() => _$LessonToJson(this);

  static List<Lesson> arrayFromJson(List array) {
    List<Lesson> lessons = [];
    array.forEach((element) {
      lessons.add(Lesson.fromJson(element));
    });
    return lessons;
  }
}
