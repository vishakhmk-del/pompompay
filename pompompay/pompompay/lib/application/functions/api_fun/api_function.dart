import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:dio/io.dart' as diocert;
import 'package:pompompay/core/hook/hooks.dart';

abstract class Apicalls {
  Future<dio.Response<dynamic>?> login(UserCmnReq value);
  Future<dio.Response<dynamic>?> registration(UserCmnReq value);
  Future<dio.Response<dynamic>?> regOtpvrf(UserCmnReq value);
  Future<dio.Response<dynamic>?> resndOtp(UserCmnReq value);
  Future<dio.Response<dynamic>?> frgtPswrdOtp(UserCmnReq value);
  Future<dio.Response<dynamic>?> frgtpswrdvrfy(UserCmnReq value);
  // Future<dio.Response<dynamic>?> otpvrfy(UserCmnReq value);
  Future<dio.Response<dynamic>?> getStageList();
  Future<dio.Response<dynamic>?> getFareDet(Farereq value);
  Future<dio.Response<dynamic>?> calculateFare(Farereq value);
  Future<dio.Response<dynamic>?> ticketSave(TicketsaveReq value);
  Future<dio.Response<dynamic>?> fetchTkt(Farereq value);
  Future<dio.Response<dynamic>?> searchBus(Farereq value);
  Future<dio.Response<dynamic>?> sortBus(Farereq value);
  Future<dio.Response<dynamic>?> fetchStopLoc(Farereq value);
  Future<dio.Response<dynamic>?> liveBusLoc(Farereq value);
  Future<dio.Response<dynamic>?> ticketStatus(Farereq value);
  Future<dio.Response<dynamic>?> checkPayStatus(Farereq value);
  Future<dio.Response<dynamic>?> paymntUpdate(TicketsaveReq value);
  Future<dio.Response<dynamic>?> deleteUser(UserCmnReq value);
  Future<dio.Response<dynamic>?> checkUpdate(Deviceinfo value);
}

class Pompaydata extends Apicalls {
  final dio.Dio dioclient = dio.Dio();
  final url = Url();

