import 'dart:developer';

import 'package:get_ip_address/get_ip_address.dart';

class Ipinfo {
  static Future<String> getipAddress() async {
    try {
      /// Initialize Ip Address
      var ipAddress = IpAddress(type: RequestType.json);

      /// Get the IpAddress based on requestType.
      dynamic data = await ipAddress.getIpAddress();
      print(data.toString());
      return data.toString();
    } on IpAddressException catch (exception) {
      /// Handle the exception.
      log("ip address exception:${exception.message}");
    }
    return '';
  }
}
