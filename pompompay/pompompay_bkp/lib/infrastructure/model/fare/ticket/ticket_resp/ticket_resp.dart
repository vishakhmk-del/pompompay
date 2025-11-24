import 'package:json_annotation/json_annotation.dart';

import 'data.dart';

part 'ticket_resp.g.dart';

@JsonSerializable()
class TicketResp {
  String? status;
  String? message;
  Datatkt? data;

  TicketResp({this.status, this.message, this.data});

  factory TicketResp.fromJson(Map<String, dynamic> json) {
    return _$TicketRespFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TicketRespToJson(this);
}
