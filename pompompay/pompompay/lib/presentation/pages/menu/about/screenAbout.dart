import 'package:pompompay/core/hook/hooks.dart';
import 'package:pompompay/presentation/widgets/backgroundImage/backgroundimage.dart';

class ScreenAbout extends StatefulWidget {
  const ScreenAbout({super.key});

  @override
  State<ScreenAbout> createState() => _ScreenAboutState();
}

class _ScreenAboutState extends State<ScreenAbout> {
  String? buildnumber;
  String? version;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    appdet();
  }

  void appdet() async {
    final val = await SharedPrefManager.instance.getdeviceinfo();
    if (!mounted) return;

    setState(() {
      buildnumber = val.buildnumber;
      version = val.appversion;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("About", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      //backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Stack(
        children: [
          const BackgroundImage(),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "About the application",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Poppins-Medium',
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black54),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          "assets/image/applogo/pompompay.png",
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "PomPomPay",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Build number: $buildnumber",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      Text(
                        "Version: $version",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Developed by:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Dinesh Information Technology Systems\n(a Unit of KDBWCCS Ltd)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'Poppins-Medium',
                        ),
                      ),

                      const SizedBox(height: 20),

                      Image.asset(
                        "assets/image/login/logo_dits.png",
                        height: 60,
                      ),

                      const SizedBox(height: 15),
                      const Text(
                        "www.dineshsoftware.com",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.black,
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'Poppins-Medium',
                        ),
                      ),

                      const SizedBox(height: 15),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
