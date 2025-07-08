import 'package:json_annotation/json_annotation.dart';

part 'ticketsave_req.g.dart';

@JsonSerializable()
class TicketsaveReq {
  @JsonKey(name: 'trip_id')
  String? tripId;
  String? busid;
  String? approvalRefNo;
  String? frmselected;
  String? toselected;
  int? adultsselected;
  String? seatno;
  @JsonKey(name: 'user_id')
  String? userId;
  @JsonKey(name: 'user_name')
  String? userName;
  @JsonKey(name: 'cond_name')
  String? condName;
  @JsonKey(name: 'phone_no')
  String? phoneNo;
  @JsonKey(name: 'merchant_code')
  String? merchantCode;
  int? kidsselected;
  int? handiselected;
  int? studselected;
  String? amount;
  @JsonKey(name: 'req_time')
  String? reqTime;

  TicketsaveReq({
    this.tripId,
    this.busid,
    this.approvalRefNo,
    this.frmselected,
    this.toselected,
    this.adultsselected,
    this.seatno,
    this.userId,
    this.userName,
    this.condName,
    this.phoneNo,
    this.merchantCode,
    this.kidsselected,
    this.handiselected,
    this.studselected,
    this.amount,
    this.reqTime,
  });

  factory TicketsaveReq.fromJson(Map<String, dynamic> json) {
    return _$TicketsaveReqFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TicketsaveReqToJson(this);
}
