import 'package:pompompay/core/hook/hooks.dart';

ValueNotifier<int> selectindexNotifier = ValueNotifier(0);

class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectindexNotifier,
      builder: (context, int newindex, _) {
        return BottomNavigationBar(
          currentIndex: newindex,
          onTap: (index) {
            selectindexNotifier.value = index;
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.black,
          selectedIconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.primary,
          ),
          unselectedIconTheme: IconThemeData(color: Colors.black),

          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.route_outlined),
              label: 'Bus Route',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: 'Account',
            ),
          ],
        );
      },
    );
  }
}
