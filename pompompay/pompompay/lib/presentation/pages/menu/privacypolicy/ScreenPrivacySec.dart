import 'package:pompompay/core/hook/hooks.dart';

class ScreenPrivacySec extends StatefulWidget {
  const ScreenPrivacySec({super.key});

  @override
  State<ScreenPrivacySec> createState() => _ScreenPrivacySecState();
}

class _ScreenPrivacySecState extends State<ScreenPrivacySec> {
  late WebViewController webController;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    setupWebView();
  }

  void setupWebView() {
    late final PlatformWebViewControllerCreationParams params;

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final controller = WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            setState(() => isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse('http://pompay.in:8005/privacy_policy.html'));

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    webController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          centerTitle: true,
          title: const Text(
            "Privacy and Security",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: webController),

          /// Loading Indicator
          if (isLoading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  strokeWidth: 4.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_android/webview_flutter_android.dart';
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

// class Screenprivacysec extends StatefulWidget {
//   const Screenprivacysec({super.key});

//   @override
//   State<Screenprivacysec> createState() => _ScreenprivacysecState();
// }

// class _ScreenprivacysecState extends State<Screenprivacysec> {
//   WebViewController tandccontroller = WebViewController();
//   Locale? localecode;
//   Future<void> webViewFuture = Future.delayed(const Duration(seconds: 3));
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {

//       buildwebloading();
//     });

//     super.initState();
//   }

//   void buildwebloading() {

//       // #docregion platform_features
//       late final PlatformWebViewControllerCreationParams params;
//       if (WebViewPlatform.instance is WebKitWebViewPlatform) {
//         params = WebKitWebViewControllerCreationParams(
//           allowsInlineMediaPlayback: true,
//           mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
//         );
//       } else {
//         params = const PlatformWebViewControllerCreationParams();
//       }

//       final WebViewController tccontroller =
//           WebViewController.fromPlatformCreationParams(params);
//       // #enddocregion platform_features
//       tccontroller
//         ..setJavaScriptMode(JavaScriptMode.unrestricted)
//         ..loadRequest(Uri.parse(
//             'https://kannurlabourbank.com:549/thozhil-admin/public/privacy_policy'));

//       // #docregion platform_features
//       if (tccontroller.platform is AndroidWebViewController) {
//         AndroidWebViewController.enableDebugging(true);
//         (tccontroller.platform as AndroidWebViewController)
//             .setMediaPlaybackRequiresUserGesture(false);
//       }
//       // #enddocregion platform_features

//       tandccontroller = tccontroller;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Theme.of(context).colorScheme.onPrimary,
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(70),
//         child: AppBar(
//           leading: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0),
//             child: IconButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 icon: const Icon(
//                   Icons.arrow_back,
//                   color: Colors.white,
//                 )),
//           ),
//           centerTitle: true,
//           title: Column(
//             children: [
//               Text(
//                 "Privacy and Security",
//                 style: TextStyle(color: Colors.white),
//               ),
//             ],
//           ),
//           backgroundColor: Theme.of(context).colorScheme.primary,

//         ),
//       ),
//       extendBodyBehindAppBar: true,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(
//             top: 10,
//           ),
//           child: FutureBuilder(
//             future: webViewFuture,
//             builder: ((context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return  Center(
//                   child: CircularProgressIndicator(
//                     color: Theme.of(context).colorScheme.primary,
//                     backgroundColor: Colors.white,
//                     strokeWidth: 4.0,
//                   ),
//                 );
//               } else {
//                 return WebViewWidget(
//                   controller: tandccontroller,
//                 );
//               }
//             }),
//           ),
//         ),
//       ),
//     );
//   }
// }
