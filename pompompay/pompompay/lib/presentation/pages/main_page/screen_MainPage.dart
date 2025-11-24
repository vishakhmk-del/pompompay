import 'dart:io';

import 'package:pompompay/core/hook/hooks.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
// final ValueNotifier<int> selectindexNotifier = ValueNotifier(0);

class ScreenMainpage extends StatefulWidget {
 const ScreenMainpage({super.key,this.version});
 final UserCmnResp? version;
  @override
  State<ScreenMainpage> createState() => _ScreenMainpageState();
}

class _ScreenMainpageState extends State<ScreenMainpage> {
  final pages = [
    ScreenHome(),
    ScreenTransaction(),
    ScreenMenu(screen: profile),
  ];
  @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (widget.version != null) {
      checkupdate();
    }
  });
}
void checkupdate(){
 if(widget.version?.errorCode=="VERSION_UPDATE"){
  versionWarning(context);
 }
}
  Future<bool?> showWarning(BuildContext context) async => showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              "Exit App?",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 18.sp,
                    color: Colors.black,
                  ),
            ),
          ),
          content: Text(
            "Are you sure you want to exit?",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 18.sp,
                  color: Colors.black,
                ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'NO',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                'YES',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // disables default pop behavior
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final currentIndex = selectindexNotifier.value;

        if (currentIndex != 0) {
          // If not on Home, go to Home tab instead of exiting
          selectindexNotifier.value = 0;
        } else {
          // If on Home, ask for exit confirmation
          final shouldExit = await showWarning(context);
          if (shouldExit == true) {
            // ignore: use_build_context_synchronously
            SystemNavigator.pop(); // Exit app
          }
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: ValueListenableBuilder(
          valueListenable: selectindexNotifier,
          builder: (context, int newindex, _) {
            return pages[newindex];
          },
        ),
        bottomNavigationBar: BottomNavigationWidget(),
      ),
    );
  }
Future<void> versionWarning(BuildContext originalContext) async {
    if (!originalContext.mounted) return;

    showDialog(
      context: originalContext,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Center(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                          const Icon(
                              Icons.update_outlined,
                              color: Colors.amber,
                              size: 35,
                            ),
                        const SizedBox(width: 8),
                        Text(
                          "Update Available",
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${widget.version?.message}",
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                       widget.version?.mandatory == false
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 2,
                                  backgroundColor: const Color(0xffffa600),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    Approutes().mainScreen,
                                  );
                                },
                                child: Text(
                                  "Skip",
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 2,
                                  backgroundColor: const Color(0xffffa600),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () async {
                                  _openStore();
                                },
                                child: Text(
                                  "Update Now",
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 2,
                                backgroundColor: const Color(0xffffa600),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                _openStore();
                              },
                              child: Text(
                                "Update Now",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),

                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
  static Future<void> _openStore() async {
  final Uri androidUrl = Uri.parse(
      "https://play.google.com/store/apps/details?id=your.package");

  final Uri iosUrl = Uri.parse(
      "https://apps.apple.com/app/idXXXXXXXXX");

  if (Platform.isAndroid) {
    if (await canLaunchUrl(androidUrl)) {
      await launchUrl(androidUrl, mode: LaunchMode.externalApplication);
    }
  } else if (Platform.isIOS) {
    if (await canLaunchUrl(iosUrl)) {
      await launchUrl(iosUrl, mode: LaunchMode.externalApplication);
    }
  }
}
}

// class ScreenMainpage extends StatelessWidget {
//   ScreenMainpage({super.key});

//   final pages = [
//     ScreenHome(),
//     ScreenTransaction(),
//     ScreenMenu(screen: profile),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.primary,
//       body: ValueListenableBuilder(
//         valueListenable: selectindexNotifier,
//         builder: (context, int newindex, _) {
//           return pages[newindex];
//         },
//       ),
//       bottomNavigationBar: BottomNavigationWidget(),
//     );
//   }
// }
