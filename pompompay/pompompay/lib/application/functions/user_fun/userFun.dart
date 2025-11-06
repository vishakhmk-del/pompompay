import 'dart:convert';

import 'package:pompompay/core/hook/hooks.dart';

class UserFun {
  UserFun._internal();
  static UserFun instance = UserFun._internal();
  UserFun factory() {
    return instance;
  }

  Future<String?> resndotp(UserCmnReq val, BuildContext context) async {
    try {
      final loadingProvider = context.read<LoadingProvider>();
      loadingProvider.show();
      final chngresp = await Pompaydata().resndOtp(val);
      final resultAsjson = jsonDecode(chngresp.toString());
      final changeval = UserCmnResp.fromJson(
        resultAsjson as Map<String, dynamic>,
      );

      loadingProvider.resetAll();
      if (chngresp == null) {
        if (!context.mounted) return '';
        CommonFun.instance.showApierror(context, "Something went wrong");
      } else if (chngresp.statusCode == 200 && changeval.status == 'success') {
        //int refid = changeval.data?.refId ?? 0;
        if (!context.mounted) return '';

        CommonFun.instance.showApierror(
          context,
          "Otp resend on your registered mobile No",
        );

        return changeval.status;
      } else if (changeval.status == 'failed') {
        if (!context.mounted) return '';

        CommonFun.instance.showApierror(context, "OTP can't resend");
        return changeval.status;
      } else if (chngresp.statusCode == 500) {
        if (!context.mounted) return '';
        CommonFun.instance.showApierror(context, "Sever Not reached");

        // showLoginerror(context, 3);
      } else if (chngresp.statusCode == 408) {
        if (!context.mounted) return '';
        CommonFun.instance.showApierror(context, "Connection time out");

        //showLoginerror(context, 4);
      } else {
        if (!context.mounted) return '';
        CommonFun.instance.showApierror(context, "Something went wrong");
        //showLoginerror(context, 5);
      }
    } catch (e) {
      if (!context.mounted) return '';

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    }
    return null;
  }

  Future getlogin(UserCmnReq req, BuildContext context) async {
    try {
      final loadingProvider = context.read<LoadingProvider>();
      //FirebaseMessaging messaging=FirebaseMessaging.instance;
      //String? deviceTkn;
      loadingProvider.show();
      final value = await SharedPrefManager.instance.getdeviceinfo();
      // final val = await SharedPrefManager.instance.getdeviceTkn();
      // final tkn=val.devicetoken;
      // if((tkn??"").isEmpty){
      // // String? token=await messaging.getToken();
      // //     deviceTkn=token;
      // }else{
      //   deviceTkn=val.devicetoken;
      // }

      final logreq = UserCmnReq(
        pw: req.pw,
        userName: req.userName,
        deviceid: value.deviceid,
        device: value.phone,
        screenresolution: value.screenresolution,
        phoneos: value.phoneos,
        androidid: value.androidid,
        appversion: value.appversion,
        osversion: value.osversion,
        buildnumber: value.buildnumber,
      );

      final loginResponse = await Pompaydata().login(logreq);
      final resultAsjson = jsonDecode(loginResponse.toString());
      final loginval = UserCmnResp.fromJson(
        resultAsjson as Map<String, dynamic>,
      );

      loadingProvider.resetAll();
      if (loginResponse == null) {
        if (!context.mounted) return;

        CommonFun.instance.showApierror(context, "Something went wrong");
      } else if (loginResponse.statusCode == 200 &&
          loginval.status == 'success') {
        final sharedPrefLogin = Sharedpref(
          userId: loginval.data!.userId,
          name: loginval.data!.name,
          mobno: loginval.data!.mobno,
          accessTkn: loginval.data!.accessToken,
        );

        if (!context.mounted) return;

        context.read<LoadingProvider>().resetAll();

        await SharedPrefManager.instance.addSharedData(sharedPrefLogin);

        /**************************/
        if (!context.mounted) return;

        Navigator.pushReplacement(context, Approutes().mainScreen);
      } else if (loginval.status == 'failed') {
        if (loginval.message == "mobile number not verified.") {
          if (!context.mounted) return;
          CommonFun.instance.showApierror(
            context,
            "Please verfiy mobile number",
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ScreenOtp(mobileno: req.userName),
            ),
          );
        } else {
          if (!context.mounted) return;
          CommonFun.instance.showApierror(
            context,
            "Username or password Incorrect",
          );
        }

        // showLoginerror(context, 2);
      } else if (loginResponse.statusCode == 500) {
        if (!context.mounted) return;
        CommonFun.instance.showApierror(context, "Sever Not Reachable");

        // showLoginerror(context, 3);
      } else if (loginResponse.statusCode == 408) {
        if (!context.mounted) return;
        CommonFun.instance.showApierror(context, "Connection time out");

        //showLoginerror(context, 4);
      } else {
        if (!context.mounted) return;
        CommonFun.instance.showApierror(context, "Something went wrong");
        //showLoginerror(context, 5);
      }
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    }
  }

  Future registerFn(UserCmnReq req, BuildContext context) async {
    try {
      final loadingProvider = context.read<LoadingProvider>();
      // final loader = Provider.of<LoadingProvider>(context, listen: false);
      //FirebaseMessaging messaging=FirebaseMessaging.instance;
      //String? deviceTkn;
      loadingProvider.show();
      final value = await SharedPrefManager.instance.getdeviceinfo();
      // final val = await SharedPrefManager.instance.getdeviceTkn();
      // final tkn=val.devicetoken;
      // if((tkn??"").isEmpty){
      // // String? token=await messaging.getToken();
      // //     deviceTkn=token;
      // }else{
      //   deviceTkn=val.devicetoken;
      // }
      final regReq = UserCmnReq(
        pw: req.pw,
        userName: req.userName,
        mobno: req.mobno,
        deviceid: value.deviceid,
        device: value.phone,
        screenresolution: value.screenresolution,
        phoneos: value.phoneos,
        androidid: value.androidid,
        appversion: value.appversion,
        osversion: value.osversion,
        buildnumber: value.buildnumber,
      );
      final loginResponse = await Pompaydata().registration(regReq);
      final resultAsjson = jsonDecode(loginResponse.toString());
      final loginval = UserCmnResp.fromJson(
        resultAsjson as Map<String, dynamic>,
      );

      loadingProvider.resetAll();
      if (loginResponse == null) {
        if (!context.mounted) return;

        CommonFun.instance.showApierror(context, "Something went wrong");
      } else if (loginResponse.statusCode == 200 &&
          loginval.status == 'success') {
        if (!context.mounted) return;
        CommonFun.instance.showApierror(context, "Please verify Mobile number");

        //Navigator.pushReplacement(context, Approutes().screenLogin);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ScreenOtp(mobileno: req.mobno),
          ),
        );
      } else if (loginval.status == 'failed') {
        if (!context.mounted) return;
        CommonFun.instance.showApierror(context, loginval.message);

        // showLoginerror(context, 2);
      } else if (loginResponse.statusCode == 500) {
        if (!context.mounted) return;
        CommonFun.instance.showApierror(context, "Sever Not Reachable");

        // showLoginerror(context, 3);
      } else if (loginResponse.statusCode == 408) {
        if (!context.mounted) return;
        CommonFun.instance.showApierror(context, "Connection time out");

        //showLoginerror(context, 4);
      } else {
        if (!context.mounted) return;
        CommonFun.instance.showApierror(context, "Something went wrong");
        //showLoginerror(context, 5);
      }
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    }
  }
}
