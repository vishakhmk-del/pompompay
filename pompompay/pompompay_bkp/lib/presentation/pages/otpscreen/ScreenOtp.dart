import 'package:pompompay/core/hook/hooks.dart';

class ScreenOtp extends StatefulWidget {
  const ScreenOtp({super.key, this.mobileno});
  final String? mobileno;

  @override
  State<ScreenOtp> createState() => _ScreenOtpState();
}

class _ScreenOtpState extends State<ScreenOtp> {
  int _backPressCount = 0;
  Timer? _resetTimer;

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    _backPressCount++;

    if (_backPressCount >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You must verify your mobile number with OTP; otherwise, your registration is not complete.',
          ),
          duration: Duration(seconds: 2),
        ),
      );
      _backPressCount = 0; // Reset the count
    }

    // Reset counter after 2 seconds if no further back press
    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(seconds: 2), () {
      _backPressCount = 0;
    });

    return false; // Prevent screen from being popped
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevents back navigation
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (!didPop) {
          await _onWillPop();
        }
      },
      child: Stack(
        children: [
          BackgroundColorGradient(),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centers vertically
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Centers horizontally
                children: [OtpFiled(type: regType, mob: widget.mobileno)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
