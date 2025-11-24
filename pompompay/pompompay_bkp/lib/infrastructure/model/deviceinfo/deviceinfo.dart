import 'package:json_annotation/json_annotation.dart';

part 'deviceinfo.g.dart';

@JsonSerializable()
class Deviceinfo {
  dynamic userId;
  @JsonKey(name: 'user_id')
  String? userid;
  String? phone;
  String? devicetoken;
  String? deviceid;
  String? phoneos;
  String? screenresolution;
  String? androidid;
  String? osversion;
  String? packagename;
  String? appversion;
  String? buildnumber;

  Deviceinfo({
    this.userId,
    this.userid,
    this.phone,
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

  factory Deviceinfo.fromJson(Map<String, dynamic> json) {
    return _$DeviceinfoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DeviceinfoToJson(this);
}
