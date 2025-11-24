import 'dart:convert';
import 'dart:developer';

import 'package:pompompay/core/hook/hooks.dart';

class ScreenForgotPswrd extends StatefulWidget {
  const ScreenForgotPswrd({super.key});

  @override
  State<ScreenForgotPswrd> createState() => _ScreenForgotPswrdState();
}

class _ScreenForgotPswrdState extends State<ScreenForgotPswrd> {
  final _formkey = GlobalKey<FormState>();
  final _scafoldkey = GlobalKey<ScaffoldState>();
  final _usernamecontroller = TextEditingController();
  final _newpswrdcontroller = TextEditingController();
  final _cnfrmpswrdcontroller = TextEditingController();
  bool passtoggle = true;
  String? selectedBusType;
  List<String> busTypeList = [];
  String? mob;
  String? newpswrd;
  String? cnfrmpswrd;
  int? refid;

  @override
  void initState() {
    super.initState();
    // fetchBusList();
    Future.delayed(Duration.zero, () {
      if (!mounted) return;
      context.read<ElevatedBtnProvider>().changeSelectedVal(false);
    });
    //context.read<ElevatedBtnProvider>().changeSelectedVal(false);
  }

  Future<bool?> popscreen(BuildContext context) async {
    Navigator.pushReplacement(context, Approutes().loginscreen);
    context.read<ElevatedBtnProvider>().changeSelectedVal(false);
    context.read<LoadingProvider>().resetAll();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundColorGradient(),

        PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, Object? result) async {
            if (didPop) {
              log('Screen was popped with result: $result');
              return;
            }
            log('BackButton pressed! Navigating to login screen.');
            await popscreen(context);
          },
          child: Scaffold(
            key: _scafoldkey,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacement(context, Approutes().loginscreen);
                  context.read<ElevatedBtnProvider>().changeSelectedVal(false);
                  context.read<LoadingProvider>().resetAll();

                },
              ),
             
            ),
            body: Center(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Theme(
                      data: MyTheme.googleFormTheme,
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            Text(
                              'Forgot Password',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: TextFormField(
                                controller: _usernamecontroller,
                                cursorColor: Colors.white,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Mobile Number',
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(fontSize: 14),
                                  hintText: 'Enter Registered Mobile Number',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(fontSize: 14),
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter Mobile Number";
                                  } else if (value.contains('.') ||
                                      value.contains("-") ||
                                      value.contains(" ") ||
                                      value.contains(",")) {
                                    return "Enter valid Mobile Number";
                                  } else if (_usernamecontroller.text.length <
                                          10 ||
                                      _usernamecontroller.text.length > 10) {
                                    return "Enter valid Mobile number";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: TextFormField(
                                controller: _newpswrdcontroller,
                                cursorColor: Colors.white,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'New Password',
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(fontSize: 14),
                                  prefixIcon: Theme(
                                    data: MyTheme.appIconTheme,
                                    child: const Icon(Icons.lock),
                                  ),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        passtoggle = !passtoggle;
                                      });
                                    },
                                    child: Theme(
                                      data: MyTheme.appIconTheme,
                                      child: Icon(
                                        passtoggle
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                    ),
                                  ),
                                ),
                                obscureText: passtoggle,
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  } else if (value.length < 8) {
                                    return 'Password must be at least 8 characters';
                                  } else if (!RegExp(
                                    r'[A-Z]',
                                  ).hasMatch(value)) {
                                    return 'Password must contain at least one uppercase letter';
                                  } else if (!RegExp(
                                    r'[!@#$%^&*(),.?":{}|<>]',
                                  ).hasMatch(value)) {
                                    return 'Password must contain at least one special character';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: TextFormField(
                                controller: _cnfrmpswrdcontroller,
                                cursorColor: Colors.white,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(fontSize: 14),
                                  prefixIcon: Theme(
                                    data: MyTheme.appIconTheme,
                                    child: const Icon(Icons.lock),
                                  ),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        passtoggle = !passtoggle;
                                      });
                                    },
                                    child: Theme(
                                      data: MyTheme.appIconTheme,
                                      child: Icon(
                                        passtoggle
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                    ),
                                  ),
                                ),
                                obscureText: passtoggle,
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  } else if (value !=
                                      _newpswrdcontroller.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    // Color.fromARGB(255, 198, 120, 3),
                                    // Color.fromARGB(255, 198, 120, 3),
                                    Color(0xffffa600),
                                    Color(0xffffa600),
                                  ],
                                ),
                              ),
                              child: Theme(
                                data: MyTheme.buttonStyleTheme,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formkey.currentState!.validate()) {
                                      setState(() {
                                        mob = _usernamecontroller.text;
                                        newpswrd = _newpswrdcontroller.text;
                                        cnfrmpswrd = _cnfrmpswrdcontroller.text;
                                      });
                                      userVerify(mob, context);
                                    }
                                  },
                                  child: Text(
                                    'RESET',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Consumer<LoadingProvider>(
                              builder: (context, loadingProvider, child) {
                                return loadingProvider.isLoading
                                    ? const Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Color.fromARGB(255, 2, 128, 6),
                                            ),
                                      ),
                                    )
                                    : const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Consumer<ElevatedBtnProvider>(
                    builder: (context, provider, child) {
                      if (provider.selectedVal == false) {
                        return Container();
                      } else if (provider.selectedVal == true) {
                        return OtpFiled(
                          type: frgtpswrdType,
                          mob: mob,
                          nwpswd: newpswrd,
                          cnfrmpswrd: cnfrmpswrd,
                          //refId: refid,
                        );
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future userVerify(String? mob, BuildContext context) async {
    try {
      final loadingProvider = context.read<LoadingProvider>();
      loadingProvider.show();

      final val = UserCmnReq(mobno: mob);

      final chngresp = await Pompaydata().frgtPswrdOtp(val);
      final resultAsjson = jsonDecode(chngresp.toString());
      final changeval = UserCmnResp.fromJson(
        resultAsjson as Map<String, dynamic>,
      );

      loadingProvider.resetAll();
      if (chngresp == null) {
        if (!context.mounted) return;
        CommonFun.instance.showApierror(context, "Something went wrong");
      } else if (chngresp.statusCode == 200 && changeval.status == 'success') {
        //refid = changeval.data?.refId ?? 0;
        if (!context.mounted) return;

        context.read<ElevatedBtnProvider>().changeSelectedVal(true);
        if (!context.mounted) return;

        CommonFun.instance.showApierror(
          context,
          "Otp sended on your registered mobile No",
        );
        if (!context.mounted) return;

        context.read<ElevatedBtnProvider>().changeSelectedVal(true);
      } else if (changeval.status == 'failed') {
        if (!context.mounted) return;

        CommonFun.instance.showApierror(
          context,
          changeval.message,
        );
      } else if (chngresp.statusCode == 500) {
        if (!context.mounted) return;
        CommonFun.instance.showApierror(context, "Sever Not reached");

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
}
