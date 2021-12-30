// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lesson _$LessonFromJson(Map<String, dynamic> json) {
  return Lesson(
    json['id'] as int,
    json['from'] as String,
    json['to'] as String,
    json['name'] as String,
    json['type'] as String,
    double.parse('${json['price']}'),
    json['status'] as String,
    json['note'] as String,
    json['instructor'] == null
        ? null
        : Instructor.fromJson(json['instructor'] as Map<String, dynamic>),
    json['client'] == null
        ? null
        : Client.fromJson(json['client'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
      'id': instance.id,
      'from': instance.from,
      'to': instance.to,
      'name': instance.name,
      'type': instance.type,
      'price': instance.price,
      'status': instance.status,
      'note': instance.note,
      'instructor': instance.instructor,
      'client': instance.client,
    };
