import 'package:pompompay/core/hook/hooks.dart';

class ThemeProvider with ChangeNotifier {
  late ThemeMode _themeMode = ThemeMode.system;
  late ThemeData _darkScheme = MyTheme.darkTheme;
  late ThemeData _lightScheme = MyTheme.lightTheme;
  ThemeMode get themeMode => _themeMode;
  void setThemeMode(ThemeMode value) {
    _themeMode = value;
    notifyListeners();
  }

  ThemeData get darkScheme => _darkScheme;
  void setDarkScheme(ThemeData value) {
    _darkScheme = value;
    notifyListeners();
  }

  ThemeData get lightScheme => _lightScheme;
  void setLightScheme(ThemeData value) {
    _lightScheme = value;
    notifyListeners();
  }
}
