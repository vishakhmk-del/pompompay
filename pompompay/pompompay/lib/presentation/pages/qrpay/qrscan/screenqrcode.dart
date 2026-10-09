import 'dart:convert';
import 'dart:developer';

import 'package:pompompay/core/hook/hooks.dart';
import 'package:pompompay/infrastructure/model/fare/qr_conductor_tkt/qr_conductor_tkt.dart';
import 'package:pompompay/presentation/pages/qrpay/encrypt_class/decryptclass.dart';

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
  bool _isProcessingQR = false;
  final MobileScannerController cameraController = MobileScannerController(
    autoZoom: true,
  );
  @override
  void initState() {
    super.initState();
    _showPermissionInfo();
    _lineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // loops back and forth

    _lineAnimation = Tween<double>(begin: -125, end: 125).animate(
      CurvedAnimation(parent: _lineController, curve: Curves.easeInOut),
    );
  }

  void _showPermissionInfo() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Camera Access",
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          content: Text(
            "We need camera access to scan QR codes.",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                requestCameraPermission();
              },
              child: Text(
                "Continue",
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();

    if (!mounted) return;

    if (status.isGranted) {
      setState(() {
        hasPermission = true;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Permission Required"),
          content: const Text(
            "Camera permission is required to scan QR codes. You can enable it anytime from Settings.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                openAppSettings();
              },
              child: const Text("Open Settings"),
            ),
          ],
        ),
      );
    }
  }

  Future<bool?> popscreen(BuildContext context) async {
    // BankAccountFun.instance.getbnkLstNotifier.value = [];
    Navigator.pushReplacement(context, Approutes().mainScreen);
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
              Navigator.pushReplacement(context, Approutes().mainScreen);
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

        body: hasPermission
            ? Stack(
                children: [
                  MobileScanner(
                    controller: cameraController,
                    onDetect: (BarcodeCapture capture) async {
                        if (_isProcessingQR) return;

                        for (final barcode in capture.barcodes) {
                          final String? code = barcode.rawValue;

                          if (code == null || code.trim().isEmpty) {
                            continue;
                          }

                          _isProcessingQR = true;

                          await cameraController.stop();

                          try {
                            // ============================================================
                            // 1. ENCRYPTED QR
                            // ============================================================

                            final String encryptedData = code.trim();

                            log('Encrypted QR: $encryptedData');

                            // ============================================================
                            // 2. DECRYPT
                            // ============================================================

                            final String decryptedData =
                                await QRCrypto.instance.decrypt(encryptedData);

                            final String data = decryptedData.trim();

                            log('Decrypted QR: $data');

                            if (!context.mounted) return;

                            // ============================================================
                            // 3. TRY CONDUCTOR JSON
                            // ============================================================

                            try {
                              final dynamic decoded = jsonDecode(data);

                              if (decoded is Map<String, dynamic> &&
                                  decoded['type'] == 'CONDUCTOR_TICKET') {
                                
                                log('CONDUCTOR QR');

                                final QrConductorTkt conductorTicket =
                                    QrConductorTkt.fromJson(decoded);

                                log(
                                  'Bus ID: ${conductorTicket.data?.busId ?? ''}',
                                );

                                log(
                                  'Trip ID: ${conductorTicket.data?.tripId ?? ''}',
                                );

                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => ScreenScanPay(
                                      conductorType: conductorTicket,
                                    ),
                                  ),
                                );

                                return;
                              }
                            } catch (e) {
                              log('Not conductor JSON, treating as normal bus QR');
                            }

                            // ============================================================
                            // 4. NORMAL BUS QR
                            // ============================================================

                            log('NORMAL BUS QR');
                            log('Bus ID: $data');

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => ScreenScanPay(
                                  busid: data,
                                ),
                              ),
                            );

                            return;

                          } catch (e, stackTrace) {
                            log('QR processing error: $e');
                            log('$stackTrace');

                            _isProcessingQR = false;

                            if (!context.mounted) return;

                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Invalid QR Code'),
                                  content: const Text(
                                    'This QR code is invalid or cannot be processed.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (mounted && hasPermission) {
                              await cameraController.start();
                            }
                          }

                          break;
                        }
                      },
                    // onDetect: (BarcodeCapture capture) {
                    //   final List<Barcode> barcodes = capture.barcodes;
                    //   for (final barcode in barcodes) {
                    //     final String? code = barcode.rawValue;
                    //     if (code != null) {
                    //       Navigator.of(context).pushReplacement(
                    //         MaterialPageRoute(
                    //           builder: (context) => ScreenScanPay(busid: code),
                    //           ),
                    //           );
                    // setState(() {
                    //// scannedData = code;
                    ///// });
                    ///cameraController.stop();
                    /// // ScaffoldMessenger.of(context).showSnackBar(
                    /// // SnackBar(content: Text('Scanned: $code')),
                    /// // ); break; } } },
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
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Camera permission is required to scan QR.\nPlease allow access from settings.',
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: 14,
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
