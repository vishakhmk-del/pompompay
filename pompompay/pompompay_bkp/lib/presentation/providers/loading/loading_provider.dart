import 'package:pompompay/core/hook/hooks.dart';

class LoadingProvider with ChangeNotifier {
  bool isloading = false;


  bool get isLoading => isloading;


  void show() {
    isloading = true;
    notifyListeners();
  }



  void resetAll() {
    isloading = false;
    notifyListeners();
  }

 
}
