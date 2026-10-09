import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:root_checker_plus/root_checker_plus.dart';

class SecurityCheck {
  static Future<String?> getCompromisedReason() async {
    if (Platform.isAndroid) {
      bool rooted = await RootCheckerPlus.isRootChecker() ?? false;
      if (rooted) return "Your device is rooted.The app cannot run.";

      bool devMode = await RootCheckerPlus.isDeveloperMode() ?? false;
      if (devMode) return "Developer mode is enabled.The app cannot run.";
    } else if (Platform.isIOS) {
      bool jailbroken = await RootCheckerPlus.isJailbreak() ?? false;
      if (jailbroken) return "Your device is jailbroken.The app cannot run.";
    }
    return null; // safe device
  }

  static Future<void> checkAndExitIfCompromised(BuildContext context) async {
    String? reason = await getCompromisedReason();
    if (!context.mounted) return;

    if (reason != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PopScope(
            canPop: false,
            child: Center(
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

                    children: [
                      const Text(
                        "Security Warning",
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        reason,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 2,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          SystemNavigator.pop();
                        },
                        child: Text(
                          'Exit',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
