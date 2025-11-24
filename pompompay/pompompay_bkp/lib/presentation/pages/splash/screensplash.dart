import 'dart:convert';
import 'dart:developer';

import 'package:pompompay/core/hook/hooks.dart';
import 'package:pompompay/presentation/pages/main_page/screen_MainPage.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  String? deviceTkn;

  @override
  void initState() {
    checkUserLogin(context);
    super.initState();
  }

  Future<void> checkUserLogin(BuildContext context) async {
    final sharedPref = await SharedPreferences.getInstance();
    final userLoggedIn = sharedPref.getBool(savekeyname) ?? false;

    if (!userLoggedIn) {
      if (!context.mounted) return;

      gotoLogin(context);
    } else {
      final sharevalue = await SharedPrefManager.instance.getSharedData();

      if (sharevalue?.userId != null && sharevalue!.userId!.isNotEmpty) {
        await Future.delayed(const Duration(seconds: 3));

        if (!context.mounted) return;

        final value = await SharedPrefManager.instance.getdeviceinfo();
        // final val = await SharedPrefManager.instance.getdeviceTkn();
        // final tkn=val.devicetoken;
        // if((tkn??"").isEmpty){
        // // String? token=await messaging.getToken();
        //     // deviceTokn=token;
        // }else{
        //   deviceTokn=val.devicetoken;
        // }
        final shareddevice = Deviceinfo(
          userid: sharevalue.userId??'',
          phone: value.phone,
          deviceid: value.deviceid,
          // devicetoken: deviceTokn??'',
          phoneos: value.phoneos,
          androidid: value.androidid??'',
          osversion: value.osversion,
          appversion: value.appversion,
          buildnumber: value.buildnumber,
          // buildtime: value.buildtime
          );
          try{
      // final api = await Ciadata.getInstance();

          final deviceinforesp=await Pompaydata().checkUpdate(shareddevice);
          final resultAsjson = jsonDecode(deviceinforesp.toString());
          final deviceinfoval = UserCmnResp.fromJson(resultAsjson as Map<String, dynamic>);
              if (deviceinforesp == null) {
                log("deviceinfo response null");
              } 
              else if (deviceinforesp.statusCode == 200) {
              if(deviceinfoval.status=='success'){
                log("device details added");
                if (!context.mounted) return;

                Navigator.pushReplacement(
                  context,
                  Approutes().mainScreen,
                );
              }else if(deviceinfoval.status=='failed'){
                if(deviceinfoval.errorCode==null){
                  if (!context.mounted) return;
                  Navigator.pushReplacement(
                  context,
                  Approutes().mainScreen,
                );
              }else if(deviceinfoval.errorCode=='VERSION_UPDATE'){
                  if (!context.mounted) return;
                
                Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => ScreenMainpage(
                              version: deviceinfoval,
                            ),
                          ),
                        );
              }else{
                if (!context.mounted) return;
                         Navigator.pushReplacement(context, Approutes().mainScreen);

              }
                
              }
   
            log("device details ${deviceinforesp.statusCode}");
          }
           else if (deviceinforesp.statusCode  == 500) {
        if (!context.mounted) return;
        CommonFun.instance.showApierror(context, "Sever Not Reachable");

        // showLoginerror(context, 3);
      } else if (deviceinforesp.statusCode  == 408) {
        if (!context.mounted) return;
        CommonFun.instance.showApierror(context, "Connection time out");

        //showLoginerror(context, 4);
      }else{
            log("device details ${deviceinforesp.statusCode}");

              
              if (!context.mounted) return;

                    Navigator.pushReplacement(context, Approutes().mainScreen);

          }
          
          }catch(e){
           if (!context.mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('An unexpected error occurred')),
            );
              // if (!context.mounted) return;

                  Navigator.pushReplacement(context, Approutes().mainScreen);

        
          }

      } else {
        if (!context.mounted) return;

        gotoLogin(context);
      }
    }
  }

  Future<void> gotoLogin(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    getdeviceinform();

    if (!context.mounted) return;
    Navigator.pushReplacement(context, Approutes().splasharcPicture);

    // Navigator.pushReplacement(context, Approutes().screenLogin);
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundColorGradient(),
        Scaffold(
          backgroundColor: Colors.transparent,
          key: _scaffoldKey,
          body: Padding(
            padding: EdgeInsets.all(8),
            child: Center(
              child: Lottie.asset(
                'assets/lottie/splash/Animation - 1749547424170.json',
                width: MediaQuery.of(context).size.width / 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> getdeviceinform() async {
    try {
      /*************deviceinfo*****************/
      final device = await DeviceInformation.getdeviceinfo();
      log(device);
      final deviceid = await DeviceInformation.getdeviceid();
      log(deviceid);
      final deviceos = await DeviceInformation.getOSdetails();
      log(deviceos);
      final devicescreen = await DeviceInformation.getScreenResolution();
      log(devicescreen);
      final deviceversion = await DeviceInformation.getDeviceVersion();
      log(deviceversion);
      final packagename = await Appinfo.getpackageName();
      log(packagename);
      final appversion = await Appinfo.getappVersion();
      log(appversion);

      final ipaddress = await Ipinfo.getipAddress();
      log("ipaddress:$ipaddress");

      final appver = appversion.split('+');
      final version = appver[0];
      final buildno = appver[1];
      final platformId = await DeviceInformation.initPlatformId();
      log('android id: $platformId');

      /*****************************************/

      final shareddevice = Deviceinfo(
        phone: device,
        deviceid: deviceid,
        //devicetoken: deviceTkn??'',
        phoneos: deviceos,
        screenresolution: devicescreen,
        androidid: platformId ?? '',
        osversion: deviceversion,
        packagename: packagename,
        appversion: version,
        buildnumber: buildno,
      );

      await SharedPrefManager.instance.setdeviceinfo(shareddevice);
    } catch (e) {
      Navigator.pushReplacement(
        _scaffoldKey.currentContext!,
        Approutes().loginscreen,
      );
    }
  }
}
