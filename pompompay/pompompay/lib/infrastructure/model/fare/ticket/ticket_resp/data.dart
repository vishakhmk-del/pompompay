import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class Datatkt {
  @JsonKey(name: 'ticket_no')
  String? ticketNo;
  String? seatno;
  String? busid;
  String? dot;

  Datatkt({this.ticketNo, this.seatno, this.busid, this.dot});

  factory Datatkt.fromJson(Map<String, dynamic> json) =>
      _$DatatktFromJson(json);

  Map<String, dynamic> toJson() => _$DatatktToJson(this);
}
