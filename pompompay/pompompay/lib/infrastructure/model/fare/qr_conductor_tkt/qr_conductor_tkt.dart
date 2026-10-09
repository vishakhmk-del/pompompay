import 'package:json_annotation/json_annotation.dart';

import 'data.dart';

part 'qr_conductor_tkt.g.dart';

@JsonSerializable()
class QrConductorTkt {
  String? type;
  DataQrTkt? data;

  QrConductorTkt({this.type, this.data});

  factory QrConductorTkt.fromJson(Map<String, dynamic> json) {
    return _$QrConductorTktFromJson(json);
  }

  Map<String, dynamic> toJson() => _$QrConductorTktToJson(this);
}
