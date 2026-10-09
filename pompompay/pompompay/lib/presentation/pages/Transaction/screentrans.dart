import 'dart:developer';
import 'package:pompompay/core/hook/hooks.dart';

class ScreenTransaction extends StatefulWidget {
  const ScreenTransaction({super.key, this.initialTabIndex = 0});
  final int initialTabIndex;
  @override
  State<ScreenTransaction> createState() => _ScreenTransactionState();
}

class _ScreenTransactionState extends State<ScreenTransaction>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String? usrid;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TicketFun.instance.getHistoryTktListNotifier.value = [];
    });
    fetchtkt(context);

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex, // Set initial tab
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {});
      log('Tab changed to: ${_tabController.index}');
    });
  }

  Future fetchtkt(BuildContext context) async {
    final val = await SharedPrefManager.instance.getSharedData();
    setState(() {
      usrid = val?.userId ?? '';
    });
    final tktreq = Farereq(userId: usrid, ticketstatus: 0);
    if (!context.mounted) return;
    await TicketFun.instance.fetchTket(tktreq, context);
  }

  // Future<bool?> popscreen(BuildContext context) async {
  //   TicketFun.instance.getHistoryTktListNotifier.value = [];

  //   if (mounted) {
  //     Navigator.pushReplacement(context, Approutes().mainScreen);
  //   }
  //   return true;
  // }

  Color _getCardColor(String status) {
    switch (status) {
      case "0": // Active
        return Colors.white;
      case "1": // Active
        return Color(0xFFE6E6FA);
      case "2": // Processing
        return const Color(0xFFFFF9C4); // Light Yellow
      case "3": // Failed
        return const Color(0xFFFFCCBC); // Light Orange
      case "4": // Cancelled
        return const Color(0xFFFFCDD2); // Light Red
      default:
        return Colors.white;
    }
  }

  Icon _getStatusIcon(String status) {
    switch (status) {
      case "0": // Success
        return const Icon(Icons.check_circle, color: Colors.green, size: 28);
      case "1": // Success
        return const Icon(Icons.check_circle, color: Colors.orange, size: 28);
      case "2": // Processing
        return const Icon(Icons.history, color: Colors.amber, size: 28);
      case "3": // Failed
        return const Icon(Icons.cancel, color: Colors.redAccent, size: 28);
      case "4": // Cancelled
        return const Icon(Icons.block, color: Colors.red, size: 28);
      default:
        return const Icon(Icons.help_outline, color: Colors.grey, size: 28);
    }
  }

  @override
  void dispose() {
    _tabController.dispose(); // Always dispose controllers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundColorGradient(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05,
                  left: MediaQuery.of(context).size.width * 0.017,
                  right: MediaQuery.of(context).size.width * 0.017,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: IconButton(
                    //     icon: const Icon(
                    //       Icons.chevron_left,
                    //       size: 30,
                    //       color: Colors.white,
                    //     ),
                    //     onPressed: () {
                    //       TicketFun.instance.getHistoryTktListNotifier.value = [];

                    //       Navigator.pushReplacement(
                    //         context,
                    //         Approutes().mainScreen,
                    //       );
                    //     },
                    //   ),
                    // ),
                    Center(
                      child: Text(
                        'History',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: TicketFun.instance.getHistoryTktListNotifier,

                  builder: (BuildContext context, List<Ticketview> newList, Widget? _) {
                    if (newList.isNotEmpty) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(6),
                        itemCount: newList.length,
                        itemBuilder: (context, index) {
                          final ticket = newList[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Center(
                              child: ClipPath(
                                clipper: TicketClipper(),
                                child: SizedBox(
                                  width: double.infinity,
                                  //height: 330,
                                  child: GestureDetector(
                                    onTap: () {
                                      // Navigator.of(context).push(
                                      //   MaterialPageRoute(
                                      //     builder:
                                      //         (originalContext) => ScreenLiveTicket(
                                      //           tktvw: ticket,
                                      //           title:
                                      //               widget.ticketStatus == activetkt
                                      //                   ? "Active Ticket"
                                      //                   : "Inactive Ticket",
                                      //           initialTab: widget.ticketStatus == activetkt? 0:1,
                                      //         ),
                                      //   ),
                                      // );
                                    },
                                    child: Card(
                                      elevation: 8,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getCardColor(
                                            ticket.status ?? 0,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            /// Header info
                                            Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    _getStatusIcon(
                                                      ticket.status ?? 0,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),

                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      ticket.busName
                                                              ?.toUpperCase() ??
                                                          '',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      ticket.registrationNo ??
                                                          '',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 2),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      ticket.travelDate ?? '',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      ticket.travelTime ?? '',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  ticket.routename ?? '',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  ticket.tiketNo ?? '',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                const SizedBox(height: 10),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                /// FROM
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "FROM STOP",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                      ),
                                                      Text(
                                                        ticket.fromPlace ?? '',
                                                        style: Theme.of(context)
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
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        DottedLine(
                                                          dashLength: 4,
                                                          dashGapLength: 3,
                                                          lineThickness: 2,
                                                          dashColor: Theme.of(
                                                            context,
                                                          ).colorScheme.primary,
                                                          direction:
                                                              Axis.horizontal,
                                                          lineLength: 30,
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        const Icon(
                                                          Icons.directions_bus,
                                                          color: Colors.blue,
                                                          size: 25,
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        DottedLine(
                                                          dashLength: 4,
                                                          dashGapLength: 3,
                                                          lineThickness: 2,
                                                          dashColor: Theme.of(
                                                            context,
                                                          ).colorScheme.primary,
                                                          direction:
                                                              Axis.horizontal,
                                                          lineLength: 30,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),

                                                /// TO
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "TO STOP",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                      ),
                                                      Text(
                                                        ticket.toPlace ?? '',
                                                        style: Theme.of(context)
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
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 14),
                                            CustomPaint(
                                              painter: DottedSeparatorLine(
                                                yOffsetFactor: 0,
                                                color: Colors.grey,
                                              ),
                                              child: SizedBox(
                                                width: double.infinity,
                                                height: 1,
                                              ),
                                            ),

                                            const SizedBox(height: 14),

                                            /// Fare breakdown
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Table(
                                                  columnWidths: const {
                                                    0: FlexColumnWidth(4),
                                                    1: FlexColumnWidth(1),
                                                    2: FlexColumnWidth(1),
                                                    3: FlexColumnWidth(2),
                                                    4: FlexColumnWidth(1.5),
                                                    5: FlexColumnWidth(2),
                                                  },
                                                  children: [
                                                    if (int.tryParse(
                                                          ticket.adults ?? "0",
                                                        ) !=
                                                        0)
                                                      TableRow(
                                                        children: [
                                                          _buildFareCell(
                                                            context,
                                                            "Full :",
                                                          ),
                                                          _buildFareCell(
                                                            context,
                                                            ticket.adults ?? '',
                                                          ),
                                                          _buildFareCell(
                                                            context,
                                                            "x",
                                                          ),
                                                          _buildFareCell(
                                                            context,
                                                            ticket.singleadult ??
                                                                '',
                                                          ),
                                                          _buildFareCell(
                                                            context,
                                                            "=",
                                                          ),
                                                          _buildFareCell(
                                                            context,
                                                            ticket.adultfare ??
                                                                '',
                                                          ),
                                                        ],
                                                      ),
                                                    if (int.tryParse(
                                                          ticket.kids ?? "0",
                                                        ) !=
                                                        0)
                                                      TableRow(
                                                        children: [
                                                          _buildFareCell(
                                                            context,
                                                            "Kids :",
                                                          ),
                                                          _buildFareCell(
                                                            context,
                                                            ticket.kids ?? '',
                                                          ),
                                                          _buildFareCell(
                                                            context,
                                                            "x",
                                                          ),
                                                          _buildFareCell(
                                                            context,
                                                            ticket.singlekids ??
                                                                '',
                                                          ),
                                                          _buildFareCell(
                                                            context,
                                                            "=",
                                                          ),
                                                          _buildFareCell(
                                                            context,
                                                            ticket.kidsfare ??
                                                                '',
                                                          ),
                                                        ],
                                                      ),
                                                    if (int.tryParse(
                                                          ticket.student ?? "0",
                                                        ) !=
                                                        0)
                                                      TableRow(
                                                        children: [
                                                          _buildFareCell(
                                                            context,
                                                            "Students :",
                                                          ),
                                                          _buildFareCell(
                                                            context,
                                                            ticket.student ??
                                                                '',
                                                          ),
                                                          _buildFareCell(
                                                            context,
                                                            "x",
                                                          ),
                                                          _buildFareCell(
                                                            context,
                                                            ticket.singlestudent ??
                                                                '',
                                                          ),
                                                          _buildFareCell(
                                                            context,
                                                            "=",
                                                          ),
                                                          _buildFareCell(
                                                            context,
                                                            ticket.studentfare ??
                                                                '',
                                                          ),
                                                        ],
                                                      ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  "Rs ${ticket.totalfare}.0",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ],
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
                        future: Future.delayed(const Duration(seconds: 3)),
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
                                'No Ticket Found',
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
        ),
      ],
    );
  }

  Widget _buildFareCell(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        softWrap: true,
        overflow: TextOverflow.visible,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
