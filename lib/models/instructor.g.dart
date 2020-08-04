// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Instructor _$InstructorFromJson(Map<String, dynamic> json) {
  return Instructor(
    json['id'] as int,
    json['name'] as String,
    json['email'] as String,
    json['phone'] as String,
    json['gender'] as String,
    json['teaching'] as String,
  );
}

Map<String, dynamic> _$InstructorToJson(Instructor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'gender': instance.gender,
      'teaching': instance.teaching,
    };
