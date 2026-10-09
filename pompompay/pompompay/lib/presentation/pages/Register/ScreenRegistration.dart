import 'dart:developer';
import 'package:pompompay/core/hook/hooks.dart';

class ScreenRegister extends StatefulWidget {
  const ScreenRegister({super.key});

  @override
  State<ScreenRegister> createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  final _passcontroller = TextEditingController();
  final _cnfrmpswrdcontroller = TextEditingController();
  final _namecontroller = TextEditingController();
  final _mobcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool passtoggle = true;
  final _simNumberPickerPlugin = SimNumberPicker();

  @override
  void initState() {
    super.initState();

    getPhoneNumbers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loadingProvider = context.read<LoadingProvider>();
      loadingProvider.resetAll();
    });
  }

  // Future<void> getPhoneNumbers() async {
  //   String phoneNumber;
  //   try {
  //     phoneNumber = await _simNumberPickerPlugin.getPhoneNumberHint() ?? '';
  //     log(phoneNumber);
  //     setState(() {
  //       phoneNumber = phoneNumber.replaceFirst(RegExp(r'^\+\d{1,2}'), '');
  //     });

  //     log('Phone Number Without Country Code: $phoneNumber');
  //   } on PlatformException {
  //     final phNumber = 'Failed to get platform version.';
  //     log(phNumber);
  //     phoneNumber = '';
  //   }
  //   if (!mounted) return;

  //   setState(() {
  //     _mobcontroller.text = phoneNumber;
  //   });
  // }
  Future<void> getPhoneNumbers() async {
    try {
      String? number = await _simNumberPickerPlugin.getPhoneNumberHint();
      log('Raw Phone Number: $number');

      if (!mounted) return;

      // if (number != null && number.isNotEmpty) {
      //   final formattedNumber = number.replaceFirst(RegExp(r'^\+\d{1,2}'), '');
      //   log('Formatted Number: $formattedNumber');

      //   // No need to wrap this again in addPostFrameCallback
      //   setState(() {
      //     _mobcontroller.text = formattedNumber;
      //   });
      // }
      if (number != null && number.isNotEmpty) {
        final formattedNumber = number.replaceFirst(RegExp(r'^\+\d{1,2}'), '');
        log('Formatted Number: $formattedNumber');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _mobcontroller.text = formattedNumber;
        });
      }
    } on PlatformException {
      log('Failed to get platform version.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.primary,
          ],
        ),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.65, // 70% of screen height initially
        minChildSize: 0.3, // Min height when collapsed
        maxChildSize: 1.0, // Max height when fully expanded
        expand: false, // Allows dragging to control height
        builder: (context, scrollController) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: GestureDetector(
              onTap: () =>
                  FocusScope.of(context).unfocus(), // Dismiss keyboard on tap
              child: Padding(
                padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 15,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: NotificationListener<ScrollEndNotification>(
                  onNotification: (_) {
                    // Prevent setState during layout
                    WidgetsBinding.instance.addPostFrameCallback((_) {});
                    return false;
                  },
                  child: SingleChildScrollView(
                    controller: scrollController,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Form(
                      key: _formkey,
                      child: Theme(
                        data: MyTheme.googleFormTheme,
                        child: Column(
                          children: [
                            Text(
                              'REGISTRATION',
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(fontSize: 24),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 0.0,
                                  horizontal: 5,
                                ),
                                child: TextFormField(
                                  cursorColor: Colors.white,
                                  controller: _namecontroller,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Name',
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(fontSize: 14),
                                    prefixIcon: Theme(
                                      data: MyTheme.appIconTheme,
                                      child: const Icon(
                                        Icons.account_box_rounded,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter valid Name";
                                    } else if (value.contains('.') ||
                                        value.contains("-") ||
                                        value.contains(",")) {
                                      return "Enter valid Name";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 0.0,
                                  horizontal: 5,
                                ),
                                child: TextFormField(
                                  onTap: () async {
                                    //  final simdet = await Siminfo.getPhoneNumber();
                                    // log("moblist:$simdet");
                                  },
                                  cursorColor: Colors.white,
                                  controller: _mobcontroller,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                                  // style:kBodyText,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter mobile Number";
                                    } else if (_mobcontroller.text.length <
                                            10 ||
                                        _mobcontroller.text.length > 10) {
                                      return "Enter valid Mobile number";
                                    } else if (value.contains(' ')) {
                                      Fluttertoast.showToast(
                                        msg: "Remove Space from  Mobile number",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.white,
                                        textColor: Colors.black,
                                        fontSize: 15.0,
                                      );
                                    }

                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                        horizontal: 15,
                                      ),
                                      child: Text(
                                        " (+91)",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(fontSize: 14),
                                      ),
                                    ),
                                    labelText: 'Mobile Number',
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(fontSize: 14),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 5,
                                ),
                                child: TextFormField(
                                  cursorColor: Colors.white,
                                  controller: _passcontroller,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(fontSize: 14),
                                    prefixIcon: Theme(
                                      data: MyTheme.appIconTheme,
                                      child: const Icon(Icons.lock),
                                    ),
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        setState(() {
                                          passtoggle = !passtoggle;
                                        });
                                      },
                                      child: Theme(
                                        data: MyTheme.appIconTheme,
                                        child: Icon(
                                          passtoggle
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                      ),
                                    ),
                                  ),
                                  obscureText: passtoggle,
                                  textInputAction: TextInputAction.done,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a password';
                                    } else if (value.contains(' ')) {
                                      return 'Password must not contain spaces';
                                    } else if (value.length < 8) {
                                      return 'Password must be at least 8 characters';
                                    } else if (!RegExp(
                                      r'[A-Z]',
                                    ).hasMatch(value)) {
                                      return 'Password must contain at least one uppercase letter';
                                    } else if (!RegExp(
                                      r'[!@#$%^&*(),.?":{}|<>]',
                                    ).hasMatch(value)) {
                                      return 'Password must contain at least one special character';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 5,
                                ),
                                child: TextFormField(
                                  cursorColor: Colors.white,
                                  controller: _cnfrmpswrdcontroller,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Confirm Password',
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(fontSize: 14),
                                    prefixIcon: Theme(
                                      data: MyTheme.appIconTheme,
                                      child: const Icon(Icons.lock),
                                    ),
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        setState(() {
                                          passtoggle = !passtoggle;
                                        });
                                      },
                                      child: Theme(
                                        data: MyTheme.appIconTheme,
                                        child: Icon(
                                          passtoggle
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                      ),
                                    ),
                                  ),
                                  obscureText: passtoggle,
                                  textInputAction: TextInputAction.done,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please confirm your password';
                                    } else if (value != _passcontroller.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Container(
                              height: 50,
                              width: 300,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    // Color.fromARGB(255, 198, 120, 3),
                                    // Color.fromARGB(255, 198, 120, 3),
                                    Color(0xffffa600),
                                    Color(0xffffa600),
                                    // Color.fromARGB(255, 198, 130, 6),
                                    // Color.fromARGB(255, 198, 131, 6),
                                  ],
                                ),
                                //borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Theme(
                                data: MyTheme.buttonStyleTheme,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formkey.currentState!.validate()) {
                                      final regReq = UserCmnReq(
                                        userName: _namecontroller.text,
                                        mobno: _mobcontroller.text,
                                        pw: _passcontroller.text,
                                      );
                                      UserFun.instance.registerFn(
                                        regReq,
                                        context,
                                      );
                                    }
                                  },
                                  child: Text(
                                    'SIGNUP',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontSize: 20),
                                  ),
                                ),
                              ),
                            ),

                            Consumer<LoadingProvider>(
                              builder: (context, loadingProvider, child) {
                                return loadingProvider.isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Color.fromARGB(255, 2, 128, 6),
                                              ),
                                        ),
                                      )
                                    : const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
