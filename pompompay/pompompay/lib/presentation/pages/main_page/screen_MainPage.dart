import 'package:pompompay/core/hook/hooks.dart';
import 'package:pompompay/presentation/pages/profile/screenprofile.dart';

class ScreenMainpage extends StatelessWidget {
  ScreenMainpage({super.key});

  final pages = [ScreenHome(), ScreenBusRoute(), ScreenProfile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectindexNotifier,
          builder: (context, int newindex, _) {
            return pages[newindex];
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(),
    );
  }
}
