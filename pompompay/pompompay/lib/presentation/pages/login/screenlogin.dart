import 'dart:developer';
import 'package:pompompay/core/hook/hooks.dart';
import 'package:sizer/sizer.dart';

class Screenlogin extends StatefulWidget {
  const Screenlogin({super.key});

  @override
  State<Screenlogin> createState() => _ScreenloginState();
}

class _ScreenloginState extends State<Screenlogin> {
  final _usercontroller = TextEditingController();
  final _passcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool passtoggle = true;
  double doublelat = 0;
  double doublelong = 0;
  String locationMessage = 'Current Location of the User';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Livelocationfun.instance.startTracking(
        context: context,
        onLocationUpdate: (position) {
          setState(() {
            doublelat = position.latitude;
            doublelong = position.longitude;
            locationMessage =
                'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
            log('asgnd screen  init:$locationMessage');
          });
        },
      );
    });
  }

  @override
  void dispose() {
    Livelocationfun.instance.stopTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundColorGradient(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              // Top: Green area with form
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      key: _formkey,
                      child: Theme(
                        data: MyTheme.googleFormTheme,
                        child: Column(
                          children: [
                            SizedBox(height: 15.h),
                            const CircleAvatar(
                              //backgroundColor: Colors.red,
                              backgroundImage: AssetImage(
                                'assets/image/login/Untitled design (5).png',
                              ),
                              radius: 50,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'LOGIN',
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(fontSize: 24),
                            ),
                            SizedBox(height: 5.h),
                            // Username
                            TextFormField(
                              controller: _usercontroller,
                              cursorColor: Colors.white,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Mobile Number',
                                labelStyle: Theme.of(
                                  context,
                                ).textTheme.labelSmall?.copyWith(fontSize: 14),
                                prefixIcon: Theme(
                                  data: MyTheme.appIconTheme,
                                  child: const Icon(Icons.account_box_rounded),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Mobile Number";
                                } else if (value.contains('.') ||
                                    value.contains("-") ||
                                    value.contains(" ") ||
                                    value.contains(",")) {
                                  return "Enter valid Mobile Number";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 3.h),
                            // Password
                            TextFormField(
                              controller: _passcontroller,
                              cursorColor: Colors.white,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              obscureText: passtoggle,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: Theme.of(
                                  context,
                                ).textTheme.labelSmall?.copyWith(fontSize: 14),
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter password';
                                } else if (value.contains(' ')) {
                                  return 'Remove space from password';
                                }
                                return null;
                              },
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  Approutes().frgtpswrdscreen,
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: Theme.of(
                                  context,
                                ).textTheme.labelSmall?.copyWith(fontSize: 16),
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Container(
                              height: 6.h,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    // Color.fromARGB(255, 198, 120, 3),
                                    //   Color.fromARGB(255, 198, 120, 3),
                                    Color(0xffffa600),
                                    Color(0xffffa600),

                                    // Color(0xffffbd59),
                                    // Color(0xffffbd59),
                                  ],
                                ),
                              ),
                              child: Theme(
                                data: MyTheme.buttonStyleTheme,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formkey.currentState!.validate()) {
                                      final logreq = UserCmnReq(
                                        userName: _usercontroller.text,
                                        pw: _passcontroller.text,
                                      );
                                      UserFun.instance.getlogin(
                                        logreq,
                                        context,
                                      );
                                    }
                                  },
                                  child: Text(
                                    'LOGIN',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),

                            Text(
                              "If you don't have any account",
                              style: Theme.of(
                                context,
                              ).textTheme.labelSmall?.copyWith(fontSize: 16),
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Please",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(fontSize: 16),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        enableDrag: true,
                                        isDismissible: true,
                                        isScrollControlled: true,
                                        //backgroundColor: const Color(0xff00c7c8),
                                        //Color.fromARGB(255, 6, 173, 162),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10),
                                          ),
                                        ),
                                        context: context,
                                        builder:
                                            (context) => const ScreenRegister(),
                                      ).whenComplete(() {
                                        // Reset the button state when bottom sheet is closed
                                        if (!context.mounted) return;
                                        context
                                            .read<LoadingProvider>()
                                            .resetAll();
                                      });
                                    },
                                    child: Text(
                                      'Register',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelSmall?.copyWith(
                                        fontSize: 20,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // // Bottom: White area with logo
              // Container(
              //   width: double.infinity,
              //   color: Colors.white,
              //   padding: const EdgeInsets.symmetric(vertical: 13),
              //   child: Image.asset(
              //     "assets/image/login/logo_dits.png",
              //     height: 45,
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
