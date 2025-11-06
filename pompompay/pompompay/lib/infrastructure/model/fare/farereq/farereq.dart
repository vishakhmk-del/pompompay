import 'package:json_annotation/json_annotation.dart';

part 'farereq.g.dart';

@JsonSerializable()
class Farereq {
  @JsonKey(name: 'trip_id')
  String? tripId;
  @JsonKey(name: 'bus_id')
  String? busId;
  @JsonKey(name: 'busid')
  String? busidNo;
  String? from;
  String? to;
  String? adults;
  String? stud;
  String? handi;
  String? kids;
  String? seatno;
  @JsonKey(name: 'user_id')
  String? userId;
  @JsonKey(name: 'order_id')
  String? orderId;
  @JsonKey(name: 'ticket_status')
  dynamic ticketstatus;
  @JsonKey(name: 'start_time')
  dynamic startTime;
  @JsonKey(name: 'end_time')
  dynamic endTime;
  @JsonKey(name: 'from_place')
  dynamic fromPlace;
  @JsonKey(name: 'to_place')
  dynamic toPlace;
  @JsonKey(name: 'type')
  String? type;
  @JsonKey(name: 'flag')
  String? flag;
  @JsonKey(name: 'crntDt')
  String? crntDt;
  @JsonKey(name: 'crntTm')
  String? crntTm;
  @JsonKey(name: 'status')
  dynamic status;
  Farereq({
    this.tripId,
    this.busId,
    this.busidNo,
    this.from,
    this.to,
    this.adults,
    this.stud,
    this.handi,
    this.kids,
    this.seatno,
    this.userId,
    this.orderId,
    this.ticketstatus,
    this.startTime,
    this.endTime,
    this.fromPlace,
    this.toPlace,
    this.type,
    this.flag,
    this.crntDt,
    this.crntTm,
    this.status,
  });

  factory Farereq.fromJson(Map<String, dynamic> json) {
    return _$FarereqFromJson(json);
  }

  Map<String, dynamic> toJson() => _$FarereqToJson(this);
}
