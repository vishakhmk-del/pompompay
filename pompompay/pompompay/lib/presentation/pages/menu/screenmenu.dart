import 'dart:developer';
import 'package:pompompay/core/hook/hooks.dart';
import 'package:sizer/sizer.dart';

class ScreenMenu extends StatefulWidget {
  const ScreenMenu({super.key,required this.screen});
final int screen;
  @override
  State<ScreenMenu> createState() => _ScreenMenuState();
}

class _ScreenMenuState extends State<ScreenMenu> {
  String? usrNm;
  String? mobno;

  @override
  void initState() {
    super.initState();
    userdet();
  }

  void userdet() async {
    final val = await SharedPrefManager.instance.getSharedData();
    setState(() {
      usrNm = val!.name;
      mobno = val.mobno;
    });
  }

  Future<bool?> popscreen(BuildContext context) async {
    // BankAccountFun.instance.getbnkLstNotifier.value = [];
    Navigator.pushReplacement(context, Approutes().mainScreen);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          log('Screen was popped with result: $result');
          return;
        }
        //log('BackButton pressed! Navigating to login screen.');
        await popscreen(context);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,

        body: Material(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
                Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: widget.screen==menu?MediaQuery.of(context).size.height / 1.3:MediaQuery.of(context).size.height / 1.3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).colorScheme.secondary,
                            Theme.of(context).colorScheme.primary,
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(50),
                          // bottomLeft: Radius.circular(50)
                        ),
                      ),
                      child: Text(""),
                    ),
                  ],
                ),
                Positioned(
                  top: widget.screen==menu?MediaQuery.of(context).size.height * .14:MediaQuery.of(context).size.height * .14,
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.19,
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //SizedBox(width: 10),
                      Text(
                        "$usrNm"
                            .toUpperCase(), // Replace with your dynamic name
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Poppins-Medium',
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        textScaler: TextScaler.noScaling,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * .12,
                  left: MediaQuery.of(context).size.width * 0.7,
                  //right: MediaQuery.of(context).size.width * 0.1,
                  child: CircleAvatar(
                    radius: 45, // Adjust size
                    backgroundColor:
                        Theme.of(context).colorScheme.onPrimary, // Circle color
                    child: IconButton(
                      icon: Icon(
                        Icons.person_2_rounded,
                        color:
                            Theme.of(context).colorScheme.primary, // Icon color
                        size: 30,
                      ),
                      onPressed: () {
                        // Navigator.pushReplacement(context, Approutes().screenprofile);
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * .18,
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.19,
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //SizedBox(width: 10),
                      Text(
                        "$mobno"
                            .toUpperCase(), // Replace with your dynamic name
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins-Medium',
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        textScaler: TextScaler.noScaling,
                      ),
                      //   SizedBox(width: 10),
                    ],
                  ),
                ),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Container(
                //     width: MediaQuery.of(context).size.width,
                //     height: MediaQuery.of(context).size.height / 1.5,
                //     decoration: BoxDecoration(
                //       color: Theme.of(context).colorScheme.primary,

                //       // borderRadius:const BorderRadius.only(bottomRight: Radius.circular(70))
                //     ),
                //   ),
                // ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height:widget.screen==menu? MediaQuery.of(context).size.height / 1.42:MediaQuery.of(context).size.height / 1.65,
                    //padding: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: ListView(
                      children: [
                        // ListTile(
                        //   leading: Icon(
                        //     Icons.account_balance_outlined,
                        //     size: 25,
                        //     color: Theme.of(context).colorScheme.primary,
                        //     //color: Appcolors.labelclr,
                        //   ),
                        //   title: Text(
                        //     "Transaction",
                        //     style: TextStyle(
                        //       fontFamily: 'Poppins-Medium',
                        //       fontSize: 18,
                        //       fontWeight: FontWeight.w500,
                        //       color: Colors.black,
                        //     ),
                        //     textScaler: TextScaler.noScaling,
                        //   ),
                        //   onTap: () {},
                        // ),
                        // SizedBox(height: 10),
                        // Divider(
                        //   color: Colors.black26, // Set the color of the divider
                        //   thickness: .5, // Set the thickness of the divider
                        //   // indent: 5,          // Optional: Add left spacing
                        //   // endIndent: 5,       // Optional: Add right spacing
                        // ),
                        ListTile(
                          leading: Icon(
                            Icons.privacy_tip_outlined,
                            size: 25,
                            color: Theme.of(context).colorScheme.primary,
                            //color: Appcolors.labelclr,
                          ),
                          title: Text(
                            "Privacy & security",
                            style: TextStyle(
                              fontFamily: 'Poppins-Medium',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            textScaler: TextScaler.noScaling,
                          ),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.info_outline,
                            size: 25,
                            color: Theme.of(context).colorScheme.primary,
                            //color: Appcolors.labelclr,
                          ),
                          title: Text(
                            "About",
                            style: TextStyle(
                              fontFamily: 'Poppins-Medium',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            textScaler: TextScaler.noScaling,
                          ),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.power_settings_new,
                            size: 25,
                            color: Theme.of(context).colorScheme.primary,
                            //color: Appcolors.labelclr,
                          ),
                          title: Text(
                            "Sign out",
                            style: TextStyle(
                              fontFamily: 'Poppins-Medium',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            textScaler: TextScaler.noScaling,
                          ),
                          onTap: () {
                            warningBox(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

               widget.screen==menu? Positioned(
                  top: 40,
                  left: 10,
                  right: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder:
                            (context) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      Approutes().mainScreen,
                                    );
                                  },
                                ),
                              ],
                            ),
                      ),
                    ],
                  ),
                ):SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future warningBox(BuildContext context) async => showDialog<bool>(
    barrierDismissible: false,
    context: context,
    builder:
        (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primaryFixed,
          title: Center(
            child: Text(
              "Sign Out?",
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontSize: 18.sp),
            ),
          ),
          content: Text(
            "Are you sure you want to Sign Out?",
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontSize: 18.sp),
          ),

          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'NO',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                signout(context);
              },
              child: Text(
                'YES',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
          ],
        ),
  );

  void signout(BuildContext context) async {
    final sharedprf = await SharedPreferences.getInstance();
    await sharedprf.remove(savekeyname);

    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx) => const Screenlogin()),
      (Route<dynamic> route) => false,
    );
  }
}
