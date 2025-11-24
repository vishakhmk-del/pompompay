import 'package:json_annotation/json_annotation.dart';

part 'user_cmn_req.g.dart';

@JsonSerializable()
class UserCmnReq {
  @JsonKey(name: 'user_name')
  String? userName;
  @JsonKey(name: 'user_id')
  String? userId;
  String? mobno;
  String? pw;
  String? otp;
  String? type;
  String? device;
  String? devicetoken;
  String? deviceid;
  String? phoneos;
  String? screenresolution;
  String? androidid;
  String? osversion;
  String? packagename;
  String? appversion;
  String? buildnumber;

  UserCmnReq({
    this.userName,
    this.userId,
    this.mobno,
    this.pw,
    this.otp,
    this.type,
    this.device,
    this.devicetoken,
    this.deviceid,
    this.phoneos,
    this.screenresolution,
    this.androidid,
    this.osversion,
    this.packagename,
    this.appversion,
    this.buildnumber,
  });

  factory UserCmnReq.fromJson(Map<String, dynamic> json) {
    return _$UserCmnReqFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserCmnReqToJson(this);
}
