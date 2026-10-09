import 'dart:developer';
import 'package:pompompay/core/hook/hooks.dart';

class ScreenLiveTicket extends StatefulWidget {
  const ScreenLiveTicket({
    super.key,
    required this.tktvw,
    required this.title,
    required this.initialTab,
  });
  final Ticketview tktvw;
  final String title;
  final int initialTab;
  @override
  State<ScreenLiveTicket> createState() => _ScreenLiveTicketState();
}

class _ScreenLiveTicketState extends State<ScreenLiveTicket> {
  Future<bool?> popscreen(BuildContext context) async {
    // Navigator.pushReplacement(context, Approutes().mytickets);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (originalContext) =>
            ScreenMyTickets(initialTabIndex: widget.initialTab),
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
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

            body: Center(
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02,
                      left: MediaQuery.of(context).size.width * 0.017,
                      right: MediaQuery.of(context).size.width * 0.017,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(
                              Icons.chevron_left,
                              size: 30,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (originalContext) => ScreenMyTickets(
                                    initialTabIndex: widget.initialTab,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Center(
                          child: Text(
                            widget.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Center(
                      child: ClipPath(
                        clipper: TicketClipper(),
                        child: SizedBox(
                          width: double.infinity,
                          //height: 330,
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
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  _getWatermark(
                                    int.parse(widget.tktvw.status ?? "0"),
                                  ),
                                  Column(
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                widget.tktvw.busName
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
                                                widget.tktvw.registrationNo ??
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
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                widget.tktvw.travelDate ?? '',
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
                                                widget.tktvw.travelTime ?? '',
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
                                          const SizedBox(height: 4),
                                          Text(
                                            widget.tktvw.routename ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            widget.tktvw.ticketNo ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),

                                      /// Route section
                                      Row(
                                        children: [
                                          /// FROM
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "FROM STOP",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                                Text(
                                                  widget.tktvw.fromPlace ?? '',
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
                                          ),

                                          /// Dotted line + bus
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
                                                    direction: Axis.horizontal,
                                                    lineLength: 30,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  const Icon(
                                                    Icons.directions_bus,
                                                    color: Colors.blue,
                                                    size: 25,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  DottedLine(
                                                    dashLength: 4,
                                                    dashGapLength: 3,
                                                    lineThickness: 2,
                                                    dashColor: Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                    direction: Axis.horizontal,
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
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                                Text(
                                                  widget.tktvw.toPlace ?? '',
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
                                                    widget.tktvw.adults ?? "0",
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
                                                      widget.tktvw.adults ?? '',
                                                    ),
                                                    _buildFareCell(
                                                      context,
                                                      "x",
                                                    ),
                                                    _buildFareCell(
                                                      context,
                                                      widget
                                                              .tktvw
                                                              .singleadult ??
                                                          '',
                                                    ),
                                                    _buildFareCell(
                                                      context,
                                                      "=",
                                                    ),
                                                    _buildFareCell(
                                                      context,
                                                      widget.tktvw.adultfare ??
                                                          '',
                                                    ),
                                                  ],
                                                ),
                                              if (int.tryParse(
                                                    widget.tktvw.kids ?? "0",
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
                                                      widget.tktvw.kids ?? '',
                                                    ),
                                                    _buildFareCell(
                                                      context,
                                                      "x",
                                                    ),
                                                    _buildFareCell(
                                                      context,
                                                      widget.tktvw.singlekids ??
                                                          '',
                                                    ),
                                                    _buildFareCell(
                                                      context,
                                                      "=",
                                                    ),
                                                    _buildFareCell(
                                                      context,
                                                      widget.tktvw.kidsfare ??
                                                          '',
                                                    ),
                                                  ],
                                                ),
                                              if (int.tryParse(
                                                    widget.tktvw.student ?? "0",
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
                                                      widget.tktvw.student ??
                                                          '',
                                                    ),
                                                    _buildFareCell(
                                                      context,
                                                      "x",
                                                    ),
                                                    _buildFareCell(
                                                      context,
                                                      widget
                                                              .tktvw
                                                              .singlestudent ??
                                                          '',
                                                    ),
                                                    _buildFareCell(
                                                      context,
                                                      "=",
                                                    ),
                                                    _buildFareCell(
                                                      context,
                                                      widget.tktvw.studentfare ??
                                                          '',
                                                    ),
                                                  ],
                                                ),
                                                if (int.tryParse(
                                                    widget.tktvw.handicapped ?? "0",
                                                  ) !=
                                                  0)
                                                TableRow(
                                                  children: [
                                                    _buildFareCell(
                                                      context,
                                                      "Handicapped :",
                                                    ),
                                                    _buildFareCell(
                                                      context,
                                                      widget.tktvw.handicapped ??
                                                          '',
                                                    ),
                                                    _buildFareCell(
                                                      context,
                                                      "x",
                                                    ),
                                                    _buildFareCell(
                                                      context,
                                                      widget
                                                              .tktvw
                                                              .singlehandicapped ??
                                                          '',
                                                    ),
                                                    _buildFareCell(
                                                      context,
                                                      "=",
                                                    ),
                                                    _buildFareCell(
                                                      context,
                                                      widget.tktvw.handicappedfare ??
                                                          '',
                                                    ),
                                                  ],
                                                ),
                                                if (int.tryParse(
                                                    widget.tktvw.discount ?? "0",
                                                  ) !=
                                                  0)
                                                TableRow(
                                                  children: [
                                                    _buildFareCell(
                                                      context,
                                                      "Discount :",
                                                    ),
                                                    _buildFareCell(
                                                      context,
                                                      " ",
                                                    ),
                                                    _buildFareCell(
                                                      context,
                                                      " ",
                                                    ),
                                                    _buildFareCell(
                                                      context,
                                                      " ",
                                                    ),
                                                    _buildFareCell(
                                                      context,
                                                      "=",
                                                    ),
                                                    _buildFareCell(
                                                      context,
                                                      widget.tktvw.discount ??
                                                          '',
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Rs ${widget.tktvw.totalfare}.0",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const SizedBox(height: 14),

                                          if (widget.tktvw.ticketNo != null)
                                            QrImageView(
                                              data: widget.tktvw.ticketNo!,
                                              version: QrVersions.auto,
                                              size: 150.0,
                                              backgroundColor: Colors.white,
                                              eyeStyle: const QrEyeStyle(
                                                color: Colors.black,
                                                eyeShape: QrEyeShape.square,
                                              ),
                                              dataModuleStyle:
                                                  const QrDataModuleStyle(
                                                    color: Colors.black,
                                                    dataModuleShape:
                                                        QrDataModuleShape
                                                            .square,
                                                  ),
                                              errorCorrectionLevel:
                                                  QrErrorCorrectLevel.H,
                                            ),
                                        ],
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
                ],
              ),
            ),
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

  Widget _getWatermark(int status) {
    switch (status) {
      case 0:
        return Image.asset(
          "assets/image/status/valid.png",
          width: 250,
          height: 250,
          fit: BoxFit.contain,
          opacity: const AlwaysStoppedAnimation(.2),
        );
      case 1:
        return Image.asset(
          "assets/image/status/refund.png",
          width: 250,
          height: 250,
          fit: BoxFit.contain,
          opacity: const AlwaysStoppedAnimation(.2),
        );
      case 2:
        return Image.asset(
          "assets/image/status/pending.png",
          width: 250,
          height: 250,
          fit: BoxFit.contain,
          opacity: const AlwaysStoppedAnimation(.2),
        );
      case 3:
        return Image.asset(
          "assets/image/status/failed.png",
          width: 250,
          height: 250,
          fit: BoxFit.contain,
          opacity: const AlwaysStoppedAnimation(.2),
        );
      case 4:
        return Image.asset(
          "assets/image/status/cancelled.png",
          width: 250,
          height: 250,
          fit: BoxFit.contain,
          opacity: const AlwaysStoppedAnimation(.2),
        );

      default:
        return const SizedBox();
    }
  }
}
