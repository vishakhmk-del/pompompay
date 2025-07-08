import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:pompompay/core/hook/hooks.dart';

class OtpFiled extends StatefulWidget {
  const OtpFiled({
    super.key,
    this.penNO,
    this.nwpswd,
    this.cnfrmpswrd,
    this.refId,
    this.mob,
    required this.type,
  });
  final String? penNO;
  final String? nwpswd;
  final String? cnfrmpswrd;
  final int? refId;
  final String? mob;
  final String type;

  @override
  State<OtpFiled> createState() => _OtpFiledState();
}

class _OtpFiledState extends State<OtpFiled> {
  Timer? _timer;
  final _scafoldkey = GlobalKey<ScaffoldState>();

  int remainingsec = 0;

  final time = '00:0-'.obs;

  int start = 180;

  bool wait = false;

  String? otppin;
  OtpFieldController otpController = OtpFieldController();
  @override
  void initState() {
    //checkUserLoggedIn();
    starttimer(start);
    super.initState();
    // setState(() {
    //   wait=false;
    // });
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.put(TimerController());
    return Stack(
      key: _scafoldkey,
      children: [
        Column(
          children: [
            const SizedBox(height: 10),
            Text(
              'OTP Verification',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Enter OTP code sent to your mobile \n+91-${widget.mob}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 30),
            OTPTextField(
              controller: otpController,
              length: 6,
              width: size.width - 30,
              fieldWidth: 54,
              otpFieldStyle: OtpFieldStyle(
                backgroundColor: Color(0xff07534e),
                borderColor: const Color(0xFFE1E1E1),
                focusBorderColor: const Color(0xFFE1E1E1),
                enabledBorderColor: const Color(0xFFE1E1E1),
              ),
              style: Theme.of(context).textTheme.titleMedium!,
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.box,
              onChanged: (String? pin) {
                if (pin?.length == 6) {
                  otppin = pin;
                  log('$otppin');
                }
              },
            ),
            const SizedBox(height: 15),
            buildtimer(),
            TextButton(
              onPressed: () async {
                if (wait == true) {
                  final value = UserCmnReq(
                    mobno: widget.mob,
                    type: widget.type,
                  );
                  final val = await UserFun.instance.resndotp(value, context);
                  if (val == 'failed') {
                    setState(() {
                      wait = true;
                    });
                  } else {
                    setState(() {
                      starttimer(180);
                      wait = false;
                    });
                  }
                } else {
                  CommonFun.instance.showApierror(
                    context,
                    "Please wait until the timer reaches zero.",
                  );
                }
              },
              child: Text(
                'Resend OTP',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Consumer<LoadingProvider>(
              builder: (context, loadingProvider, child) {
                return loadingProvider.isLoading
                    ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 2, 128, 6),
                        ),
                      ),
                    )
                    : const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 25),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xffffa600),
                    Color(0xffffa600),
                    // Color.fromARGB(255, 198, 120, 3),
                    // Color.fromARGB(255, 198, 120, 3),
                  ],
                ),
              ),
              child: Theme(
                data: MyTheme.buttonStyleTheme,
                child: ElevatedButton(
                  onPressed: () async {
                    if (otppin == null) {
                      Fluttertoast.showToast(
                        msg: 'Please Enter OTP',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    } else {
                      if (widget.type == frgtpswrdType) {
                        final otpreq = UserCmnReq(
                          pw: widget.cnfrmpswrd,
                          mobno: widget.mob,
                          otp: otppin,
                          type: widget.type,
                        );
                        buildotpvrf(otpreq, context);
                      } else if (widget.type == regType) {
                        final otpreq = UserCmnReq(
                          mobno: widget.mob,
                          type: widget.type,
                          otp: otppin,
                        );
                        buildotpvrf(otpreq, context);
                      }
                    }
                    // usrNameBox(context,0,'');
                  },
                  child: Text(
                    'VERIFY',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ],
    );
  }

  starttimer(int seconds) {
    const duration = Duration(seconds: 1);
    remainingsec = seconds;
    _timer = Timer.periodic(duration, (Timer timer) {
      if (remainingsec == 0) {
        timer.cancel();
        // wait=false;
        wait = true;
      } else {
        int minutes = remainingsec ~/ 60;
        int seconds = (remainingsec % 60);
        time.value =
            "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
        remainingsec--;
      }
    });
  }

  Widget buildtimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'This otp will expired in ',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 16),
        ),
        Obx(
          () => Center(
            child: Text(
              time.value,
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Future buildotpvrf(UserCmnReq val, BuildContext context) async {
    final loadingProvider = context.read<LoadingProvider>();
    loadingProvider.toggleLoading();
    try {
      dio.Response<dynamic>? chngresp;
      if (val.type == frgtpswrdType) {
        chngresp = await Pompaydata().frgtpswrdvrfy(val);
      } else if (val.type == regType) {
        chngresp = await Pompaydata().regOtpvrf(val);
      }
      // if (!context.mounted) return;

      //   context.read<ElevatedBtnProvider>().changeSelectedVal(false);
      final resultAsjson = jsonDecode(chngresp.toString());

      final changeval = UserCmnResp.fromJson(
        resultAsjson as Map<String, dynamic>,
      );

      loadingProvider.toggleLoading();
      if (chngresp == null) {
        if (!context.mounted) return;
        CommonFun.instance.showApierror(context, "Something went wrong");
      } else if (chngresp.statusCode == 200 && changeval.status == 'success') {
        // refid=changeval.data?.refId ?? 0;
        if (!context.mounted) return;

        val.type == frgtpswrdType ? pswrdBox(context) : rgstrBox(context);
      } else if (changeval.status == 'failed') {
        if (!context.mounted) return;

        CommonFun.instance.showApierror(context, "Invalid OTP");
      } else if (chngresp.statusCode == 500) {
        if (!context.mounted) return;
        CommonFun.instance.showApierror(context, "Sever Not Reachable");

        // showLoginerror(context, 3);
      } else if (chngresp.statusCode == 408) {
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

  void pswrdBox(BuildContext context) {
    Fluttertoast.showToast(
      msg: "Password Changed Successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 15.0,
    );
    Navigator.pushReplacement(context, Approutes().loginscreen);
  }

  void rgstrBox(BuildContext context) {
    Fluttertoast.showToast(
      msg: "Registration completed Successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 15.0,
    );
    Navigator.pushReplacement(context, Approutes().loginscreen);
  }
}
