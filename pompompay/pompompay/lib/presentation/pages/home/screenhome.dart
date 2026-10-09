import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:pompompay/core/hook/hooks.dart';
// import 'package:pompompay/core/security/security_check.dart';
import 'package:sizer/sizer.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  String locationMessage = 'Current Location of the User';
  Timer? locationTimer;
  double doublelat = 0;
  double doublelong = 0;
  String? usrNm;
  TextEditingController fromcontroller = TextEditingController();
  TextEditingController tocontroller = TextEditingController();
  List<Datum>? cpayMoblst;
  List<Datum>? filteredFromPlace = [];
  List<Datum>? filteredToPlace = [];
  bool showFromDropdown = false;
  bool showToDropdown = false;
  TextEditingController _fromtimeController = TextEditingController();
  TextEditingController _totimeController = TextEditingController();
  TimeOfDay _time = const TimeOfDay(hour: 7, minute: 15);
  final _formkey = GlobalKey<FormState>();
  bool isLoadingRecent = true;
  List<Farereq> recentSearches = [];
  String username = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await SecurityCheck.checkAndExitIfCompromised(context);
      if (!mounted) return;
      setState(() {
        final DateFormat timeFormat = DateFormat('hh:mm a');

        // Current time
        final DateTime now = DateTime.now();
        _fromtimeController.text = timeFormat.format(now);

        // To Time → 11:59 PM
        final DateTime endOfDay = DateTime(
          now.year,
          now.month,
          now.day,
          23,
          59,
        );
        _totimeController.text = timeFormat.format(endOfDay);
      });
      // Livelocationfun.instance.startTracking(
      //   context: context,
      //   onLocationUpdate: (position) {
      //     if (!mounted) return;
      //     setState(() {
      //       doublelat = position.latitude;
      //       doublelong = position.longitude;
      //       locationMessage =
      //           'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
      //       log("homescreen init:$locationMessage");
      //     });
      //   },
      // );
      fetchstop(context);
      userdet();
      recentValue();
      _getSharedata();
    });
  }

  void _getSharedata() async {
    final sharevalue = await SharedPrefManager.instance.getSharedData();
    if (!mounted) return;
    setState(() {
      username = sharevalue?.name ?? '';
      log(username);
    });
  }

  Future fetchstop(BuildContext context) async {
    cpayMoblst = await SearchFun.instance.fetchStage(context);
    if (!mounted) return;
    setState(() {
      filteredFromPlace = cpayMoblst;
      filteredToPlace = cpayMoblst;
    });
  }

  void filterFromList(String query) {
    if (cpayMoblst == null) return;
    setState(() {
      if (query.isEmpty) {
        filteredFromPlace = cpayMoblst;
      } else {
        filteredFromPlace = cpayMoblst
            ?.where(
              (item) =>
                  item.stopName!.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  void filterToList(String query) {
    if (cpayMoblst == null) return;
    setState(() {
      if (query.isEmpty) {
        filteredToPlace = cpayMoblst;
      } else {
        filteredToPlace = cpayMoblst
            ?.where(
              (item) =>
                  item.stopName!.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  void userdet() async {
    final val = await SharedPrefManager.instance.getSharedData();
    if (!mounted) return;

    setState(() {
      usrNm = val!.name;
    });
  }

  Future<void> recentValue() async {
    final val = await SharedPrefManager.instance.loadRecentSearches();
    if (!mounted) return;

    setState(() {
      recentSearches = val;
      isLoadingRecent = false;
    });
  }

  @override
  void dispose() {
    Livelocationfun.instance.stopTracking();
    _fromtimeController.dispose();
    _totimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {
            showFromDropdown = false;
            showToDropdown = false;
          });
        },
        child: SafeArea(
          child: Material(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(color: Colors.white),
                  ),
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2.422,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(35),
                            bottomLeft: Radius.circular(35),
                          ),
                        ),
                        child: Text(""),
                      ),
                    ],
                  ),

                  Positioned(
                    top: MediaQuery.of(context).size.height / 12.2,
                    left: MediaQuery.of(context).size.width / 20,
                    right: MediaQuery.of(context).size.width / 20,
                    child: Card(
                      elevation: 8, // Adds shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ), // Rounded edges
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white, // Card background
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // FROM TextFormField
                              TextFormField(
                                controller: fromcontroller,
                                cursorColor: Colors.black,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(fontSize: 18),
                                keyboardType: TextInputType.text,
                                autocorrect: false,
                                enableSuggestions: false,
                                decoration: InputDecoration(
                                  hintText: 'From',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontSize: 16,
                                        color: Colors.grey[700],
                                      ),
                                  prefixIcon: const Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none,
                                  errorStyle: const TextStyle(
                                    height: 0,
                                    fontSize: 0,
                                  ),
                                ),
                                // onChanged: (value) {
                                //   filterFromList(value);
                                //   showFromDropdown = true;
                                // },
                                onChanged: (value) {
                                  filterFromList(value);
                                  setState(() {
                                    showFromDropdown =
                                        value.isNotEmpty; // ONLY when typing
                                    showToDropdown = false;
                                  });
                                },

                                // onTap: () {
                                //   setState(() {
                                //     showFromDropdown = !showFromDropdown;
                                //     if (showFromDropdown) {
                                //       showToDropdown = false;
                                //     }
                                //   });
                                // },
                                onTap: () {
                                  setState(() {
                                    showFromDropdown =
                                        false; // just tapping won't open
                                    showToDropdown = false;
                                  });
                                },

                                validator: (value) {
                                  if (value!.isEmpty) {
                                    CommonFun.instance.showApierror(
                                      context,
                                      "Enter From Station",
                                    );
                                    return "";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 1.5.h),

                              // TO TextFormField
                              TextFormField(
                                controller: tocontroller,
                                cursorColor: Colors.black,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(fontSize: 18),
                                decoration: InputDecoration(
                                  hintText: 'To',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontSize: 16,
                                        color: Colors.grey[700],
                                      ),
                                  prefixIcon: const Icon(
                                    Icons.flag_outlined,
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none,
                                  errorStyle: const TextStyle(
                                    height: 0,
                                    fontSize: 0,
                                  ),
                                ),
                                // onChanged: (value) {
                                //   filterToList(value);
                                //   showToDropdown = true;
                                // },
                                onChanged: (value) {
                                  filterToList(value);
                                  setState(() {
                                    showToDropdown =
                                        value.isNotEmpty; // ONLY when typing
                                    showFromDropdown = false;
                                  });
                                },

                                // onTap: () {
                                //   setState(() {
                                //     showToDropdown = !showToDropdown;
                                //     if (showToDropdown) {
                                //       showFromDropdown = false;
                                //     }
                                //   });
                                // },
                                onTap: () {
                                  setState(() {
                                    showToDropdown = false;
                                    showFromDropdown = false;
                                  });
                                },

                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    CommonFun.instance.showApierror(
                                      context,
                                      "Enter Destination",
                                    );
                                    return "";
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: .5.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _fromtimeController,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(fontSize: 18),
                                      decoration: InputDecoration(
                                        labelText: 'From Time',
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(fontSize: 16),
                                        prefixIcon: Theme(
                                          data: Theme.of(context),
                                          child: const Icon(
                                            Icons.timer,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        border: InputBorder.none,
                                        errorStyle: const TextStyle(
                                          height: 0,
                                          fontSize: 0,
                                        ),
                                      ),
                                      onTap: () => _selectTime(
                                        context,
                                        _fromtimeController,
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          CommonFun.instance.showApierror(
                                            context,
                                            "Select Boarding Time",
                                          );
                                          return "";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ), // Add spacing between the fields
                                  Expanded(
                                    child: TextFormField(
                                      controller: _totimeController,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(fontSize: 18),
                                      decoration: InputDecoration(
                                        labelText: 'To Time',
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(fontSize: 16),
                                        prefixIcon: Theme(
                                          data: Theme.of(context),
                                          child: const Icon(
                                            Icons.timer,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        border: InputBorder.none,
                                        errorStyle: const TextStyle(
                                          height: 0,
                                          fontSize: 0,
                                        ),
                                      ),
                                      onTap: () => _selectTime(
                                        context,
                                        _totimeController,
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          CommonFun.instance.showApierror(
                                            context,
                                            "Enter Destination Time",
                                          );
                                          return "";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 1.5.h),
                              GestureDetector(
                                onTap: () async {
                                  if (_formkey.currentState!.validate()) {
                                    final String from = fromcontroller.text;
                                    final String to = tocontroller.text;
                                    final String frmTime =
                                        _fromtimeController.text;
                                    final String toTime =
                                        _totimeController.text;

                                    final DateFormat inputFormat = DateFormat(
                                      'hh:mm a',
                                    );
                                    final DateTime datefrmTime = inputFormat
                                        .parse(frmTime);
                                    final DateTime datetoTime = inputFormat
                                        .parse(toTime);

                                    final DateFormat outputFormat = DateFormat(
                                      'hh:mm:ss a',
                                    );
                                    final frmtm = outputFormat.format(
                                      datefrmTime,
                                    );
                                    final totm = outputFormat.format(
                                      datetoTime,
                                    );
                                    log("fromtime:$frmtm,totime:$totm");
                                    final now = DateTime.now();
                                    final date = DateFormat(
                                      'dd-MM-yyyy',
                                    ).format(now);
                                    final time = DateFormat(
                                      'hh:mm a',
                                    ).format(now);
                                    final farereq = Farereq(
                                      fromPlace: from,
                                      toPlace: to,
                                      startTime: frmtm,
                                      endTime: totm,
                                      crntDt: date,
                                      crntTm: time,
                                    );
                                    await SharedPrefManager.instance
                                        .saveRecentSearch(farereq);
                                    if (!context.mounted) return;
                                    await SearchFun.instance.searchBus(
                                      farereq,
                                      context,
                                    );
                                    if (!context.mounted) return;
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ScreenSearchList(req: farereq),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  height: 7.h,
                                  //margin: EdgeInsets.only(left: 50,right: 50),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Theme.of(context).colorScheme.secondary,
                                        Theme.of(context).colorScheme.primary,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Search For Bus',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top:
                        MediaQuery.of(context).size.height /
                        7.3, // Adjust position
                    left: MediaQuery.of(context).size.width / 28,
                    right: MediaQuery.of(context).size.width / 28,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Divider(
                            color: Colors.grey.shade400,
                            thickness: 0.8,
                            // height: 1, // Minimum height to remove gap
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              right: 8,
                            ), // Adjust if needed
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: IconButton(
                              iconSize: 20,
                              padding: const EdgeInsets.all(6),
                              icon: Icon(
                                Icons.swap_vert,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {
                                final temp = fromcontroller.text;
                                fromcontroller.text = tocontroller.text;
                                tocontroller.text = temp;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    top: MediaQuery.of(context).size.height / 2.3,
                    left: MediaQuery.of(context).size.width / 28,
                    right: MediaQuery.of(context).size.width / 28,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        username.isEmpty
                            ? GestureDetector(
                                onTap: () {
                                  loginalert(context);
                                },
                                child: Container(
                                  height: 7.h,
                                  margin: EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Theme.of(context).colorScheme.secondary,
                                        Theme.of(context).colorScheme.primary,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),

                                  child: Center(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 4.8.h,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.qr_code_scanner,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                              size: 25,
                                            ),
                                            onPressed: () {},
                                          ),
                                        ),
                                        Text(
                                          'Get Ticket',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          Approutes().qrscreen,
                                        );
                                      },
                                      child: Container(
                                        height: 7.h,
                                        margin: EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                        ),

                                        child: Center(
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 4.8.h,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.grey.shade300,
                                                  ),
                                                ),
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.qr_code_scanner,
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                    size: 25,
                                                  ),
                                                  onPressed: () {},
                                                ),
                                              ),
                                              Text(
                                                'Get Ticket',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(fontSize: 16),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          Approutes().mytickets,
                                        );
                                      },
                                      child: Container(
                                        height: 7.h,
                                        margin: EdgeInsets.only(left: 8),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                        ),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 4.8.h,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.grey.shade300,
                                                  ),
                                                ),
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons
                                                        .local_activity_outlined,
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                    size: 25,
                                                  ),
                                                  onPressed: () {},
                                                ),
                                              ),
                                              //SizedBox(width: 3.w),
                                              Text(
                                                'Show Ticket',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(fontSize: 16),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                  if (showFromDropdown &&
                      filteredFromPlace != null &&
                      filteredFromPlace!.isNotEmpty) ...[
                    Positioned(
                      top:
                          MediaQuery.of(context).size.height /
                          5.8, // Adjust position
                      left: MediaQuery.of(context).size.width / 28,
                      right: MediaQuery.of(context).size.width / 28,
                      child: Container(
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredFromPlace!.length,
                          itemBuilder: (context, index) {
                            final item = filteredFromPlace![index];
                            return Material(
                              color: Colors.transparent,
                              child: ListTile(
                                title: Text(
                                  item.stopName ?? '',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(fontSize: 16),
                                ),
                                onTap: () {
                                  setState(() {
                                    fromcontroller.text = item.stopName ?? '';
                                    //addToRecentSearches(item);
                                    showFromDropdown = false;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ] else if (showFromDropdown &&
                      filteredFromPlace != null &&
                      filteredFromPlace!.isEmpty) ...[
                    Positioned(
                      top: MediaQuery.of(context).size.height / 5.8,
                      left: MediaQuery.of(context).size.width / 28,
                      right: MediaQuery.of(context).size.width / 28,
                      child: Container(
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "No place found",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins-Medium',
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (showToDropdown &&
                      filteredToPlace != null &&
                      filteredToPlace!.isNotEmpty) ...[
                    Positioned(
                      top:
                          MediaQuery.of(context).size.height /
                          4, // Adjust position
                      left: MediaQuery.of(context).size.width / 28,
                      right: MediaQuery.of(context).size.width / 28,
                      child: Container(
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredToPlace!.length,
                          itemBuilder: (context, index) {
                            final item = filteredToPlace![index];
                            return Material(
                              color: Colors.transparent,
                              child: ListTile(
                                title: Text(
                                  item.stopName ?? '',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(fontSize: 16),
                                ),
                                onTap: () {
                                  setState(() {
                                    tocontroller.text = item.stopName ?? '';
                                    //addToRecentSearches(item);
                                    showToDropdown = false;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ] else if (showToDropdown &&
                      filteredToPlace != null &&
                      filteredToPlace!.isEmpty) ...[
                    Positioned(
                      top: MediaQuery.of(context).size.height / 4,
                      left: MediaQuery.of(context).size.width / 28,
                      right: MediaQuery.of(context).size.width / 28,
                      child: Container(
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "No place found",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins-Medium',
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],

                  Positioned(
                    top: MediaQuery.of(context).size.height / 1.9,
                    left: MediaQuery.of(context).size.width / 28,
                    right: MediaQuery.of(context).size.width / 28,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recent Search',
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                          ),
                          SizedBox(height: 1.h),
                          if (isLoadingRecent)
                            Center(child: CircularProgressIndicator())
                          else if (recentSearches.isEmpty)
                            Center(
                              child: Text(
                                'No recent searches',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: recentSearches.length > 3
                                  ? 3
                                  : recentSearches.length,
                              itemBuilder: (context, index) {
                                final item = recentSearches[index];
                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 2),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      // gradient: LinearGradient(
                                      //   begin: Alignment.topCenter,
                                      //   end: Alignment.bottomCenter,
                                      //   colors: [
                                      //     Theme.of(context).colorScheme.secondary,
                                      //     Theme.of(context).colorScheme.primary,
                                      //   ],
                                      // ),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.history,
                                          color: Colors.black,
                                        ),
                                        title: Text(
                                          '${item.fromPlace} → ${item.toPlace}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                        subtitle: Text(
                                          'Date: ${item.crntDt} | Time: ${item.crntTm}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(fontSize: 12),
                                        ),
                                        onTap: () async {
                                          setState(() {
                                            fromcontroller.text =
                                                item.fromPlace ?? '';
                                            tocontroller.text =
                                                item.toPlace ?? '';

                                            final inputFormat = DateFormat(
                                              'hh:mm:ss a',
                                            ); // your stored format
                                            final outputFormat = DateFormat(
                                              'hh:mm a',
                                            ); // display format

                                            final DateTime startDt = inputFormat
                                                .parse(item.startTime);
                                            final DateTime endDt = inputFormat
                                                .parse(item.endTime);

                                            _fromtimeController.text =
                                                outputFormat.format(startDt);
                                            _totimeController.text =
                                                outputFormat.format(endDt);

                                            showFromDropdown = false;
                                            showToDropdown = false;
                                          });

                                          final now = DateTime.now();
                                          final date = DateFormat(
                                            'dd-MM-yyyy',
                                          ).format(now);
                                          final time = DateFormat(
                                            'hh:mm a',
                                          ).format(now);

                                          final farereq = Farereq(
                                            fromPlace: item.fromPlace ?? '',
                                            toPlace: item.toPlace ?? '',
                                            startTime: item.startTime,
                                            endTime: item.endTime,
                                            crntDt: date,
                                            crntTm: time,
                                          );
                                          await SharedPrefManager.instance
                                              .saveRecentSearch(farereq);
                                          // if (!context.mounted) return;
                                          // await SearchFun.instance.searchBus(
                                          //   farereq,
                                          //   context,
                                          // );
                                          // if (!context.mounted) return;
                                          // Navigator.of(context).pushReplacement(
                                          //   MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         ScreenSearchList(req: farereq),
                                          //   ),
                                          // );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  username.isEmpty
                      ? Positioned(
                          top: MediaQuery.of(context).size.height * 0.02,
                          left: MediaQuery.of(context).size.width * 0.017,
                          right: MediaQuery.of(context).size.width * 0.017,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "PomPomPay",
                                style: Theme.of(context).textTheme.headlineLarge
                                    ?.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                              ),
                              Stack(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.menu,
                                      color: Colors.white, // Icon color
                                      size: 30,
                                      //fill:10
                                    ),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        Approutes().menuScreen,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Positioned(
                          top: MediaQuery.of(context).size.height * 0.02,
                          left: MediaQuery.of(context).size.width * 0.017,
                          right: MediaQuery.of(context).size.width * 0.017,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Builder(
                                builder: (context) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Welcome,",
                                      style: TextStyle(
                                        fontFamily: 'Poppins-Medium',
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.normal,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                      ),
                                      textScaler: TextScaler.noScaling,
                                    ),
                                    Text(
                                      "$usrNm".toUpperCase(),
                                      style: TextStyle(
                                        fontFamily: 'Poppins-Medium',
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                      ),
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ],
                                ),
                              ),
                              Stack(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.menu,
                                      color: Colors.white, // Icon color
                                      size: 30,
                                      //fill:10
                                    ),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        Approutes().menuScreen,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectTime(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateFormat timeFormat = DateFormat(
      'hh:mm a',
    ); // 12-hour format with AM/PM
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(alwaysUse24HourFormat: false), // Force 12-hour format
            child: child!,
          ),
        );
      },
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        final now = DateTime.now();
        final DateTime formattedTime = DateTime(
          now.year,
          now.month,
          now.day,
          newTime.hour,
          newTime.minute,
          // 0,
        );
        controller.text = timeFormat.format(formattedTime); // Show AM/PM format
      });
    }
  }
}

Future<void> loginalert(BuildContext originalContext) async {
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
                      const Icon(Icons.warning, color: Colors.amber, size: 35),
                      const SizedBox(width: 8),
                      Text(
                        "Login Required",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Please log in to access all features of the application",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Row(
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
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "cancel",
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
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
                              Navigator.pushReplacement(
                                context,
                                Approutes().loginscreen,
                              );
                            },
                            child: Text(
                              "Login",
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
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
