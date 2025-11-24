import 'package:json_annotation/json_annotation.dart';

import 'data.dart';

part 'live_busresp.g.dart';

@JsonSerializable()
class LiveBusresp {
  String? status;
  String? message;
  Datalive? data;

  LiveBusresp({this.status, this.message, this.data});

  factory LiveBusresp.fromJson(Map<String, dynamic> json) {
    return _$LiveBusrespFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LiveBusrespToJson(this);
}
