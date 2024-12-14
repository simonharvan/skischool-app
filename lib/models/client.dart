import 'package:json_annotation/json_annotation.dart';

part 'client.g.dart';

@JsonSerializable()
class Client {
  int id;
  String? name;
  String? email;
  String? phone;
  String? phone_2;


  Client(this.id, this.name, this.email, this.phone, this.phone_2);

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

  Map<String, dynamic> toJson() => _$ClientToJson(this);

}