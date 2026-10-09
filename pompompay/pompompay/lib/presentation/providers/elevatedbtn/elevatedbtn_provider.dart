import 'package:pompompay/core/hook/hooks.dart';

class ElevatedBtnProvider with ChangeNotifier {
  bool _selectedVal = false;
  bool _rstPswrd = false;

  bool get selectedVal => _selectedVal;
  bool get resetPswrd => _rstPswrd;

  void changeSelectedVal(bool value) {
    _selectedVal = value;
    notifyListeners();
  }

  void resetPasswrd(bool value) {
    _rstPswrd = value;
    notifyListeners();
  }
}
