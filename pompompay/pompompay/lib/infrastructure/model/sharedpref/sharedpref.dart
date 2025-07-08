import 'package:json_annotation/json_annotation.dart';

part 'sharedpref.g.dart';

@JsonSerializable()
class Sharedpref {
  @JsonKey(name: 'user_id')
  String? userId;
  @JsonKey(name: 'access_token')
  String? accessTkn;
  @JsonKey(name: 'name')
  String? name;
  @JsonKey(name: 'mobno')
  String? mobno;

  Sharedpref({this.userId, this.accessTkn, this.name, this.mobno});

  factory Sharedpref.fromJson(Map<String, dynamic> json) {
    return _$SharedprefFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SharedprefToJson(this);
}
