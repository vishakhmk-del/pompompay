import 'package:pompompay/core/hook/hooks.dart';

class TimerController extends GetxController {
  Timer? _timer;
  int remainingsec = 1;
  final time = '00:0-'.obs;

  @override
  void onReady() {
    _startTimer(180);
    super.onReady();
  }

  @override
  void onClose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.onClose();
  }

  _startTimer(int seconds) {
    const duration = Duration(seconds: 1);
    remainingsec = seconds;
    _timer = Timer.periodic(duration, (Timer timer) {
      if (remainingsec == 0) {
        timer.cancel();
      } else {
        int minutes = remainingsec ~/ 60;
        int seconds = (remainingsec % 60);
        time.value =
            "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
        remainingsec--;
      }
    });
  }
}
