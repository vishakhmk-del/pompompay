import 'package:json_annotation/json_annotation.dart';

import 'data.dart';

part 'user_cmn_resp.g.dart';

@JsonSerializable()
class UserCmnResp {
  String? status;
  String? message;
  @JsonKey(name: 'error_code')
  String? errorCode;
  bool? mandatory;

  Data? data;

  UserCmnResp({this.status, this.message,this.errorCode,this.mandatory, this.data});

  factory UserCmnResp.fromJson(Map<String, dynamic> json) {
    return _$UserCmnRespFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserCmnRespToJson(this);
}
