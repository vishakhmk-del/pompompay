// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransResponse _$TransResponseFromJson(Map<String, dynamic> json) =>
    TransResponse(
      orderId: json['order_id'] as String?,
      amount: json['amount'] as String?,
      currency: json['currency'] as String?,
      description: json['description'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      addressLine1: json['address_line_1'],
      addressLine2: json['address_line_2'],
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      zipCode: json['zip_code'] as String?,
      udf1: json['udf1'],
      udf2: json['udf2'],
      udf3: json['udf3'],
      udf4: json['udf4'],
      udf5: json['udf5'],
      transactionId: json['transaction_id'] as String?,
      paymentMode: json['payment_mode'] as String?,
      paymentChannel: json['payment_channel'] as String?,
      paymentDatetime: json['payment_datetime'] as String?,
      responseCode: (json['response_code'] as num?)?.toInt(),
      responseMessage: json['response_message'] as String?,
      errorDesc: json['error_desc'] as String?,
      cardmasked: json['cardmasked'] as String?,
      hash: json['hash'] as String?,
    );

Map<String, dynamic> _$TransResponseToJson(TransResponse instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'amount': instance.amount,
      'currency': instance.currency,
      'description': instance.description,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'address_line_1': instance.addressLine1,
      'address_line_2': instance.addressLine2,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'zip_code': instance.zipCode,
      'udf1': instance.udf1,
      'udf2': instance.udf2,
      'udf3': instance.udf3,
      'udf4': instance.udf4,
      'udf5': instance.udf5,
      'transaction_id': instance.transactionId,
      'payment_mode': instance.paymentMode,
      'payment_channel': instance.paymentChannel,
      'payment_datetime': instance.paymentDatetime,
      'response_code': instance.responseCode,
      'response_message': instance.responseMessage,
      'error_desc': instance.errorDesc,
      'cardmasked': instance.cardmasked,
      'hash': instance.hash,
    };
