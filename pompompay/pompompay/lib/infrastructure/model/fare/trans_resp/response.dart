import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable()
class TransResponse {
  @JsonKey(name: 'order_id')
  String? orderId;
  String? amount;
  String? currency;
  String? description;
  String? name;
  String? email;
  String? phone;
  @JsonKey(name: 'address_line_1')
  dynamic addressLine1;
  @JsonKey(name: 'address_line_2')
  dynamic addressLine2;
  String? city;
  String? state;
  String? country;
  @JsonKey(name: 'zip_code')
  String? zipCode;
  dynamic udf1;
  dynamic udf2;
  dynamic udf3;
  dynamic udf4;
  dynamic udf5;
  @JsonKey(name: 'transaction_id')
  String? transactionId;
  @JsonKey(name: 'payment_mode')
  String? paymentMode;
  @JsonKey(name: 'payment_channel')
  String? paymentChannel;
  @JsonKey(name: 'payment_datetime')
  String? paymentDatetime;
  @JsonKey(name: 'response_code')
  dynamic responseCode;
  @JsonKey(name: 'response_message')
  String? responseMessage;
  @JsonKey(name: 'error_desc')
  String? errorDesc;
  String? cardmasked;
  String? hash;
  @JsonKey(name: 'customer_phone')
  String? custphone;
  @JsonKey(name: 'customer_name')
  String? customerName;
  @JsonKey(name: 'customer_email')
  String? custmail;
  @JsonKey(name: 'bank_ref_id')
  String? bankRefId;

  TransResponse({
    this.orderId,
    this.amount,
    this.currency,
    this.description,
    this.name,
    this.email,
    this.phone,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.country,
    this.zipCode,
    this.udf1,
    this.udf2,
    this.udf3,
    this.udf4,
    this.udf5,
    this.transactionId,
    this.paymentMode,
    this.paymentChannel,
    this.paymentDatetime,
    this.responseCode,
    this.responseMessage,
    this.errorDesc,
    this.cardmasked,
    this.hash,
    this.custphone,
    this.customerName,
    this.custmail,
    this.bankRefId,
  });

  factory TransResponse.fromJson(Map<String, dynamic> json) {
    return _$TransResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TransResponseToJson(this);
}
