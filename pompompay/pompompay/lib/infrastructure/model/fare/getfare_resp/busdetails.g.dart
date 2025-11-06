// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'busdetails.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Busdetails _$BusdetailsFromJson(Map<String, dynamic> json) => Busdetails(
  ownerId: json['owner_id'] as String?,
  name: json['name'] as String?,
  address: json['address'] as String?,
  upid: json['upid'] as String?,
  saltKey: json['salt_key'] as String?,
  mercntCode: json['mercnt_code'] as String?,
  accountNo: json['account_no'] as String?,
  mobileNo: json['mobile_no'] as String?,
  emailId: json['email_id'] as String?,
  address1: json['address1'] as String?,
  address2: json['address2'] as String?,
  zip: json['zip'] as String?,
  city: json['city'] as String?,
  state: json['state'] as String?,
  country: json['country'] as String?,
  offerCode: json['offerCode'] as String?,
  createdBy: json['created_by'] as String?,
  createdDate: json['created_date'] as String?,
  modifiedBy: json['modified_by'] as String?,
  modifiedDate: json['modified_date'] as String?,
  smsProvider: json['sms_provider'] as String?,
  busName: json['bus_name'] as String?,
  registrationNo: json['registration_no'] as String?,
  seatno: json['seatno'] as String?,
  tripId: json['trip_id'] as String?,
  busid: json['busid'] as String?,
  busType: json['bus_type'] as String?,
  startTime: json['start_time'] as String?,
  endTime: json['end_time'] as String?,
);

Map<String, dynamic> _$BusdetailsToJson(Busdetails instance) =>
    <String, dynamic>{
      'owner_id': instance.ownerId,
      'name': instance.name,
      'address': instance.address,
      'upid': instance.upid,
      'salt_key': instance.saltKey,
      'mercnt_code': instance.mercntCode,
      'account_no': instance.accountNo,
      'mobile_no': instance.mobileNo,
      'email_id': instance.emailId,
      'address1': instance.address1,
      'address2': instance.address2,
      'zip': instance.zip,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'offerCode': instance.offerCode,
      'created_by': instance.createdBy,
      'created_date': instance.createdDate,
      'modified_by': instance.modifiedBy,
      'modified_date': instance.modifiedDate,
      'sms_provider': instance.smsProvider,
      'bus_name': instance.busName,
      'registration_no': instance.registrationNo,
      'seatno': instance.seatno,
      'trip_id': instance.tripId,
      'busid': instance.busid,
      'bus_type': instance.busType,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
    };
