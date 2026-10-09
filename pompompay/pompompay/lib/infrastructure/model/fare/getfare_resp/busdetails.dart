import 'package:json_annotation/json_annotation.dart';

part 'busdetails.g.dart';

@JsonSerializable()
class Busdetails {
  @JsonKey(name: 'owner_id')
  String? ownerId;
  String? name;
  String? address;
  String? upid;
  @JsonKey(name: 'salt_key')
  String? saltKey;
  @JsonKey(name: 'mercnt_code')
  String? mercntCode;
  @JsonKey(name: 'account_no')
  String? accountNo;
  @JsonKey(name: 'mobile_no')
  String? mobileNo;
  @JsonKey(name: 'email_id')
  String? emailId;
  String? address1;
  String? address2;
  String? zip;
  String? city;
  String? state;
  String? country;
  String? offerCode;
  @JsonKey(name: 'created_by')
  String? createdBy;
  @JsonKey(name: 'created_date')
  String? createdDate;
  @JsonKey(name: 'modified_by')
  String? modifiedBy;
  @JsonKey(name: 'modified_date')
  String? modifiedDate;
  @JsonKey(name: 'sms_provider')
  String? smsProvider;
  @JsonKey(name: 'bus_name')
  String? busName;
  @JsonKey(name: 'registration_no')
  String? registrationNo;
  String? seatno;
  @JsonKey(name: 'trip_id')
  String? tripId;
  @JsonKey(name: 'trip_name')
  String? tripName;
  String? busid;
  @JsonKey(name: 'bus_type')
  String? busType;
  @JsonKey(name: 'start_time')
  String? startTime;
  @JsonKey(name: 'end_time')
  String? endTime;

  Busdetails({
    this.ownerId,
    this.name,
    this.address,
    this.upid,
    this.saltKey,
    this.mercntCode,
    this.accountNo,
    this.mobileNo,
    this.emailId,
    this.address1,
    this.address2,
    this.zip,
    this.city,
    this.state,
    this.country,
    this.offerCode,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
    this.smsProvider,
    this.busName,
    this.registrationNo,
    this.seatno,
    this.tripId,
    this.tripName,
    this.busid,
    this.busType,
    this.startTime,
    this.endTime,
  });

  factory Busdetails.fromJson(Map<String, dynamic> json) {
    return _$BusdetailsFromJson(json);
  }

  Map<String, dynamic> toJson() => _$BusdetailsToJson(this);
}
