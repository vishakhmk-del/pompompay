import 'package:json_annotation/json_annotation.dart';

import 'data.dart';

part 'user_cmn_resp.g.dart';

@JsonSerializable()
class UserCmnResp {
  String? status;
  String? message;
  Data? data;

  UserCmnResp({this.status, this.message, this.data});

  factory UserCmnResp.fromJson(Map<String, dynamic> json) {
    return _$UserCmnRespFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserCmnRespToJson(this);
}
