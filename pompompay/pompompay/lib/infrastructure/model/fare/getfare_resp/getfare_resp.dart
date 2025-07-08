import 'package:json_annotation/json_annotation.dart';

import 'data.dart';

part 'getfare_resp.g.dart';

@JsonSerializable()
class GetfareResp {
  String? status;
  String? message;
  DataVal? data;

  GetfareResp({this.status, this.message, this.data});

  factory GetfareResp.fromJson(Map<String, dynamic> json) {
    return _$GetfareRespFromJson(json);
  }

  Map<String, dynamic> toJson() => _$GetfareRespToJson(this);
}
