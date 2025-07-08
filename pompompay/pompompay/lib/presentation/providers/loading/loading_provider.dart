import 'package:pompompay/core/hook/hooks.dart';

class LoadingProvider with ChangeNotifier {
  bool isloading = false;
  String? _errorMessage;
  //List<DatumVal> accountlist = [];
  bool primaryAccountStatus = false;

  bool get isLoading => isloading;
  //List<DatumVal> get accountList => accountlist;
  String? get errorMessage => _errorMessage;
  bool get primaryaccountStatus => primaryAccountStatus;

  void toggleLoading() {
    isloading = !isloading;
    notifyListeners();
  }

  void setError(String error) {
    _errorMessage = error;
    isloading = false;
    notifyListeners();
  }

  void resetAll() {
    // accountlist = [];
    _errorMessage = null;
    isloading = false;
    notifyListeners();
  }

  void setPrimaryAccount(bool value) {
    primaryAccountStatus = value;
    notifyListeners();
  }
}
