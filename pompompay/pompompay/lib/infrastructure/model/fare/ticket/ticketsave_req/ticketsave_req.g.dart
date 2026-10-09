// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticketsave_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketsaveReq _$TicketsaveReqFromJson(Map<String, dynamic> json) =>
    TicketsaveReq(
      tripId: json['trip_id'] as String?,
      busid: json['busid'] as String?,
      approvalRefNo: json['approvalRefNo'] as String?,
      frmselected: json['frmselected'],
      toselected: json['toselected'],
      adultsselected: (json['adultsselected'] as num?)?.toInt(),
      seatno: json['seatno'] as String?,
      userId: json['user_id'] as String?,
      userName: json['user_name'] as String?,
      condName: json['cond_name'] as String?,
      phoneNo: json['phone_no'] as String?,
      merchantCode: json['merchant_code'] as String?,
      kidsselected: (json['kidsselected'] as num?)?.toInt(),
      handiselected: (json['handiselected'] as num?)?.toInt(),
      studselected: (json['studselected'] as num?)?.toInt(),
      amount: json['amount'] as String?,
      adultFare: json['adultFare'] as String?,
      kidsFare: json['kidsFare'] as String?,
      studentSingleFare: json['studentSingleFare'] as String?,
      handiSingleFare: json['handiSingleFare'] as String?,
      orderId: json['order_id'] as String?,
      paymentMode: json['payment_mode'] as String?,
      paymentChannel: json['payment_channel'] as String?,
      paymentDatetime: json['payment_datetime'] as String?,
      responseCode: (json['response_code'] as num?)?.toInt(),
      responseMessage: json['response_message'] as String?,
      errorDesc: json['error_desc'] as String?,
      cardMasked: json['card_masked'] as String?,
      reqTime: json['req_time'] as String?,
    );

Map<String, dynamic> _$TicketsaveReqToJson(TicketsaveReq instance) =>
    <String, dynamic>{
      'trip_id': instance.tripId,
      'busid': instance.busid,
      'approvalRefNo': instance.approvalRefNo,
      'frmselected': instance.frmselected,
      'toselected': instance.toselected,
      'adultsselected': instance.adultsselected,
      'seatno': instance.seatno,
      'user_id': instance.userId,
      'user_name': instance.userName,
      'cond_name': instance.condName,
      'phone_no': instance.phoneNo,
      'merchant_code': instance.merchantCode,
      'kidsselected': instance.kidsselected,
      'handiselected': instance.handiselected,
      'studselected': instance.studselected,
      'amount': instance.amount,
      'adultFare': instance.adultFare,
      'kidsFare': instance.kidsFare,
      'studentSingleFare': instance.studentSingleFare,
      'handiSingleFare': instance.handiSingleFare,
      'order_id': instance.orderId,
      'payment_mode': instance.paymentMode,
      'payment_channel': instance.paymentChannel,
      'payment_datetime': instance.paymentDatetime,
      'response_code': instance.responseCode,
      'response_message': instance.responseMessage,
      'error_desc': instance.errorDesc,
      'card_masked': instance.cardMasked,
      'req_time': instance.reqTime,
    };
