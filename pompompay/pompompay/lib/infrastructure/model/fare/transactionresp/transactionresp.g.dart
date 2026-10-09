// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactionresp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transactionresp _$TransactionrespFromJson(Map<String, dynamic> json) =>
    Transactionresp(
      transactionId: json['transaction_id'] as String?,
      bankCode: json['bank_code'] as String?,
      paymentMode: json['payment_mode'] as String?,
      paymentChannel: json['payment_channel'] as String?,
      paymentDatetime: json['payment_datetime'] as String?,
      responseCode: json['response_code'],
      responseMessage: json['response_message'] as String?,
      authorizationStaus: json['authorization_staus'] as String?,
      orderId: json['order_id'] as String?,
      amount: json['amount'] as String?,
      amountOrig: json['amount_orig'] as String?,
      tdrAmount: (json['tdr_amount'] as num?)?.toInt(),
      taxOnTdrAmount: (json['tax_on_tdr_amount'] as num?)?.toInt(),
      description: json['description'] as String?,
      errorDesc: json['error_desc'],
      customerPhone: json['customer_phone'] as String?,
      customerName: json['customer_name'] as String?,
      customerEmail: json['customer_email'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      name: json['name'] as String?,
      currency: json['currency'] as String?,
      cardmasked: json['cardmasked'],
      udf1: json['udf1'],
      udf2: json['udf2'],
      udf3: json['udf3'],
      udf4: json['udf4'],
      udf5: json['udf5'],
      bankRefId: json['bank_ref_id'] as String?,
      hash: json['hash'] as String?,
    );

Map<String, dynamic> _$TransactionrespToJson(Transactionresp instance) =>
    <String, dynamic>{
      'transaction_id': instance.transactionId,
      'bank_code': instance.bankCode,
      'payment_mode': instance.paymentMode,
      'payment_channel': instance.paymentChannel,
      'payment_datetime': instance.paymentDatetime,
      'response_code': instance.responseCode,
      'response_message': instance.responseMessage,
      'authorization_staus': instance.authorizationStaus,
      'order_id': instance.orderId,
      'amount': instance.amount,
      'amount_orig': instance.amountOrig,
      'tdr_amount': instance.tdrAmount,
      'tax_on_tdr_amount': instance.taxOnTdrAmount,
      'description': instance.description,
      'error_desc': instance.errorDesc,
      'customer_phone': instance.customerPhone,
      'customer_name': instance.customerName,
      'customer_email': instance.customerEmail,
      'email': instance.email,
      'name': instance.name,
      'phone': instance.phone,
      'currency': instance.currency,
      'cardmasked': instance.cardmasked,
      'udf1': instance.udf1,
      'udf2': instance.udf2,
      'udf3': instance.udf3,
      'udf4': instance.udf4,
      'udf5': instance.udf5,
      'bank_ref_id': instance.bankRefId,
      'hash': instance.hash,
    };
