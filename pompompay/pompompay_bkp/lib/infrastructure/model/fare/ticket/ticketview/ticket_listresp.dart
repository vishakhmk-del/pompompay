import 'package:json_annotation/json_annotation.dart';
import 'package:pompompay/infrastructure/model/fare/ticket/ticketview/ticketview.dart';

part 'ticket_listresp.g.dart';

@JsonSerializable()
class TicketFetch {
  String? status;
  String? message;
  List<Ticketview>? data;

  TicketFetch({this.status, this.message, this.data});

  factory TicketFetch.fromJson(Map<String, dynamic> json) {
    return _$TicketFetchFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TicketFetchToJson(this);
}
