import 'package:pompompay/core/hook/hooks.dart';

ValueNotifier<int> selectindexNotifier = ValueNotifier(0);

class BottomNavigationWidget extends StatelessWidget {
  final String login;
  const BottomNavigationWidget({super.key, required this.login});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectindexNotifier,
      builder: (context, int newindex, _) {
        final items = login.isEmpty
            ? [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.person_2_outlined),
                  label: 'Profile',
                ),
              ]
            : [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: 'History',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.person_2_outlined),
                  label: 'Profile',
                ),
              ];

        final safeIndex = newindex < items.length ? newindex : 0;

        return BottomNavigationBar(
          currentIndex: safeIndex,
          onTap: (index) {
            selectindexNotifier.value = index;
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.black,
          items: items,
        );
      },
    );
  }
}
