import 'dart:developer';

import 'package:pompompay/core/hook/hooks.dart';

import 'package:sizer/sizer.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with TickerProviderStateMixin {
  String scannedData = "";
  late AnimationController _lineController;
  late Animation<double> _lineAnimation;
  bool hasPermission = false;
  final MobileScannerController cameraController = MobileScannerController(
    autoZoom: true,
  );
  @override
  void initState() {
    super.initState();
    requestCameraPermission();
    _lineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // loops back and forth

    _lineAnimation = Tween<double>(begin: -125, end: 125).animate(
      CurvedAnimation(parent: _lineController, curve: Curves.easeInOut),
    );
    //cameraController.setZoomScale(0.5);
  }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() {
        hasPermission = true;
      });
    } else {
      openAppSettings(); // Optionally open app settings
    }
  }

  Future<bool?> popscreen(BuildContext context) async {
    // BankAccountFun.instance.getbnkLstNotifier.value = [];
    Navigator.pushReplacement(context, Approutes().homescreen);
    return true;
  }

  @override
  void dispose() {
    _lineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          log('Screen was popped with result: $result');
          return;
        }
        //log('BackButton pressed! Navigating to login screen.');
        await popscreen(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          //toolbarHeight: 80,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () async {
              Navigator.pushReplacement(context, Approutes().homescreen);
            },
          ),
          title: Text(
            'Scan And Pay',
            style: TextStyle(
              fontFamily: 'Poppins-Medium',
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            textScaler: TextScaler.noScaling,
          ),
        ),

        body:
            hasPermission
                ? Stack(
                  children: [
                    MobileScanner(
                      controller: cameraController,
                      onDetect: (BarcodeCapture capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          final String? code = barcode.rawValue;
                          if (code != null) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder:
                                    (context) => ScreenScanPay(busid: code),
                              ),
                            );

                            // setState(() {
                            //   scannedData = code;
                            // });
                            cameraController.stop();
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(content: Text('Scanned: $code')),
                            // );
                            break;
                          }
                        }
                      },
                    ),

                    // Scan box overlay in center
                    Center(
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.redAccent, width: 3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Center(
                      child: AnimatedBuilder(
                        animation: _lineAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _lineAnimation.value),
                            child: Container(
                              width: 220,
                              height: 2,
                              color: Colors.redAccent,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
                : FutureBuilder(
                  future: Future.delayed(
                    const Duration(seconds: 10),
                  ), // Add a delay of 5 seconds
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height / 2.5,
                            horizontal: MediaQuery.of(context).size.width / 2.3,
                          ),
                          child: const CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height / 2.5,
                            horizontal: MediaQuery.of(context).size.width / 2.7,
                          ),
                          child: Text(
                            'Camera permission is required to scan QR codes.\n Please allow access from settings.',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
      ),
    );
  }
}