  Pompaydata() {
    dioclient.options = dio.BaseOptions(
      baseUrl: url.baseUrl,
      responseType: dio.ResponseType.plain,
    );
    (dioclient.httpClientAdapter as diocert.IOHttpClientAdapter)
        .createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };
  }
  @override
  Future<dio.Response<dynamic>?> login(UserCmnReq value) async {
    try {
      final result = await dioclient.post(url.loginUrl, data: value.toJson());
      return result;
    } on DioException catch (ex) {
      // Check for timeout or other errors
      if (ex.type == DioExceptionType.connectionTimeout) {
        // Return a custom response or throw an exception with more details
        return dio.Response(
          requestOptions: ex.requestOptions,
          statusCode: 408, // HTTP 408 Request Timeout
          statusMessage: "Connection Timeout",
        );
      }
      // Return the error response from DioException
      return dio.Response(
        requestOptions: ex.requestOptions,
        statusCode:
            ex.response?.statusCode ??
            500, // Default to HTTP 500 if no status code
        statusMessage: ex.message,
        data: ex.response?.data, // Include error data if available
      );
    }
  }

  @override
  Future<dio.Response<dynamic>?> registration(UserCmnReq value) async {
    try {
      final result = await dioclient.post(
        url.registerUrl,
        data: value.toJson(),
      );
      return result;
    } on DioException catch (ex) {
      // Check for timeout or other errors
      if (ex.type == DioExceptionType.connectionTimeout) {
        // Return a custom response or throw an exception with more details
        return dio.Response(
          requestOptions: ex.requestOptions,
          statusCode: 408, // HTTP 408 Request Timeout
          statusMessage: "Connection Timeout",
        );
      }

      // Return the error response from DioException
      return dio.Response(
        requestOptions: ex.requestOptions,
        statusCode:
            ex.response?.statusCode ??
            500, // Default to HTTP 500 if no status code
        statusMessage: ex.message,
        data: ex.response?.data, // Include error data if available
      );
    }
  }

  @override
  Future<dio.Response<dynamic>?> regOtpvrf(UserCmnReq value) async {
    try {
      final result = await dioclient.post(url.regvrfyUrl, data: value.toJson());
      return result;
    } on DioException catch (ex) {
      // Check for timeout or other errors
      if (ex.type == DioExceptionType.connectionTimeout) {
        // Return a custom response or throw an exception with more details
        return dio.Response(
          requestOptions: ex.requestOptions,
          statusCode: 408, // HTTP 408 Request Timeout
          statusMessage: "Connection Timeout",
        );
      }

      // Return the error response from DioException
      return dio.Response(
        requestOptions: ex.requestOptions,
        statusCode:
            ex.response?.statusCode ??
            500, // Default to HTTP 500 if no status code
        statusMessage: ex.message,
        data: ex.response?.data, // Include error data if available
      );
    }
  }

  @override
  Future<dio.Response?> resndOtp(UserCmnReq value) async {
    try {
      final result = await dioclient.post(url.rsndOtpUrl, data: value.toJson());
      return result;
    } on DioException catch (ex) {
      // Check for timeout or other errors
      if (ex.type == DioExceptionType.connectionTimeout) {
        // Return a custom response or throw an exception with more details
        return dio.Response(
          requestOptions: ex.requestOptions,
          statusCode: 408, // HTTP 408 Request Timeout
          statusMessage: "Connection Timeout",
        );
      }
      // Return the error response from DioException
      return dio.Response(
        requestOptions: ex.requestOptions,
        statusCode:
            ex.response?.statusCode ??
            500, // Default to HTTP 500 if no status code
        statusMessage: ex.message,
        data: ex.response?.data, // Include error data if available
      );
    }
  }

  @override
  Future<dio.Response?> frgtPswrdOtp(UserCmnReq value) async {
    try {
      final result = await dioclient.post(url.frgtOtpUrl, data: value.toJson());
      return result;
    } on DioException catch (ex) {
      // Check for timeout or other errors
      if (ex.type == DioExceptionType.connectionTimeout) {
        // Return a custom response or throw an exception with more details
        return dio.Response(
          requestOptions: ex.requestOptions,
          statusCode: 408, // HTTP 408 Request Timeout
          statusMessage: "Connection Timeout",
        );
      }

      // Return the error response from DioException
      return dio.Response(
        requestOptions: ex.requestOptions,
        statusCode: ex.response?.statusCode ?? 500,
        statusMessage: ex.message,
        data: ex.response?.data,
      );
    }
  }
  //  @override
  //   Future<dio.Response?> otpvrfy(UserCmnReq value) async {
  //     try {
  //       final result = await dioclient.post(url.vrfyOtpUrl, data: value.toJson());
  //       return result;
  //     } on DioException catch (ex) {
  //       if (ex.type == DioExceptionType.connectionTimeout) {
  //         return dio.Response(
  //           requestOptions: ex.requestOptions,
  //           statusCode: 408, // HTTP 408 Request Timeout
  //           statusMessage: "Connection Timeout",
  //         );
  //       }

  //       // Return the error response from DioException
  //       return dio.Response(
  //         requestOptions: ex.requestOptions,
  //         statusCode:
  //             ex.response?.statusCode ??
  //             500, // Default to HTTP 500 if no status code
  //         statusMessage: ex.message,
  //         data: ex.response?.data, // Include error data if available
  //       );
  //     }
  //   }
  @override
  Future<dio.Response?> frgtpswrdvrfy(UserCmnReq value) async {
    try {
      final result = await dioclient.post(
        url.frgtOtpvrfyUrl,
        data: value.toJson(),
      );
      return result;
    } on DioException catch (ex) {
      if (ex.type == DioExceptionType.connectionTimeout) {
        return dio.Response(
          requestOptions: ex.requestOptions,
          statusCode: 408,
          statusMessage: "Connection Timeout",
        );
      }
      return dio.Response(
        requestOptions: ex.requestOptions,
        statusCode: ex.response?.statusCode ?? 500,
        statusMessage: ex.message,
        data: ex.response?.data,
      );
    }
  }

  @override
  Future<dio.Response?> getStageList() async {
    final sharedValue = await SharedPrefManager.instance.getSharedData();
    final token = sharedValue!.accessTkn;
    try {
      final result = await dioclient.post(
        url.getStageUrl,
        options: Options(
          responseType: ResponseType.plain,
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );
      return result;
    } on DioException catch (ex) {
      // Check for timeout or other errors
      if (ex.type == DioExceptionType.connectionTimeout) {
        // Return a custom response or throw an exception with more details
        return dio.Response(
          requestOptions: ex.requestOptions,
          statusCode: 408, // HTTP 408 Request Timeout
          statusMessage: "Connection Timeout",
        );
      }

      // Return the error response from DioException
      return dio.Response(
        requestOptions: ex.requestOptions,
        statusCode:
            ex.response?.statusCode ??
            500, // Default to HTTP 500 if no status code
        statusMessage: ex.message,
        data: ex.response?.data, // Include error data if available
      );
    }
  }

  @override
  Future<dio.Response?> getFareDet(Farereq value) async {
    final sharedValue = await SharedPrefManager.instance.getSharedData();
    final token = sharedValue!.accessTkn;
    try {
      final result = await dioclient.post(
        url.getfaredetUrl,
        data: value.toJson(),
        options: Options(
          responseType: ResponseType.plain,
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );
      return result;
    } on dio.DioException catch (ex) {
      // Check for timeout or other errors
      if (ex.type == DioExceptionType.connectionTimeout) {
        // Return a custom response or throw an exception with more details
        return dio.Response(
          requestOptions: ex.requestOptions,
          statusCode: 408,
          statusMessage: "Connection Timeout",
        );
      }

      // Return the error response from DioException
      return dio.Response(
        requestOptions: ex.requestOptions,
        statusCode:
            ex.response?.statusCode ??
            500, // Default to HTTP 500 if no status code
        statusMessage: ex.message,
        data: ex.response?.data, // Include error data if available
      );
    }
  }

  @override
  Future<dio.Response?> calculateFare(Farereq value) async {
    final sharedValue = await SharedPrefManager.instance.getSharedData();
    final token = sharedValue!.accessTkn;
    try {
      final result = await dioclient.post(
        url.calcfareUrl,
        data: value.toJson(),
        options: dio.Options(
          responseType: dio.ResponseType.plain,
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );
      return result;
    } on dio.DioException catch (ex) {
      // Check for timeout or other errors
      if (ex.type == DioExceptionType.connectionTimeout) {
        // Return a custom response or throw an exception with more details
        return dio.Response(
          requestOptions: ex.requestOptions,
          statusCode: 408, // HTTP 408 Request Timeout
          statusMessage: "Connection Timeout",
        );
      }

      // Return the error response from DioException
      return dio.Response(
        requestOptions: ex.requestOptions,
        statusCode:
            ex.response?.statusCode ??
            500, // Default to HTTP 500 if no status code
        statusMessage: ex.message,
        data: ex.response?.data, // Include error data if available
      );
    }
  }

  @override
  Future<dio.Response?> ticketSave(TicketsaveReq value) async {
    final sharedValue = await SharedPrefManager.instance.getSharedData();
    final token = sharedValue!.accessTkn;
    try {
      final result = await dioclient.post(
        url.tktSaveUrl,
        data: value.toJson(),
        options: dio.Options(
          responseType: dio.ResponseType.plain,
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );
      return result;
    } on dio.DioException catch (ex) {
      // Check for timeout or other errors
      if (ex.type == DioExceptionType.connectionTimeout) {
        return dio.Response(
          requestOptions: ex.requestOptions,
          statusCode: 408, // HTTP 408 Request Timeout
          statusMessage: "Connection Timeout",
        );
      }
      return dio.Response(
        requestOptions: ex.requestOptions,
        statusCode:
            ex.response?.statusCode ??
            500, // Default to HTTP 500 if no status code
        statusMessage: ex.message,
        data: ex.response?.data, // Include error data if available
      );
    }
  }

  @override
  Future<dio.Response?> fetchTkt(Farereq value) async {
    final sharedValue = await SharedPrefManager.instance.getSharedData();
    final token = sharedValue!.accessTkn;
    try {
      final result = await dioclient.post(
        url.fetchtktUrl,
        data: value.toJson(),
        options: dio.Options(
          responseType: dio.ResponseType.plain,
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );
      return result;
    } on dio.DioException catch (ex) {
      // Check for timeout or other errors
      if (ex.type == DioExceptionType.connectionTimeout) {
        return dio.Response(
          requestOptions: ex.requestOptions,
          statusCode: 408, // HTTP 408 Request Timeout
          statusMessage: "Connection Timeout",
        );
      }
      return dio.Response(
        requestOptions: ex.requestOptions,
        statusCode:
            ex.response?.statusCode ??
            500, // Default to HTTP 500 if no status code
        statusMessage: ex.message,
        data: ex.response?.data, // Include error data if available
      );
    }
  }

  @override
  Future<dio.Response?> searchBus(Farereq value) async {
    final sharedValue = await SharedPrefManager.instance.getSharedData();
    final token = sharedValue!.accessTkn;
    try {
      final result = await dioclient.post(
        url.searchBusUrl,
        data: value.toJson(),
        options: dio.Options(
          responseType: dio.ResponseType.plain,
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );
      return result;
    } on dio.DioException catch (ex) {
      // Check for timeout or other errors
      if (ex.type == DioExceptionType.connectionTimeout) {
        // Return a custom response or throw an exception with more details
        return dio.Response(
          requestOptions: ex.requestOptions,
          statusCode: 408, // HTTP 408 Request Timeout
          statusMessage: "Connection Timeout",
        );
      }

      // Return the error response from DioException
      return dio.Response(
        requestOptions: ex.requestOptions,
        statusCode:
            ex.response?.statusCode ??
            500, // Default to HTTP 500 if no status code
        statusMessage: ex.message,
        data: ex.response?.data, // Include error data if available
      );
    }
  }

  @override
  Future<dio.Response?> sortBus(Farereq value) async {
    final sharedValue = await SharedPrefManager.instance.getSharedData();
    final token = sharedValue!.accessTkn;
    try {
      final result = await dioclient.post(
        url.busSortUrl,
        data: value.toJson(),
        options: dio.Options(
          responseType: dio.ResponseType.plain,
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );
      return result;
    } on dio.DioException catch (ex) {
      if (ex.type == DioExceptionType.connectionTimeout) {
        return dio.Response(
          requestOptions: ex.requestOptions,
          statusCode: 408, // HTTP 408 Request Timeout
          statusMessage: "Connection Timeout",
        );
      }
      return dio.Response(
        requestOptions: ex.requestOptions,
        statusCode:
            ex.response?.statusCode ??
            500, // Default to HTTP 500 if no status code
        statusMessage: ex.message,
        data: ex.response?.data,
      );
    }
  }

  @override
  Future<dio.Response?> fetchStopLoc(Farereq value) async {
    final sharedValue = await SharedPrefManager.instance.getSharedData();
    final token = sharedValue!.accessTkn;
    try {
      final result = await dioclient.post(
        url.fetchStopLocUrl,
        data: value.toJson(),
        options: dio.Options(
          responseType: dio.ResponseType.plain,
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );
      return result;
    } on dio.DioException catch (ex) {
      if (ex.type == DioExceptionType.connectionTimeout) {
        return dio.Response(
          requestOptions: ex.requestOptions,
          statusCode: 408, // HTTP 408 Request Timeout
          statusMessage: "Connection Timeout",
        );
      }
      return dio.Response(
        requestOptions: ex.requestOptions,
        statusCode: ex.response?.statusCode ?? 500,
        statusMessage: ex.message,
        data: ex.response?.data, // Include error data if available
      );
    }
  }

  @override
  Future<dio.Response?> liveBusLoc(Farereq value) async {
    final sharedValue = await SharedPrefManager.instance.getSharedData();
    final token = sharedValue!.accessTkn;
    try {
      final result = await dioclient.post(
        url.busLiveLocUrl,
        data: value.toJson(),
        options: dio.Options(
          responseType: dio.ResponseType.plain,
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );
      return result;
    } on dio.DioException catch (ex) {
      if (ex.type == DioExceptionType.connectionTimeout) {
        return dio.Response(
          requestOptions: ex.requestOptions,
          statusCode: 408,
          statusMessage: "Connection Timeout",
        );
      }
      return dio.Response(
        requestOptions: ex.requestOptions,
        statusCode: ex.response?.statusCode ?? 500,
        statusMessage: ex.message,
        data: ex.response?.data, // Include error data if available
      );
    }
  }

  @override
  Future<dio.Response?> ticketStatus(Farereq value) async {
    final sharedValue = await SharedPrefManager.instance.getSharedData();
    final token = sharedValue!.accessTkn;
    try {
      final result = await dioclient.post(
        url.ticketStatusUrl,
        data: value.toJson(),
        options: dio.Options(
          responseType: dio.ResponseType.plain,
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );
      return result;
    } on dio.DioException catch (ex) {
      if (ex.type == DioExceptionType.connectionTimeout) {
        return dio.Response(
          requestOptions: ex.requestOptions,
          statusCode: 408, // HTTP 408 Request Timeout
          statusMessage: "Connection Timeout",
        );
      }
      return dio.Response(
        requestOptions: ex.requestOptions,
        statusCode:
            ex.response?.statusCode ??
            500, // Default to HTTP 500 if no status code
        statusMessage: ex.message,
        data: ex.response?.data, // Include error data if available
      );
    }
  }

  @override
  Future<dio.Response?> checkPayStatus(Farereq value) async {
    final sharedValue = await SharedPrefManager.instance.getSharedData();
    final token = sharedValue!.accessTkn;
    try {
      final result = await dioclient.post(
        url.checkPayStsUrl,
        data: value.toJson(),
        options: dio.Options(
          responseType: dio.ResponseType.plain,
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );
      return result;
    } on dio.DioException catch (ex) {
      if (ex.type == DioExceptionType.connectionTimeout) {
        return dio.Response(
          requestOptions: ex.requestOptions,
          statusCode: 408, // HTTP 408 Request Timeout
          statusMessage: "Connection Timeout",
        );
      }
      return dio.Response(
        requestOptions: ex.requestOptions,
        statusCode:
            ex.response?.statusCode ??
            500, // Default to HTTP 500 if no status code
        statusMessage: ex.message,
        data: ex.response?.data, // Include error data if available
      );
    }
  }

  @override
  Future<dio.Response?> paymntUpdate(TicketsaveReq value) async {
    final sharedValue = await SharedPrefManager.instance.getSharedData();
    final token = sharedValue!.accessTkn;
    try {
      final result = await dioclient.post(
        url.payStsUpdtUrl,
        data: value.toJson(),
        options: dio.Options(
          responseType: dio.ResponseType.plain,
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );
      return result;
    } on dio.DioException catch (ex) {
      if (ex.type == DioExceptionType.connectionTimeout) {
        return dio.Response(
          requestOptions: ex.requestOptions,
          statusCode: 408, // HTTP 408 Request Timeout
          statusMessage: "Connection Timeout",
        );
      }
      return dio.Response(
        requestOptions: ex.requestOptions,
        statusCode:
            ex.response?.statusCode ??
            500, // Default to HTTP 500 if no status code
        statusMessage: ex.message,
        data: ex.response?.data, // Include error data if available
      );
    }
  }

  @override
  Future<dio.Response?> deleteUser(UserCmnReq value) async {
    final sharedValue = await SharedPrefManager.instance.getSharedData();
    final token = sharedValue!.accessTkn;
    try {
      final result = await dioclient.post(
        url.deleteUrl,
        data: value.toJson(),
        options: dio.Options(
          responseType: dio.ResponseType.plain,
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );
      return result;
    } on dio.DioException catch (ex) {
      if (ex.type == DioExceptionType.connectionTimeout) {
        return dio.Response(
          requestOptions: ex.requestOptions,
          statusCode: 408, // HTTP 408 Request Timeout
          statusMessage: "Connection Timeout",
        );
      }
      return dio.Response(
        requestOptions: ex.requestOptions,
        statusCode:
            ex.response?.statusCode ??
            500, // Default to HTTP 500 if no status code
        statusMessage: ex.message,
        data: ex.response?.data, // Include error data if available
      );
    }
  }

  @override
  Future<dio.Response?> checkUpdate(Deviceinfo value) async {
    final sharedValue = await SharedPrefManager.instance.getSharedData();
    final token = sharedValue!.accessTkn;
    try {
      final result = await dioclient.post(
        url.checkUpdtUrl,
        data: value.toJson(),
        options: dio.Options(
          responseType: dio.ResponseType.plain,
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );
      return result;
    } on DioException catch (ex) {
      // Check for timeout or other errors
      if (ex.type == DioExceptionType.connectionTimeout) {
        // Return a custom response or throw an exception with more details
        return dio.Response(
          requestOptions: ex.requestOptions,
          statusCode: 408, // HTTP 408 Request Timeout
          statusMessage: "Connection Timeout",
        );
      }
      // Return the error response from DioException
      return dio.Response(
        requestOptions: ex.requestOptions,
        statusCode:
            ex.response?.statusCode ??
            500, // Default to HTTP 500 if no status code
        statusMessage: ex.message,
        data: ex.response?.data, // Include error data if available
      );
    }
  }
}
