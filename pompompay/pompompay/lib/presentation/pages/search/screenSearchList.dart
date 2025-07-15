import 'dart:developer';
import 'package:pompompay/core/hook/hooks.dart';

class ScreenSearchList extends StatefulWidget {
  const ScreenSearchList({super.key, required this.req});
  final Farereq req;
  @override
  State<ScreenSearchList> createState() => _ScreenSearchListState();
}

class _ScreenSearchListState extends State<ScreenSearchList> {
  final TextEditingController sortTimeController = TextEditingController();
  final TextEditingController sortTypeController = TextEditingController();

  List<String> filteredBYTime = ["Duration", "Departure", "Arrival"];
  List<String> byType = ["ALL", "FP", "LS", "SF", "TT", "ORD"];

  bool showFromDropdown = false;
  bool showToDropdown = false;
  final Map<String, String> timeOptions = {
    "Duration": duration,
    "Departure": start,
    "Arrival": end,
  };
  String selectedSortTimeValue = duration;
  String? fromplace;
  String? toplace;

  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
      Livelocationfun.instance.startTracking(
          context: context,
          onLocationUpdate: (position) {
           
            log("serachlist screen init:");
          });
          
          });
    sortTimeController.text =
        timeOptions.entries
            .firstWhere((e) => e.value == selectedSortTimeValue)
            .key;
    sortTypeController.text = "ALL";
    fromplace = widget.req.fromPlace;
    toplace = widget.req.toPlace;
  }

  @override
  void dispose() {
    sortTimeController.dispose();
    sortTypeController.dispose();
    super.dispose();
  }

  Future<bool?> popscreen(BuildContext context) async {
    SearchFun.instance.getBusListNotifier.value = [];

    if (mounted) {
      Navigator.pushReplacement(context, Approutes().mainScreen);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        BackgroundColorGradient(),
        PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, Object? result) async {
            if (didPop) {
              log('Screen was popped with result: $result');
              return;
            }
            log('BackButton pressed! Navigating to login screen.');
            await popscreen(context);
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    showFromDropdown = false;
                    showToDropdown = false;
                  });
                },
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.chevron_left,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  SearchFun.instance.getBusListNotifier.value =
                                      [];

                                  Navigator.pushReplacement(
                                    context,
                                    Approutes().mainScreen,
                                  );
                                },
                              ),
                              const Spacer(),
                              Text(
                                'Search results',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                              const Spacer(flex: 2),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              // Time Dropdown Field
                              Expanded(
                                child: TextFormField(
                                  controller: sortTimeController,
                                  readOnly: true,
                                  onTap: () {
                                    setState(() {
                                      showFromDropdown = !showFromDropdown;
                                      if (showFromDropdown) {
                                        showToDropdown = false;
                                      }
                                    });
                                  },
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: "Sort by Time",
                                    suffixIcon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                    ),
                                    labelStyle: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white.withAlpha(
                                      (0.1 * 255).toInt(),
                                    ),

                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 14,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Type Dropdown Field
                              Expanded(
                                child: TextFormField(
                                  controller: sortTypeController,
                                  readOnly: true,
                                  onTap: () {
                                    setState(() {
                                      showToDropdown = !showToDropdown;
                                      if (showToDropdown) {
                                        showFromDropdown = false;
                                      }
                                    });
                                  },
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: "Sort by Type",
                                    suffixIcon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                    ),
                                    labelStyle: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white.withAlpha(
                                      (0.1 * 255).toInt(),
                                    ),

                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            width: screenWidth,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffffa600),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(
                                    (0.2 * 255).toInt(),
                                  ),
                                  blurRadius: 3,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              '${fromplace?.toUpperCase() ?? ''}  →  ${toplace?.toUpperCase() ?? ''}',
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                              textAlign: TextAlign.center,
                              softWrap: true,
                              overflow:
                                  TextOverflow
                                      .visible, // OR .ellipsis if you want to cut it
                              maxLines: 2,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ValueListenableBuilder(
                            valueListenable:
                                SearchFun.instance.getBusListNotifier,
                            builder: (
                              BuildContext context,
                              List<Datumlist> newList,
                              Widget? _,
                            ) {
                              if (newList.isNotEmpty) {
                                return ListView.builder(
                                  padding: const EdgeInsets.all(6),
                                  itemCount: newList.length,
                                  itemBuilder: (context, index) {
                                    final ticket = newList[index];

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 2.0,
                                      ),
                                      child: Center(
                                        child: ClipPath(
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: GestureDetector(
                                              onTap: () async {
                                                Livelocationfun.instance.startTracking(
                                                  context: context,
                                                  onLocationUpdate: (position) {
                                                    // setState(() {
                                                    //   doublelat = position.latitude;
                                                    //   doublelong = position.longitude;
                                                    //   locationMessage =
                                                    //       'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
                                                    //   if (doublelat != 0 && doublelong != 0) {
                                                    //     setState(() {
                                                    //       _crntlocation = LatLng(doublelat, doublelong);
                                                    //       isLoading = false;
                                                    //     });
                                                    //   }
                                                    //   //log('asgnd screen  init:$locationMessage');
                                                    // });
                                                    log(
                                                      'asgnd screen  init:$position',
                                                    );
                                                  },
                                                );
                                                final val =
                                                    await SharedPrefManager
                                                        .instance
                                                        .getSharedData();

                                                final stoplocReq = Farereq(
                                                  busId: ticket.busId,
                                                  tripId: ticket.tripId,
                                                  fromPlace: ticket.fromStation,
                                                  toPlace: ticket.toStation,
                                                  userId: val?.userId ?? '',
                                                  from: ticket.fromStop,
                                                  to: ticket.toStop,
                                                );
                                                if (!context.mounted) return;
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            ScreenMapTrack(
                                                              stoploc:
                                                                  stoplocReq,
                                                            ),
                                                  ),
                                                );
                                              },
                                              child: Card(
                                                elevation: 8,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 14,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                        border: Border.all(
                                                          color:
                                                              Theme.of(context).colorScheme.primary,
                                                        ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      /// Header info
                                                      Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                ticket.busName
                                                                        ?.toUpperCase() ??
                                                                    '',
                                                                style: Theme.of(
                                                                      context,
                                                                    )
                                                                    .textTheme
                                                                    .bodySmall
                                                                    ?.copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              Text(
                                                                ticket.registrationNo
                                                                        ?.toUpperCase() ??
                                                                    '',
                                                                style: Theme.of(
                                                                      context,
                                                                    )
                                                                    .textTheme
                                                                    .bodySmall
                                                                    ?.copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              Text(
                                                                ticket.busType
                                                                        ?.toUpperCase() ??
                                                                    '',
                                                                style: Theme.of(
                                                                      context,
                                                                    )
                                                                    .textTheme
                                                                    .bodySmall
                                                                    ?.copyWith(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "Via",
                                                                style: Theme.of(
                                                                      context,
                                                                    )
                                                                    .textTheme
                                                                    .bodySmall
                                                                    ?.copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              Text(
                                                                ticket.via ??
                                                                    '',
                                                                style: Theme.of(
                                                                      context,
                                                                    )
                                                                    .textTheme
                                                                    .bodySmall
                                                                    ?.copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),

                                                      /// Route section
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          /// FROM
                                                          Text(
                                                            ticket.fromArrival ??
                                                                '',
                                                            style: Theme.of(
                                                                  context,
                                                                )
                                                                .textTheme
                                                                .bodySmall
                                                                ?.copyWith(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                          ),

                                                          /// Dotted line + bus
                                                          Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  DottedLine(
                                                                    dashLength:
                                                                        4,
                                                                    dashGapLength:
                                                                        3,
                                                                    lineThickness:
                                                                        2,
                                                                    dashColor:
                                                                        Theme.of(
                                                                          context,
                                                                        ).colorScheme.primary,
                                                                    direction:
                                                                        Axis.horizontal,
                                                                    lineLength:
                                                                        30,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Text(
                                                                    formatDuration(
                                                                      ticket
                                                                          .duration,
                                                                    ),
                                                                    style: Theme.of(
                                                                      context,
                                                                    ).textTheme.bodySmall?.copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  DottedLine(
                                                                    dashLength:
                                                                        4,
                                                                    dashGapLength:
                                                                        3,
                                                                    lineThickness:
                                                                        2,
                                                                    dashColor:
                                                                        Theme.of(
                                                                          context,
                                                                        ).colorScheme.primary,
                                                                    direction:
                                                                        Axis.horizontal,
                                                                    lineLength:
                                                                        30,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),

                                                          /// TO
                                                          Text(
                                                            ticket.toArrival ??
                                                                '',
                                                            style: Theme.of(
                                                                  context,
                                                                )
                                                                .textTheme
                                                                .bodySmall
                                                                ?.copyWith(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                          ),
                                                        ],
                                                      ),

                                                      const SizedBox(
                                                        height: 14,
                                                      ),

                                                      /// Separator line (simulated dotted separator)
                                                      CustomPaint(
                                                        painter:
                                                            DottedSeparatorLine(
                                                              yOffsetFactor: 0,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                        child: SizedBox(
                                                          width:
                                                              double.infinity,
                                                          height: 1,
                                                        ),
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
                                );
                              } else {
                                return FutureBuilder(
                                  future: Future.delayed(
                                    const Duration(seconds: 3),
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      );
                                    } else {
                                      return Center(
                                        child: Text(
                                          'Search no found',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      );
                                    }
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    if (showFromDropdown)
                      Positioned(
                        top: screenHeight / 6.3,
                        left: 16,
                        right: screenWidth / 2 + 8,
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: filteredBYTime.length,
                            itemBuilder: (context, index) {
                              final item = filteredBYTime[index];
                              return InkWell(
                                onTap: () async {
                                  setState(() {
                                    sortTimeController.text = item;
                                    selectedSortTimeValue = timeOptions[item]!;
                                    showFromDropdown = false;
                                  });
                                  final sortreq = Farereq(
                                    fromPlace: widget.req.fromPlace,
                                    toPlace: widget.req.toPlace,
                                    startTime: widget.req.startTime,
                                    endTime: widget.req.endTime,
                                    type: sortTypeController.text,
                                    flag: selectedSortTimeValue,
                                  );
                                  SearchFun.instance.getBusListNotifier.value =[];

                                  await SearchFun.instance.sortBus(
                                    sortreq,
                                    context,
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6.0,
                                    horizontal: 12.0,
                                  ), // reduce vertical padding here
                                  child: Text(
                                    item,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(fontSize: 16),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                    // Dropdown for Type
                    if (showToDropdown)
                      Positioned(
                        top: screenHeight / 6.3,
                        left: screenWidth / 2 + 24,
                        right: 16,
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: byType.length,
                            itemBuilder: (context, index) {
                              final item = byType[index];
                              return InkWell(
                                onTap: () async {
                                  setState(() {
                                    sortTypeController.text = item;
                                    showToDropdown = false;
                                  });
                                  final sortreq = Farereq(
                                    fromPlace: widget.req.fromPlace,
                                    toPlace: widget.req.toPlace,
                                    startTime: widget.req.startTime,
                                    endTime: widget.req.endTime,
                                    type: sortTypeController.text,
                                    flag: selectedSortTimeValue,
                                  );
                                  SearchFun.instance.getBusListNotifier.value =
                                      [];
                                  await SearchFun.instance.sortBus(
                                    sortreq,
                                    context,
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6.0,
                                    horizontal: 12.0,
                                  ),
                                  child: Text(
                                    item,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(fontSize: 16),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String formatDuration(String? duration) {
    if (duration == null || duration.isEmpty) return '';
    final parts = duration.split(':'); // ["01", "32", "00"]
    if (parts.length >= 2) {
      return '${parts[0]}h${parts[1]}m';
    }
    return '';
  }
}
