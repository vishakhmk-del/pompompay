import 'package:pompompay/core/hook/hooks.dart';

class CommonFun {
  CommonFun._internal();
  static CommonFun instance = CommonFun._internal();
  CommonFun factory() {
    return instance;
  }

  Future signout(BuildContext context) async {
    Fluttertoast.showToast(
      msg: "Session Expired.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    final sharedprf = await SharedPreferences.getInstance();

    await sharedprf.remove(savekeyname);
    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx) => const Screenlogin()),
      (Route<dynamic> route) => false,
    );
  }

  Future showApierror(BuildContext? context, String? msg) async {
    //print('hi');

    Fluttertoast.showToast(
      msg: "$msg",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 15.0,
    );
  }
}
