

import 'package:pompompay/core/hook/hooks.dart';
import 'package:sizer/sizer.dart';

const savekeyname = 'UserLoggedIn';
const savedeviceinfo = '_userDeviceIn';
const savedevicetkn = '_userDeviceTkn';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PaymentGatewayPlugin.init();
//  startForegroundService();
  runApp(const MyApp());
}
// void startForegroundService() async {
//   ForegroundService().start();
//   debugPrint("Started service");
// }
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider<LoadingProvider>(
        create: (context) => LoadingProvider(),
      ),
      ChangeNotifierProvider<ElevatedBtnProvider>(
        create: (context) => ElevatedBtnProvider(),
      ),
      ChangeNotifierProvider<ThemeProvider>(
        create: (context) => ThemeProvider(),
        builder: (context, child) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.noScaling),
            child: Sizer(
              builder: (context, orientation, screenType) {
                return MaterialApp(
                  // navigatorKey: navigatorKey,
                  title: 'Pompay',
                  themeMode: themeProvider.themeMode,
                  theme: themeProvider.lightScheme,
                  darkTheme: themeProvider.darkScheme,
                  home: const ScreenSplash(),
                );
              },
            ),
          );
        },
      ),
    ],
  );
}
