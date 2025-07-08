import 'package:json_annotation/json_annotation.dart';

import 'response.dart';

part 'trans_resp.g.dart';

@JsonSerializable()
class TransResp {
  String? status;
  String? code;
  String? message;
  TransResponse? response;

  TransResp({this.status, this.code, this.message, this.response});

  factory TransResp.fromJson(Map<String, dynamic> json) {
    return _$TransRespFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TransRespToJson(this);
}
