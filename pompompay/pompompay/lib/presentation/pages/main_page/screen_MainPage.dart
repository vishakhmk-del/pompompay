import 'package:pompompay/core/hook/hooks.dart';

class ScreenMainpage extends StatelessWidget {
  ScreenMainpage({super.key});

  final pages = [
    ScreenHome(),
    ScreenTransaction(),
    ScreenMenu(screen: profile),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: ValueListenableBuilder(
        valueListenable: selectindexNotifier,
        builder: (context, int newindex, _) {
          return pages[newindex];
        },
      ),
      bottomNavigationBar: BottomNavigationWidget(),
    );
  }
}
