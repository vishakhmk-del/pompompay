import 'package:json_annotation/json_annotation.dart';

part 'transactionresp.g.dart';

@JsonSerializable()
class Transactionresp {
  @JsonKey(name: 'transaction_id')
  String? transactionId;
  @JsonKey(name: 'bank_code')
  String? bankCode;
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
  @JsonKey(name: 'authorization_staus')
  String? authorizationStaus;
  @JsonKey(name: 'order_id')
  String? orderId;
  String? amount;
  @JsonKey(name: 'amount_orig')
  String? amountOrig;
  @JsonKey(name: 'tdr_amount')
  int? tdrAmount;
  @JsonKey(name: 'tax_on_tdr_amount')
  int? taxOnTdrAmount;
  String? description;
  @JsonKey(name: 'error_desc')
  dynamic errorDesc;
  @JsonKey(name: 'customer_phone')
  String? customerPhone;
  @JsonKey(name: 'customer_name')
  String? customerName;
  @JsonKey(name: 'customer_email')
  String? customerEmail;
  @JsonKey(name: 'email')
  String? email;
  @JsonKey(name: 'name')
  String? name;
  @JsonKey(name: 'phone')
  String? phone;
  String? currency;
  dynamic cardmasked;
  dynamic udf1;
  dynamic udf2;
  dynamic udf3;
  dynamic udf4;
  dynamic udf5;
  @JsonKey(name: 'bank_ref_id')
  String? bankRefId;
  String? hash;

  Transactionresp({
    this.transactionId,
    this.bankCode,
    this.paymentMode,
    this.paymentChannel,
    this.paymentDatetime,
    this.responseCode,
    this.responseMessage,
    this.authorizationStaus,
    this.orderId,
    this.amount,
    this.amountOrig,
    this.tdrAmount,
    this.taxOnTdrAmount,
    this.description,
    this.errorDesc,
    this.customerPhone,
    this.customerName,
    this.customerEmail,
    this.email,
    this.phone,
    this.name,
    this.currency,
    this.cardmasked,
    this.udf1,
    this.udf2,
    this.udf3,
    this.udf4,
    this.udf5,
    this.bankRefId,
    this.hash,
  });

  factory Transactionresp.fromJson(Map<String, dynamic> json) {
    return _$TransactionrespFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TransactionrespToJson(this);
}
