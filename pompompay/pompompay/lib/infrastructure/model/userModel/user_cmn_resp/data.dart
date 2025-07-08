import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class Data {
  @JsonKey(name: 'user_id')
  String? userId;
  String? name;
  @JsonKey(name: 'access_token')
  String? accessToken;
  String? mobno;

  Data({this.userId, this.name, this.accessToken, this.mobno});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
