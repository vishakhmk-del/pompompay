import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class DataQrTkt {
  @JsonKey(name: 'trip_id')
  String? tripId;
  @JsonKey(name: 'trip_name')
  String? tripName;
  @JsonKey(name: 'start_time')
  String? startTime;
  @JsonKey(name: 'end_time')
  String? endTime;
  @JsonKey(name: 'from_place')
  String? fromPlace;
  @JsonKey(name: 'to_place')
  String? toPlace;
  @JsonKey(name: 'from_placeid')
  String? fromPlaceid;
  @JsonKey(name: 'to_placeid')
  String? toPlaceid;
  int? adults;
  int? kids;
  int? student;
  int? handicapped;
  @JsonKey(name: 'sp_type')
  String? spType;
  @JsonKey(name: 'sp_count')
  int? spCount;
  @JsonKey(name: 'sp_amount')
  int? spAmount;
  @JsonKey(name: 'total_amt')
  dynamic totalAmt;
  @JsonKey(name: 'user_id')
  String? userId;
  @JsonKey(name: 'bus_id')
  String? busId;
  @JsonKey(name: 'bus_name')
  String? busName;
  @JsonKey(name: 'reg_no')
  String? regNo;
  int? discount;
  @JsonKey(name: 'cond_name')
  String? condName;
  @JsonKey(name: 'adult_amount')
  dynamic adultAmount;
  @JsonKey(name: 'single_adult')
  dynamic singleAdult;
  @JsonKey(name: 'kid_amount')
  dynamic kidAmount;
  @JsonKey(name: 'single_kid')
  dynamic singleKid;
  @JsonKey(name: 'student_amount')
  dynamic studentAmount;
  @JsonKey(name: 'single_student')
  dynamic singleStudent;
  @JsonKey(name: 'handi_amount')
  dynamic handiAmount;
  @JsonKey(name: 'single_handi')
  dynamic singleHandi;
  @JsonKey(name: 'api_key')
  String? apiKey;
  @JsonKey(name: 'salt_key')
  String? saltKey;
  @JsonKey(name: 'merchant_code')
  String? merchantCode;
  String? description;
  String? name;
  String? email;
  String? phone;
  String? zip;
  String? city;
  String? state;
  String? country;
  @JsonKey(name: 'return_url')
  String? returnUrl;
  String? mode;
  String? address1;
  String? address2;
  @JsonKey(name: 'auto_refund')
  String? autoRefund;

  DataQrTkt({
    this.tripId,
    this.tripName,
    this.startTime,
    this.endTime,
    this.fromPlace,
    this.toPlace,
    this.fromPlaceid,
    this.toPlaceid,
    this.adults,
    this.kids,
    this.student,
    this.handicapped,
    this.spType,
    this.spCount,
    this.spAmount,
    this.totalAmt,
    this.userId,
    this.busId,
    this.busName,
    this.regNo,
    this.discount,
    this.condName,
    this.adultAmount,
    this.singleAdult,
    this.kidAmount,
    this.singleKid,
    this.studentAmount,
    this.singleStudent,
    this.handiAmount,
    this.singleHandi,
    this.apiKey,
    this.saltKey,
    this.merchantCode,
    this.description,
    this.name,
    this.email,
    this.phone,
    this.zip,
    this.city,
    this.state,
    this.country,
    this.returnUrl,
    this.mode,
    this.address1,
    this.address2,
    this.autoRefund,
  });

  factory DataQrTkt.fromJson(Map<String, dynamic> json) => _$DataQrTktFromJson(json);

  Map<String, dynamic> toJson() => _$DataQrTktToJson(this);
}
