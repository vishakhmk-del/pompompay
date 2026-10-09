import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pompompay/core/hook/hooks.dart';
import 'package:sizer/sizer.dart';

class ScreenMenu extends StatefulWidget {
  const ScreenMenu({super.key, required this.screen});
  final int screen;
  @override
  State<ScreenMenu> createState() => _ScreenMenuState();
}

class _ScreenMenuState extends State<ScreenMenu> {
  String usrNm = '';
  String? mobno;

  @override
  void initState() {
    super.initState();
    userdet();
  }

  void userdet() async {
    final val = await SharedPrefManager.instance.getSharedData();
    if (!mounted) return;

    setState(() {
      usrNm = val!.name ?? '';
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
        if (!didPop) {
          if (widget.screen == menu) {
            //   log('Screen was popped with result: $result');
            // return;
            await popscreen(context);
          }
          // else {
          //   final confirmExit = await showWarning(context);
          //   if (confirmExit == true) {
          //     SystemNavigator.pop();
          //   }
          //   // Exit the app
          // }
        }
        //log('BackButton pressed! Navigating to login screen.');
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
                      height: widget.screen == menu
                          ? MediaQuery.of(context).size.height / 1.3
                          : MediaQuery.of(context).size.height / 1.3,
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
                usrNm.isEmpty
                    ? Positioned(
                        top: widget.screen == menu
                            ? MediaQuery.of(context).size.height * .14
                            : MediaQuery.of(context).size.height * .14,
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: MediaQuery.of(context).size.width * 0.19,
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //SizedBox(width: 10),
                            Text(
                              "PomPomPay"
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
                      )
                    : Positioned(
                        top: widget.screen == menu
                            ? MediaQuery.of(context).size.height * .14
                            : MediaQuery.of(context).size.height * .14,
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: MediaQuery.of(context).size.width * 0.19,
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //SizedBox(width: 10),
                            Text(
                              usrNm
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
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.onPrimary, // Circle color
                    child: IconButton(
                      icon: Icon(
                        Icons.person_2_rounded,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary, // Icon color
                        size: 30,
                      ),
                      onPressed: () {
                        // Navigator.pushReplacement(context, Approutes().screenprofile);
                      },
                    ),
                  ),
                ),
                usrNm.isEmpty
                    ? Container()
                    : Positioned(
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: widget.screen == menu
                        ? MediaQuery.of(context).size.height / 1.42
                        : MediaQuery.of(context).size.height / 1.65,
                    //padding: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: ListView(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: ListTile(
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
                            onTap: () {
                              Navigator.push(
                                context,
                                Approutes().privacyScreen,
                              );
                            },
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: ListTile(
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
                            onTap: () {
                              Navigator.push(context, Approutes().aboutScreen);
                            },
                          ),
                        ),
                        usrNm.isEmpty
                            ? Container()
                            : Material(
                                color: Colors.transparent,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.power_settings_new,
                                    size: 25,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
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
                              ),
                        usrNm.isEmpty
                            ? Container()
                            : Material(
                                color: Colors.transparent,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.remove_circle_outline_outlined,
                                    size: 25,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    //color: Appcolors.labelclr,
                                  ),
                                  title: Text(
                                    "Remove account",
                                    style: TextStyle(
                                      fontFamily: 'Poppins-Medium',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red,
                                    ),
                                    textScaler: TextScaler.noScaling,
                                  ),
                                  onTap: () {
                                    deleteWarning(context);
                                  },
                                ),
                              ),
                        usrNm.isEmpty
                            ? Material(
                                color: Colors.transparent,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.login_outlined,
                                    size: 25,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    //color: Appcolors.labelclr,
                                  ),
                                  title: Text(
                                    "Login",
                                    style: TextStyle(
                                      fontFamily: 'Poppins-Medium',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    textScaler: TextScaler.noScaling,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      Approutes().loginscreen,
                                    );
                                  },
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),

                widget.screen == menu
                    ? Positioned(
                        top: 40,
                        left: 10,
                        right: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Builder(
                              builder: (context) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
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
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> deleteWarning(BuildContext originalContext) async {
    if (!originalContext.mounted) return;

    showDialog(
      context: originalContext,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Center(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.amber,
                          size: 40,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Do you Want to Delete your account?",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "⚠️ Caution: Once you delete your account, you can't recover it.",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 2,
                                backgroundColor: const Color(0xffffa600),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },

                              child: Text(
                                "Cancel",
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 2,
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                await UserFun.instance.deleteuser(context);
                                if (!context.mounted) return;
                              },
                              child: Text(
                                "Delete",
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future warningBox(BuildContext context) async => showDialog<bool>(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Center(
        child: Text(
          "Sign Out?",
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: 18.sp,
            color: Colors.black,
          ),
        ),
      ),
      content: Text(
        "Are you sure you want to Sign Out?",
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontSize: 18.sp, color: Colors.black),
      ),

      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () => Navigator.pop(context),
          child: Text('NO', style: Theme.of(context).textTheme.displayMedium),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            signout(context);
          },
          child: Text('YES', style: Theme.of(context).textTheme.displayMedium),
        ),
      ],
    ),
  );

  void signout(BuildContext context) async {
    final sharedprf = await SharedPreferences.getInstance();
    // await sharedprf.remove(savekeyname);
    // await sharedprf.clear();
    const secureStorage = FlutterSecureStorage();

    // Remove only the login-related keys
    await sharedprf.remove('NAME');
    await sharedprf.remove('MOBNO');
    await sharedprf.remove('savekeyname');

    // Remove secure storage keys
    await secureStorage.delete(key: 'USERID');
    await secureStorage.delete(key: 'ACCESSTOKEN');
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx) => const ScreenMainpage()),
      (Route<dynamic> route) => false,
    );
  }
}
