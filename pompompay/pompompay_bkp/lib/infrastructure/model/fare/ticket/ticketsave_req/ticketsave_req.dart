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
  String? adultFare;
  String? kidsFare;
  String? studentSingleFare;
  String? handiSingleFare;
  @JsonKey(name: 'order_id')
  String? orderId;
  @JsonKey(name: 'payment_mode')
  String? paymentMode;
  @JsonKey(name: 'payment_channel')
  String? paymentChannel;
  @JsonKey(name: 'payment_datetime')
  String? paymentDatetime;
  @JsonKey(name: 'response_code')
  int? responseCode;
  @JsonKey(name: 'response_message')
  String? responseMessage;
  @JsonKey(name: 'error_desc')
  String? errorDesc;
  @JsonKey(name: 'card_masked')
  String? cardMasked;
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
    this.adultFare,
    this.kidsFare,
    this.studentSingleFare,
    this.handiSingleFare,
    this.orderId,
    this.paymentMode,
    this.paymentChannel,
    this.paymentDatetime,
    this.responseCode,
    this.responseMessage,
    this.errorDesc,
    this.cardMasked,
    this.reqTime,
  });

  factory TicketsaveReq.fromJson(Map<String, dynamic> json) {
    return _$TicketsaveReqFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TicketsaveReqToJson(this);
}
