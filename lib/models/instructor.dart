import 'package:json_annotation/json_annotation.dart';

part 'instructor.g.dart';

@JsonSerializable()
class Instructor {
  int id;
  String name;
  String email;
  String phone;
  String gender;
  String teaching;


  Instructor(this.id, this.name, this.email, this.phone, this.gender, this.teaching);

  factory Instructor.fromJson(Map<String, dynamic> json) => _$InstructorFromJson(json);

  Map<String, dynamic> toJson() => _$InstructorToJson(this);


}