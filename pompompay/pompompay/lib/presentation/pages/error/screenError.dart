import 'package:pompompay/core/hook/hooks.dart';

class ScreenError extends StatefulWidget {
  const ScreenError({super.key, this.message});
  final String? message;

  @override
  State<ScreenError> createState() => _ScreenErrorState();
}

class _ScreenErrorState extends State<ScreenError> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String? version;
  String? buildnumber;
  @override
  void initState() {
    super.initState();
    verisoninfo();
  }

  void verisoninfo() async {
    final value = await SharedPrefManager.instance.getdeviceinfo();
    setState(() {
      version = value.appversion;
      buildnumber = value.buildnumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: _scaffoldKey,
      children: [
        // const Backgroundsplash(),
        Scaffold(
          backgroundColor: const Color(0xff98c1d9),
          body: SafeArea(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(
                        "assets/errror/alekseyvanin200701168.jpg",
                      ),
                    ),
                    //Text("Loading")
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE1E1E1),
                      width: 2,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage(
                      'assets/errror/cima_app_logo.jpg',
                    ),
                  ),
                ),

                Text(
                  "Buildnumber : $buildnumber",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  "Version : $version",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "${widget.message}",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color.fromARGB(255, 220, 29, 16),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
