import 'package:pompompay/core/hook/hooks.dart';

class ScreenBusRoute extends StatefulWidget {
  const ScreenBusRoute({super.key});

  @override
  State<ScreenBusRoute> createState() => _ScreenBusRouteState();
}

class _ScreenBusRouteState extends State<ScreenBusRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Bus Route")));
  }
}
