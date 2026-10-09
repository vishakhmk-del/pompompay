import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_payment_plugin/flutter_payment_plugin.dart';
import 'package:intl/intl.dart';
import 'package:pompompay/core/hook/hooks.dart';
import 'package:pompompay/infrastructure/model/fare/qr_conductor_tkt/data.dart';
import 'package:pompompay/infrastructure/model/fare/qr_conductor_tkt/qr_conductor_tkt.dart';
import 'package:pompompay/infrastructure/model/fare/transactionresp/transactionresp.dart';
import 'package:sizer/sizer.dart';

class ScreenScanPay extends StatefulWidget {
  const ScreenScanPay({super.key, this.busid, this.conductorType});
  final String? busid;
  final QrConductorTkt? conductorType;
  @override
  State<ScreenScanPay> createState() => _ScreenScanPayState();
}

class _ScreenScanPayState extends State<ScreenScanPay> {
  int countkid = 0;
  int countadult = 1;
  int countstud = 0;
  int counthandi = 0;
  int discount = 0;

  Datatkt? ticketdata;
  DataVal? busdetails;
  DataValue? calcFare;
  Busdetails? busdet;
  dynamic response;
  String? formatted;
  String hash = '';
  String paymentResponse = "";
  List<Stopsdetail>? stopsdet;
  TextEditingController _adultController = TextEditingController();
  TextEditingController _kidController = TextEditingController();
  TextEditingController _studController = TextEditingController();
  // List<String> stoplst = [];
  List<Stopsdetail> stoplst = [];
  String? selectedFromList;
  String? selectedToList;
  int? selectedFromId;
  int? selectedToId;
  String? todayDt;
  String? crntTm;
  String? usrid;
  TransResponse? transRespVal;
  String? transdate;
  String? transtime;
  Sharedpref? val;
  Transactionresp? ticketStatus;
  Map<String, dynamic>? params;
  Map<String, String>? paymentData;
  List<String> hashColumns = [];
  Stopsdetail? selectedFromStop;
  Stopsdetail? selectedToStop;
  DataQrTkt? condQrData;
  bool condQrDataEnable = false;
  @override
  // void initState() {
  //   super.initState();
  //   // log(widget.busid);
  //   fetchfareDet(context);
  //   _adultController = TextEditingController(text: countadult.toString());
  //   _kidController = TextEditingController(text: countkid.toString());
  //   _studController = TextEditingController(text: countstud.toString());
  // }
  @override
  void initState() {
    super.initState();

    _adultController = TextEditingController(text: countadult.toString());

    _kidController = TextEditingController(text: countkid.toString());

    _studController = TextEditingController(text: countstud.toString());

    if (widget.conductorType != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final datenw = DateTime.now();

        todayDt = DateFormat('dd-MMM-yyyy').format(datenw);

        crntTm = DateFormat('hh:mm a').format(datenw);
        condQrData = widget.conductorType?.data;
            // Enable conductor QR mode
        condQrDataEnable = condQrData != null;

        log("Conductor QR Data = $condQrData");
        log("Conductor QR Enabled = $condQrDataEnable");

        countadult=condQrData?.adults??0;
        countkid=condQrData?.kids??0;
        countstud=condQrData?.student??0;
        counthandi=condQrData?.handicapped??0;
        discount=condQrData?.discount??0;

        _showConductorBottomSheet();
      });
    } else {
      fetchfareDet(context);
    }
  }

  void _showConductorBottomSheet() {
    if (!mounted || !condQrDataEnable || condQrData == null) {
    return;
  }
    showModalBottomSheet(
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      context: context,
      builder: (context) => buildSheet(context),
    ).whenComplete(() {
      if (!mounted) return;

      context.read<LoadingProvider>().resetAll();
    });
  }

  Future<bool?> popscreen(BuildContext context) async {
    Navigator.pushReplacement(context, Approutes().mainScreen);
    context.read<ElevatedBtnProvider>().changeSelectedVal(false);
    context.read<LoadingProvider>().resetAll();

    return true;
  }

  Future fetchfareDet(BuildContext context) async {
    final val = await SharedPrefManager.instance.getSharedData();

    setState(() {
      usrid = val?.userId ?? '';
    });

    final datenw = DateTime.now();

    todayDt = DateFormat('dd-MMM-yyyy').format(datenw);

    crntTm = DateFormat('hh:mm a').format(datenw);

    final value = Farereq(busidNo: widget.busid);

    if (!context.mounted) return;

    busdetails = await TicketFun.instance.fetchFareDet(value, context);

    if (mounted) {
      setState(() {
        busdet = busdetails?.busdetails;

        stopsdet = busdetails?.stopsdetails ?? [];

        stoplst = stopsdet!;
      });
    }
  }

  List<Stopsdetail> get filteredToStops {
    if (selectedFromStop == null) {
      return [];
    }

    final fromIndex = stoplst.indexWhere(
      (stop) => stop.stopId == selectedFromStop!.stopId,
    );

    if (fromIndex == -1 || fromIndex == stoplst.length - 1) {
      return [];
    }

    return stoplst.sublist(fromIndex + 1);
  }

  @override
  void dispose() {
    _adultController.dispose();
    _kidController.dispose();
    _studController.dispose();
    super.dispose();
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
            // Only allow going back if not loading
            // final isLoading = context.read<LoadingProvider>().isLoading;
            // if (isLoading) {
            //   log('Back button disabled while loading');
            //   return;
            // }
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
                              Navigator.pushReplacement(
                                context,
                                Approutes().mainScreen,
                              );
                              context
                                  .read<ElevatedBtnProvider>()
                                  .changeSelectedVal(false);
                              context.read<LoadingProvider>().resetAll();
                            },
                          ),
                        ),
                        Center(
                          child: Text(
                            'Get Your Ticket',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (busdetails != null) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white, // Card background
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          busdet?.busName?.toUpperCase() ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                        Text(
                                          busdet?.registrationNo ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                        Text(
                                          busdet?.tripName ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "$todayDt",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black54,
                                                  ),
                                            ),
                                            SizedBox(width: .5.w),
                                            Text(
                                              "(${busdet?.startTime ?? ''}-${busdet?.endTime ?? ''})",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black54,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Dropdowns take max width
                                      Expanded(
                                        child: Column(
                                          children: [
                                            // DropdownButtonFormField2<String>(
                                            //   isExpanded: true,
                                            //   value: selectedFromList,
                                            //   onChanged: (value) {
                                            //     setState(() {
                                            //       selectedFromList = value;
                                            //       selectedToList = null;
                                            //     });
                                            //   },
                                            //   items: stoplst.map((valueItem) {
                                            //     return DropdownMenuItem<String>(
                                            //       value: valueItem,
                                            //       child: Text(
                                            //         valueItem,
                                            //         overflow:
                                            //             TextOverflow.ellipsis,
                                            //         style: Theme.of(context)
                                            //             .textTheme
                                            //             .bodySmall
                                            //             ?.copyWith(
                                            //               fontSize: 16,
                                            //             ),
                                            //       ),
                                            //     );
                                            //   }).toList(),
                                            //   decoration: InputDecoration(
                                            //     labelText: 'From Stop',
                                            //     labelStyle: Theme.of(context)
                                            //         .textTheme
                                            //         .bodySmall
                                            //         ?.copyWith(
                                            //           fontSize: 16,
                                            //           fontWeight:
                                            //               FontWeight.bold,
                                            //         ),
                                            //     border: OutlineInputBorder(
                                            //       borderSide: BorderSide(
                                            //         color: Color(0xFFE1E1E1),
                                            //         width: 1.0,
                                            //       ),
                                            //       borderRadius:
                                            //           BorderRadius.all(
                                            //             Radius.circular(4.0),
                                            //           ),
                                            //     ),
                                            //     enabledBorder:
                                            //         OutlineInputBorder(
                                            //           borderSide: BorderSide(
                                            //             color: Color(
                                            //               0xFFE1E1E1,
                                            //             ),
                                            //             width: 1.0,
                                            //           ),
                                            //           borderRadius:
                                            //               BorderRadius.all(
                                            //                 Radius.circular(
                                            //                   4.0,
                                            //                 ),
                                            //               ),
                                            //         ),
                                            //     focusedBorder:
                                            //         OutlineInputBorder(
                                            //           borderSide: BorderSide(
                                            //             color: Color(
                                            //               0xFFE1E1E1,
                                            //             ),
                                            //             width: 2.0,
                                            //           ),
                                            //           borderRadius:
                                            //               BorderRadius.all(
                                            //                 Radius.circular(
                                            //                   4.0,
                                            //                 ),
                                            //               ),
                                            //         ),
                                            //     disabledBorder:
                                            //         OutlineInputBorder(
                                            //           borderSide: BorderSide(
                                            //             color: Color(
                                            //               0xFFE1E1E1,
                                            //             ),
                                            //             width: 1.0,
                                            //           ),
                                            //           borderRadius:
                                            //               BorderRadius.all(
                                            //                 Radius.circular(
                                            //                   4.0,
                                            //                 ),
                                            //               ),
                                            //         ),
                                            //   ),
                                            //   dropdownStyleData: DropdownStyleData(
                                            //     maxHeight: 200,
                                            //     width:
                                            //         MediaQuery.of(
                                            //           context,
                                            //         ).size.width *
                                            //         0.9,
                                            //     padding:
                                            //         const EdgeInsets.symmetric(
                                            //           horizontal: 10,
                                            //         ),
                                            //     decoration: BoxDecoration(
                                            //       color: Colors.white,
                                            //       borderRadius:
                                            //           BorderRadius.circular(8),
                                            //     ),
                                            //   ),
                                            // ),
                                            DropdownButtonFormField2<
                                              Stopsdetail
                                            >(
                                              isExpanded: true,

                                              value: selectedFromStop,

                                              onChanged: (value) {
                                                setState(() {
                                                  selectedFromStop = value;
                                                  selectedToStop = null;
                                                });

                                                // You now have BOTH ID and NAME
                                                print(
                                                  "FROM STOP ID: ${value?.stopId}",
                                                );
                                                print(
                                                  "FROM STOP NAME: ${value?.stopName}",
                                                );
                                              },

                                              items: stoplst.map((stop) {
                                                return DropdownMenuItem<
                                                  Stopsdetail
                                                >(
                                                  value: stop,
                                                  child: Text(
                                                    stop.stopName ?? '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          fontSize: 16,
                                                        ),
                                                  ),
                                                );
                                              }).toList(),

                                              decoration: InputDecoration(
                                                labelText: 'From Stop',

                                                labelStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),

                                                border:
                                                    const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(
                                                          0xFFE1E1E1,
                                                        ),
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                            Radius.circular(
                                                              4.0,
                                                            ),
                                                          ),
                                                    ),

                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(
                                                          0xFFE1E1E1,
                                                        ),
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                            Radius.circular(
                                                              4.0,
                                                            ),
                                                          ),
                                                    ),

                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(
                                                          0xFFE1E1E1,
                                                        ),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                            Radius.circular(
                                                              4.0,
                                                            ),
                                                          ),
                                                    ),

                                                disabledBorder:
                                                    const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(
                                                          0xFFE1E1E1,
                                                        ),
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                            Radius.circular(
                                                              4.0,
                                                            ),
                                                          ),
                                                    ),
                                              ),

                                              dropdownStyleData: DropdownStyleData(
                                                maxHeight: 200,

                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.9,

                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                    ),

                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 1.h),
                                            // ----- TO STOP -----
                                            Stack(
                                              children: [
                                                // The actual dropdown (disabled when From is not selected)
                                                // DropdownButtonFormField2<
                                                //   String
                                                // >(
                                                //   isExpanded: true,
                                                //   value: selectedToList,
                                                //   items: filteredToStops.map((
                                                //     valueItem,
                                                //   ) {
                                                //     return DropdownMenuItem<
                                                //       String
                                                //     >(
                                                //       value: valueItem,
                                                //       child: Text(
                                                //         valueItem,
                                                //         overflow: TextOverflow
                                                //             .ellipsis,
                                                //         style: Theme.of(context)
                                                //             .textTheme
                                                //             .bodySmall
                                                //             ?.copyWith(
                                                //               fontSize: 16,
                                                //             ),
                                                //       ),
                                                //     );
                                                //   }).toList(),
                                                //   onChanged:
                                                //       (selectedFromList == null)
                                                //       ? null // disable when From not selected (gives disabled styling)
                                                //       : (value) {
                                                //           setState(() {
                                                //             selectedToList =
                                                //                 value!;
                                                //           });
                                                //         },
                                                //   decoration: InputDecoration(
                                                //     labelText: 'To Stop',
                                                //     labelStyle:
                                                //         Theme.of(context)
                                                //             .textTheme
                                                //             .bodySmall
                                                //             ?.copyWith(
                                                //               fontSize: 16,
                                                //               fontWeight:
                                                //                   FontWeight
                                                //                       .bold,
                                                //             ),
                                                //     border:
                                                //         const OutlineInputBorder(
                                                //           borderSide:
                                                //               BorderSide(
                                                //                 color: Color(
                                                //                   0xFFE1E1E1,
                                                //                 ),
                                                //                 width: 1.0,
                                                //               ),
                                                //           borderRadius:
                                                //               BorderRadius.all(
                                                //                 Radius.circular(
                                                //                   4.0,
                                                //                 ),
                                                //               ),
                                                //         ),
                                                //     enabledBorder:
                                                //         const OutlineInputBorder(
                                                //           borderSide:
                                                //               BorderSide(
                                                //                 color: Color(
                                                //                   0xFFE1E1E1,
                                                //                 ),
                                                //                 width: 1.0,
                                                //               ),
                                                //           borderRadius:
                                                //               BorderRadius.all(
                                                //                 Radius.circular(
                                                //                   4.0,
                                                //                 ),
                                                //               ),
                                                //         ),
                                                //     disabledBorder:
                                                //         const OutlineInputBorder(
                                                //           borderSide:
                                                //               BorderSide(
                                                //                 color: Color(
                                                //                   0xFFE1E1E1,
                                                //                 ),
                                                //                 width: 1.0,
                                                //               ),
                                                //           borderRadius:
                                                //               BorderRadius.all(
                                                //                 Radius.circular(
                                                //                   4.0,
                                                //                 ),
                                                //               ),
                                                //         ),
                                                //     focusedBorder:
                                                //         const OutlineInputBorder(
                                                //           borderSide:
                                                //               BorderSide(
                                                //                 color: Color(
                                                //                   0xFFE1E1E1,
                                                //                 ),
                                                //                 width: 2.0,
                                                //               ),
                                                //           borderRadius:
                                                //               BorderRadius.all(
                                                //                 Radius.circular(
                                                //                   4.0,
                                                //                 ),
                                                //               ),
                                                //         ),
                                                //   ),
                                                //   dropdownStyleData: DropdownStyleData(
                                                //     maxHeight: 200,
                                                //     width:
                                                //         MediaQuery.of(
                                                //           context,
                                                //         ).size.width *
                                                //         0.9,
                                                //     padding:
                                                //         const EdgeInsets.symmetric(
                                                //           horizontal: 10,
                                                //         ),
                                                //     decoration: BoxDecoration(
                                                //       color: Colors.white,
                                                //       borderRadius:
                                                //           BorderRadius.circular(
                                                //             8,
                                                //           ),
                                                //     ),
                                                //   ),
                                                // ),
                                                DropdownButtonFormField2<
                                                  Stopsdetail
                                                >(
                                                  isExpanded: true,

                                                  value: selectedToStop,

                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedToStop = value;
                                                    });

                                                    print(
                                                      "TO STOP ID: ${value?.stopId}",
                                                    );
                                                    print(
                                                      "TO STOP NAME: ${value?.stopName}",
                                                    );
                                                  },

                                                  items: filteredToStops.map((
                                                    stop,
                                                  ) {
                                                    return DropdownMenuItem<
                                                      Stopsdetail
                                                    >(
                                                      value: stop,

                                                      child: Text(
                                                        stop.stopName ?? '',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                              fontSize: 16,
                                                            ),
                                                      ),
                                                    );
                                                  }).toList(),

                                                  decoration: InputDecoration(
                                                    labelText: 'To Stop',

                                                    labelStyle:
                                                        Theme.of(context)
                                                            .textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),

                                                    border:
                                                        const OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                color: Color(
                                                                  0xFFE1E1E1,
                                                                ),
                                                                width: 1.0,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  4.0,
                                                                ),
                                                              ),
                                                        ),

                                                    enabledBorder:
                                                        const OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                color: Color(
                                                                  0xFFE1E1E1,
                                                                ),
                                                                width: 1.0,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  4.0,
                                                                ),
                                                              ),
                                                        ),

                                                    focusedBorder:
                                                        const OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                color: Color(
                                                                  0xFFE1E1E1,
                                                                ),
                                                                width: 2.0,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  4.0,
                                                                ),
                                                              ),
                                                        ),

                                                    disabledBorder:
                                                        const OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                color: Color(
                                                                  0xFFE1E1E1,
                                                                ),
                                                                width: 1.0,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  4.0,
                                                                ),
                                                              ),
                                                        ),
                                                  ),

                                                  dropdownStyleData: DropdownStyleData(
                                                    maxHeight: 200,

                                                    width:
                                                        MediaQuery.of(
                                                          context,
                                                        ).size.width *
                                                        0.9,

                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                        ),

                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                // Transparent tap-catcher when From is NOT selected -> shows toast
                                                if (selectedFromStop == null)
                                                  Positioned.fill(
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                        onTap: () {
                                                          Fluttertoast.showToast(
                                                            msg:
                                                                "Please select From Stop first",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER,
                                                            backgroundColor:
                                                                Colors.white,
                                                            textColor:
                                                                Colors.red,
                                                            fontSize: 16.0,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      // SizedBox(width: 10),
                                      // // Center-aligned icon
                                      // Align(
                                      //   alignment: Alignment.center,
                                      //   child: SizedBox(
                                      //     width: 6.5.w,
                                      //     height: 6.5.h,
                                      //     child: ElevatedButton(
                                      //       style: ElevatedButton.styleFrom(
                                      //         padding: EdgeInsets.zero,
                                      //         shape: const CircleBorder(),
                                      //         backgroundColor: Colors.white,
                                      //         foregroundColor:
                                      //             Theme.of(
                                      //               context,
                                      //             ).colorScheme.primary,
                                      //         elevation: 2,
                                      //       ),
                                      //       onPressed: () {
                                      //         setState(() {
                                      //           final temp = selectedFromList;
                                      //           selectedFromList =
                                      //               selectedToList;
                                      //           selectedToList = temp;
                                      //         });
                                      //       },
                                      //       child: const Icon(
                                      //         Icons.swap_vert,
                                      //         size: 20,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),

                                  SizedBox(height: .8.h),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 40.0,
                                      right: 40,
                                    ),
                                    child: Column(
                                      children: [
                                        _buildEditableCounterRow(
                                          label: 'Adults  :',
                                          controller: _adultController,
                                          onIncrement: () {
                                            setState(() {
                                              countadult++;
                                              _adultController.text = countadult
                                                  .toString();
                                            });
                                          },
                                          onDecrement: () {
                                            if (countadult > 0) {
                                              setState(() {
                                                countadult--;
                                                _adultController.text =
                                                    countadult.toString();
                                              });
                                            }
                                          },
                                          onChanged: (value) {
                                            final val = int.tryParse(value);
                                            if (val != null) {
                                              setState(() => countadult = val);
                                            }
                                          },
                                        ),
                                        SizedBox(height: .1.h),
                                        _buildEditableCounterRow(
                                          label: 'Kids  :',
                                          controller: _kidController,
                                          onIncrement: () {
                                            setState(() {
                                              countkid++;
                                              _kidController.text = countkid
                                                  .toString();
                                            });
                                          },
                                          onDecrement: () {
                                            if (countkid > 0) {
                                              setState(() {
                                                countkid--;
                                                _kidController.text = countkid
                                                    .toString();
                                              });
                                            }
                                          },
                                          onChanged: (value) {
                                            final val = int.tryParse(value);
                                            if (val != null) {
                                              setState(() => countkid = val);
                                            }
                                          },
                                        ),
                                        SizedBox(height: .1.h),
                                        _buildEditableCounterRow(
                                          label: 'Students  :',
                                          controller: _studController,
                                          onIncrement: () {
                                            setState(() {
                                              countstud++;
                                              _studController.text = countstud
                                                  .toString();
                                            });
                                          },
                                          onDecrement: () {
                                            if (countstud > 0) {
                                              setState(() {
                                                countstud--;
                                                _studController.text = countstud
                                                    .toString();
                                              });
                                            }
                                          },
                                          onChanged: (value) {
                                            final val = int.tryParse(value);
                                            if (val != null) {
                                              setState(() => countstud = val);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 2.h),
                                  SizedBox(
                                    height: 45,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 2,
                                        backgroundColor: const Color(
                                          0xffffa600,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (selectedFromStop == null) {
                                          CommonFun.instance.showApierror(
                                            context,
                                            "please select from station",
                                          );
                                          return;
                                        }

                                        if (selectedToStop == null) {
                                          CommonFun.instance.showApierror(
                                            context,
                                            "please select destination",
                                          );
                                          return;
                                        }

                                        // You have both ID and name here
                                        final fromId = selectedFromStop!.stopId;
                                        final fromName =
                                            selectedFromStop!.stopName;

                                        final toId = selectedToStop!.stopId;
                                        final toName = selectedToStop!.stopName;

                                        print("FROM ID: $fromId");
                                        print("FROM NAME: $fromName");
                                        print("TO ID: $toId");
                                        print("TO NAME: $toName");

                                        final req = Farereq(
                                          adults: countadult.toString(),
                                          kids: countkid.toString(),
                                          stud: countstud.toString(),
                                          busId: busdet?.busid ?? '',
                                          // If API currently expects names:
                                          from: fromId,
                                          to: toId,
                                          tripId: busdet?.tripId ?? '',
                                          userId: usrid,
                                        );

                                        calcFare = await TicketFun.instance
                                            .calculateFare(req, context);

                                        if (!context.mounted) return;

                                        showModalBottomSheet(
                                          enableDrag: true,
                                          isDismissible: true,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(10),
                                            ),
                                          ),
                                          context: context,
                                          builder: (context) =>
                                              buildSheet(context),
                                        ).whenComplete(() {
                                          if (!context.mounted) return;

                                          context
                                              .read<LoadingProvider>()
                                              .resetAll();
                                        });
                                      },
                                      child: Text(
                                        'Get Fare',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    // ElevatedButton(
                                    //   style: ElevatedButton.styleFrom(
                                    //     elevation: 2,
                                    //     backgroundColor: const Color(
                                    //       0xffffa600,
                                    //     ),
                                    //     shape: RoundedRectangleBorder(
                                    //       borderRadius: BorderRadius.circular(
                                    //         10,
                                    //       ),
                                    //     ),
                                    //   ),
                                    //   onPressed: () async {
                                    //     if (selectedFromList == null) {
                                    //       CommonFun.instance.showApierror(
                                    //         context,
                                    //         "please select from station",
                                    //       );
                                    //     } else if (selectedToList == null) {
                                    //       CommonFun.instance.showApierror(
                                    //         context,
                                    //         "please select destination",
                                    //       );
                                    //     } else {
                                    //       final req = Farereq(
                                    //         adults: countadult.toString(),
                                    //         kids: countkid.toString(),
                                    //         stud: countstud.toString(),
                                    //         busId: busdet?.busid ?? '',
                                    //         from: selectedFromList,
                                    //         to: selectedToList,
                                    //         tripId: busdet?.tripId ?? '',
                                    //         userId: usrid,
                                    //       );
                                    //       calcFare = await TicketFun.instance
                                    //           .calculateFare(req, context);
                                    //       if (!context.mounted) return;
                                    //       showModalBottomSheet(
                                    //         enableDrag: true,
                                    //         isDismissible: true,
                                    //         isScrollControlled: true,
                                    //         //backgroundColor: const Color(0xff00c7c8),
                                    //         //Color.fromARGB(255, 6, 173, 162),
                                    //         shape: const RoundedRectangleBorder(
                                    //           borderRadius:
                                    //               BorderRadius.vertical(
                                    //                 top: Radius.circular(10),
                                    //               ),
                                    //         ),

                                    //         context: context,
                                    //         builder: (context) =>
                                    //             buildSheet(context),
                                    //       ).whenComplete(() {
                                    //         // Reset the button state when bottom sheet is closed
                                    //         if (!context.mounted) return;
                                    //         context
                                    //             .read<LoadingProvider>()
                                    //             .resetAll();
                                    //       });
                                    //     }
                                    //   },
                                    //   child: Text(
                                    //     'Get Fare',
                                    //     style: Theme.of(context)
                                    //         .textTheme
                                    //         .titleMedium
                                    //         ?.copyWith(
                                    //           color: Colors.white,
                                    //           fontWeight: FontWeight.bold,
                                    //         ),
                                    //   ),
                                    // ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    FutureBuilder(
                      future: Future.delayed(
                        const Duration(seconds: 15),
                      ), // Add a delay of 5 seconds
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height / 2.8,
                                horizontal:
                                    MediaQuery.of(context).size.width / 2.3,
                              ),
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          );
                        } else {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height / 2.5,
                                horizontal:
                                    MediaQuery.of(context).size.width / 4,
                              ),
                              child: Text(
                                'No acitve trip found',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        Consumer<LoadingProvider>(
          builder: (context, loadingProvider, child) {
            if (!loadingProvider.isLoading) return const SizedBox.shrink();

            return PopScope(
              canPop: false,
              child: AbsorbPointer(
                absorbing: true,
                child: Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEditableCounterRow({
    required String label,
    required TextEditingController controller,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onDecrement,
            icon: const Icon(Icons.remove_circle_outline),
            splashRadius: 25,
            color: Colors.redAccent,
          ),
          SizedBox(
            width: 40,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              onChanged: onChanged,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                //border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 18.sp),
            ),
          ),
          IconButton(
            onPressed: onIncrement,
            icon: const Icon(Icons.add_circle_outline),
            splashRadius: 25,
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget buildSheet(BuildContext parentContext) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),

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
        initialChildSize: 0.55, // 50% of screen height initially
        // minChildSize: 0.3, // Min height when collapsed
        // maxChildSize: 1.0, // Max height when fully expanded
        expand: false, // Allows dragging to control height
        builder: (context, scrollController) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 15,
                  //bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ticket Summary',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 10),
                    Expanded(
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
                                child: Column(
                                  children: [
                                    /// Header info
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              condQrDataEnable == false
                                                  ? busdet?.busName
                                                            ?.toUpperCase() ??
                                                        ''
                                                  : condQrData?.busName
                                                            ?.toUpperCase() ??
                                                        '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              condQrDataEnable == false
                                                  ? busdet?.registrationNo ?? ''
                                                  : condQrData?.regNo ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                              condQrDataEnable == false
                                                  ? busdet?.tripName ?? ''
                                                  : condQrData?.tripName ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                        const SizedBox(height: 2),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              todayDt ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              crntTm ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        
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
                                              condQrDataEnable == false
                                                  ?  selectedFromStop?.stopName ??''
                                                  :  condQrData?.fromPlace ?? '',
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
                                               condQrDataEnable == false
                                                  ? selectedToStop?.stopName ?? ''
                                                  : condQrData?.toPlace ??'',
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

                                    /// Separator line (simulated dotted separator)
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
                                            if (countadult != 0)
                                              TableRow(
                                                children: [
                                                  _buildFareCell(
                                                    context,
                                                    "Full :",
                                                  ),
                                                  _buildFareCell(
                                                    context,
                                                    "$countadult",
                                                  ),
                                                  _buildFareCell(context, "x"),
                                                 condQrDataEnable == false
                                                  ? _buildFareCell(
                                                    context,
                                                    calcFare?.singleadult ?? '',
                                                  ):_buildFareCell(
                                                    context,
                                                    condQrData?.singleAdult ?? '',
                                                  ),
                                                  _buildFareCell(context, "="),
                                                condQrDataEnable == false
                                                  ?  _buildFareCell(
                                                    context,
                                                    calcFare?.adultFare ?? '',
                                                  ):_buildFareCell(
                                                    context,
                                                    condQrData?.adultAmount ?? '',
                                                  )
                                                ],
                                              ),
                                            if (countkid != 0)
                                              TableRow(
                                                children: [
                                                  _buildFareCell(
                                                    context,
                                                    "Kids :",
                                                  ),
                                                  _buildFareCell(
                                                    context,
                                                    "$countkid",
                                                  ),
                                                  _buildFareCell(context, "x"),
                                               condQrDataEnable == false
                                                  ?   _buildFareCell(
                                                    context,
                                                    calcFare?.singlekid ?? '',
                                                  ): _buildFareCell(
                                                    context,
                                                    condQrData?.singleKid ?? '',
                                                  ),
                                                  _buildFareCell(context, "="),
                                                 condQrDataEnable == false
                                                  ?  _buildFareCell(
                                                    context,
                                                    calcFare?.kidsFare ?? '',
                                                  ):_buildFareCell(
                                                    context,
                                                    condQrData?.kidAmount ?? '',
                                                  )
                                                ],
                                              ),
                                            if (countstud != 0)
                                              TableRow(
                                                children: [
                                                  _buildFareCell(
                                                    context,
                                                    "Students :",
                                                  ),
                                                  _buildFareCell(
                                                    context,
                                                    "$countstud",
                                                  ),
                                                  _buildFareCell(context, "x"),
                                                condQrDataEnable == false
                                                  ?   _buildFareCell(
                                                    context,
                                                    calcFare?.singlestud ?? '',
                                                  ): _buildFareCell(
                                                    context,
                                                    condQrData?.singleStudent ?? '',
                                                  ),
                                                  _buildFareCell(context, "="),
                                                condQrDataEnable == false
                                                  ?   _buildFareCell(
                                                    context,
                                                    calcFare?.studentFare ?? '',
                                                  ):
                                                   _buildFareCell(
                                                    context,
                                                    condQrData?.studentAmount.toString() ?? '',
                                                  )
                                                ],
                                              ),
                                              if (discount != 0)
                                              TableRow(
                                                children: [
                                                  _buildFareCell(
                                                    context,
                                                    "discount ",
                                                  ),
                                                   _buildFareCell(
                                                    context,
                                                    "",
                                                  ),
                                                  _buildFareCell(context, ""),
                                                  _buildFareCell(
                                                    context,
                                                     "",
                                                  ),
                                                  _buildFareCell(context, "="),
                                                  
                                                   _buildFareCell(
                                                    context,
                                                    condQrData!.discount.toString(),
                                                  )
                                                ],
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          condQrDataEnable == false
                                                  ?"Rs ${calcFare?.totalFare}.0"
                                                  :"Rs ${condQrData?.totalAmt.toString()}.0",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        SizedBox(height: .3.h),

                                        SizedBox(
                                          height: 40,
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 2,
                                              backgroundColor: const Color(
                                                0xffffa600,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () async {
                                              final loadingProvider =
                                                  Provider.of<LoadingProvider>(
                                                    context,
                                                    listen: false,
                                                  );
                                              if (!loadingProvider.isLoading) {
                                                if (!context.mounted) return;
                                                await initiateOmniwarePayment(
                                                  context,
                                                );
                                              } else {
                                                CommonFun.instance.showApierror(
                                                  context,
                                                  "Please wait while your request is being processed.",
                                                );
                                              }
                                            },

                                            child:
                                              
                                                Text(
                                                  'Proceed',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                            
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
                  ],
                ),
              ),
            ),
          );
        },
      ),
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

  Map<String, dynamic> generatePaymentParams(Map<String, dynamic> data) {
    // Concatenate data to generate hash
    if (Platform.isAndroid) {
      hashColumns = [
        'salt',
        'address_line_1',
        'address_line_2',
        'amount',
        'api_key',
        'city',
        'country',
        'currency',
        'description',
        'email',
        "enable_auto_refund",
        'mode',
        'name',
        'order_id',
        'phone',
        'return_url',
        'state',
        'zip_code',
      ];
    } else if (Platform.isIOS) {
      hashColumns = [
        'salt',
        'address_line_1',
        'address_line_2',
        'amount',
        'api_key',
        'city',
        'country',
        'currency',
        'description',
        'email',
        "enable_auto_refund",
        'interface_type',
        'mode',
        'name',
        'order_id',
        'phone',
        'return_url',
        'state',
        'zip_code',
      ];
    }

    // hashColumns.sort();
    // String hashData = '';

    // for (final column in hashColumns) {
    //   final value = data[column];
    //   if (value != null && value.toString().trim().isNotEmpty) {
    //     hashData += '|${value.toString().trim()}';
    //   }
    // }
    // log("iOS HASH DATA => $hashData");
    String hashData = data['salt'].toString().trim(); // START WITH SALT

    for (final column in hashColumns) {
      if (column == 'salt') continue; // skip salt, already added

      final value = data[column];
      if (value != null && value.toString().trim().isNotEmpty) {
        hashData += '|${value.toString().trim()}';
      }
    }

    log("iOS HASH DATA => $hashData");

    final bytes = utf8.encode(hashData);
    hash = sha512.convert(bytes).toString().toUpperCase();
    log("FINAL iOS HASH => $hash");

    return {...data, 'hash': hash};
  }

  // Map<String, dynamic> generatePaymentParams(Map<String, dynamic> data) {
  //   final List<String> hashColumns = Platform.isIOS
  //       ? [
  //           'salt_key',
  //           'address_line_1',
  //           'address_line_2',
  //           'amount',
  //           'api_key',
  //           'city',
  //           'country',
  //           'currency',
  //           'description',
  //           'email',
  //           'enable_auto_refund',
  //           'interface_type',
  //           'mode',
  //           'name',
  //           'order_id',
  //           'phone',
  //           'return_url',
  //           'state',
  //           'udf1',
  //           'udf2',
  //           'udf3',
  //           'udf4',
  //           'udf5',
  //           'zip_code',
  //         ]
  //       : [
  //           'salt_key',
  //           'address_line_1',
  //           'address_line_2',
  //           'amount',
  //           'api_key',
  //           'city',
  //           'country',
  //           'currency',
  //           'description',
  //           'email',
  //           'enable_auto_refund',
  //           'mode',
  //           'name',
  //           'order_id',
  //           'phone',
  //           'return_url',
  //           'state',
  //           'udf1',
  //           'udf2',
  //           'udf3',
  //           'udf4',
  //           'udf5',
  //           'zip_code',
  //         ];

  //       final buffer = StringBuffer();

  //       for (int i = 0; i < hashColumns.length; i++) {
  //         final key = hashColumns[i];
  //         final value = data[key]?.toString().trim() ?? '';

  //         if (i == 0) {
  //           buffer.write(value);
  //         } else {
  //           buffer.write('|$value');
  //         }
  //       }

  //       final hash = sha512
  //           .convert(utf8.encode(buffer.toString()))
  //           .toString()
  //           .toUpperCase();

  //       log("OMNIWARE HASH STRING => ${buffer.toString()}");
  //       log("FINAL HASH => $hash");

  //   return {...data, 'hash': hash};
  // }

  Future<void> initiateOmniwarePayment(BuildContext context) async {
    try {
      val = await SharedPrefManager.instance.getSharedData();
      if (Platform.isAndroid) {
        //*_____________________LIVE_________________________*
      //   condQrDataEnable==false
      //  ? paymentData = {
      //     "salt": busdet?.saltKey ?? '',
      //     "address_line_1": "test",
      //     "address_line_2": "text",
      //     "amount": calcFare?.totalFare ?? '',
      //     // "amount": double.parse(calcFare?.totalFare.toString() ?? '0').toStringAsFixed(2),
      //     // "amount": "2",
      //     "api_key": busdet?.upid?.trim() ?? '',
      //     "city": busdet?.city ?? '',
      //     "country": busdet?.country ?? '',
      //     "currency": "INR",
      //     "description": "bus ticket payment",
      //     "email": busdet?.emailId ?? '',
      //     "enable_auto_refund": "n",
      //     "mode": "LIVE",
      //     "name": val?.name ?? '',
      //     "order_id": "TKT${DateTime.now().millisecondsSinceEpoch}",
      //     "phone": busdet?.mobileNo ?? '',
      //     "return_url": "https://pgbiz.omniware.in/tnpv2/return_page.php",
      //     "state": busdet?.state ?? '',
      //     // "udf1": "",
      //     // "udf2": "",
      //     // "udf3": "",
      //     // "udf4": "",
      //     // "udf5": "",
      //     "zip_code": busdet?.zip ?? '',
      //   }:paymentData = {
      //     "salt": condQrData?.saltKey ?? '',
      //     "address_line_1": "test",
      //     "address_line_2": "text",
      //     "amount": condQrData?.totalAmt.toString() ?? '',
      //     // "amount": double.parse(calcFare?.totalFare.toString() ?? '0').toStringAsFixed(2),
      //     // "amount": "2",
      //     "api_key": condQrData?.apiKey?.trim() ?? '',
      //     "city": condQrData?.city ?? '',
      //     "country": condQrData?.country ?? '',
      //     "currency": "INR",
      //     "description": "bus ticket payment",
      //     "email": condQrData?.email ?? '',
      //     "enable_auto_refund": "n",
      //     "mode": "LIVE",
      //     "name": val?.name ?? '',
      //     "order_id": "TKT${DateTime.now().millisecondsSinceEpoch}",
      //     "phone": condQrData?.phone ?? '',
      //     "return_url": "https://pgbiz.omniware.in/tnpv2/return_page.php",
      //     "state": condQrData?.state ?? '',
      //     // "udf1": "",
      //     // "udf2": "",
      //     // "udf3": "",
      //     // "udf4": "",
      //     // "udf5": "",
      //     "zip_code": condQrData?.zip ?? '',
      //   };

        //*_____________________***_________________________*

        //*_____________________TEST_________________________*

        condQrDataEnable==false
       ?paymentData = {
          "salt": "80c67bfdf027da08de88ab5ba903fecafaab8f6d",
          "address_line_1": "test",
          "address_line_2": "text",
          "amount": calcFare?.totalFare ?? '',
          "api_key": 'fb6bca86-b429-4abf-a42f-824bdd29022e',
          "city": busdet?.city ?? '',
          "country": busdet?.country ?? '',
          "currency": "INR",
          "description": "bus ticket payment",
          "email": 'rsn7rohith@gmail.com',
          "enable_auto_refund": "n",
          "mode": "TEST",
          "name": 'Rohith Test',
          "order_id": "TKT${DateTime.now().millisecondsSinceEpoch}",
          "phone": '9745528173',
          "return_url": "https://pgbiz.omniware.in/tnpv2/return_page.php",
          "state": busdet?.state ?? '',
          "zip_code": busdet?.zip ?? '',
          // Optional: Use real phone number if available
        }:
        paymentData = {
          "salt": "80c67bfdf027da08de88ab5ba903fecafaab8f6d",
          "address_line_1": "test",
          "address_line_2": "text",
          "amount": condQrData?.totalAmt ?? '',
          "api_key": 'fb6bca86-b429-4abf-a42f-824bdd29022e',
          "city": condQrData?.city ?? '',
          "country": condQrData?.country ?? '',
          "currency": "INR",
          "description": "bus ticket payment",
          "email": 'rsn7rohith@gmail.com',
          "enable_auto_refund": "n",
          "mode": "TEST",
          "name": 'Rohith Test',
          "order_id": "TKT${DateTime.now().millisecondsSinceEpoch}",
          "phone": '9745528173',
          "return_url": "https://pgbiz.omniware.in/tnpv2/return_page.php",
          "state": condQrData?.state ?? '',
          "zip_code": condQrData?.zip ?? '',
          // Optional: Use real phone number if available
        };

        //*_____________________***_________________________*
      } else if (Platform.isIOS) {
        //*_____________________LIVE_________________________*
      //  condQrDataEnable==false
      //  ? paymentData = {
      //     "salt": busdet?.saltKey ?? '',
      //     "address_line_1": "test",
      //     "address_line_2": "text",
      //     "amount": calcFare?.totalFare ?? '',
      //     // "amount": "2",
      //     "api_key": busdet?.upid?.trim() ?? '',
      //     "city": busdet?.city ?? '',
      //     "country": busdet?.country ?? '',
      //     "currency": "INR",
      //     "description": "bus ticket payment",
      //     "email": busdet?.emailId ?? '',
      //     "enable_auto_refund": "n",
      //     "interface_type": "ios_sdk",
      //     "mode": "LIVE",
      //     "name": val?.name ?? '',
      //     "order_id": "TKT${DateTime.now().millisecondsSinceEpoch}",
      //     "phone": busdet?.mobileNo ?? '',
      //     "return_url": "https://pgbiz.omniware.in/tnpv2/return_page.php",
      //     "state": busdet?.state ?? '',
      //     // "udf1": "",
      //     // "udf2": "",
      //     // "udf3": "",
      //     // "udf4": "",
      //     // "udf5": "",
      //     "zip_code": busdet?.zip ?? '',
      //   }:paymentData = {
      //     "salt": condQrData?.saltKey ?? '',
      //     "address_line_1": "test",
      //     "address_line_2": "text",
      //     "amount": condQrData?.totalAmt.toString() ?? '',
      //     // "amount": "2",
      //     "api_key": condQrData?.apiKey?.trim() ?? '',
      //     "city": condQrData?.city ?? '',
      //     "country": condQrData?.country ?? '',
      //     "currency": "INR",
      //     "description": "bus ticket payment",
      //     "email": condQrData?.email ?? '',
      //     "enable_auto_refund": "n",
      //     "interface_type": "ios_sdk",
      //     "mode": "LIVE",
      //     "name": val?.name ?? '',
      //     "order_id": "TKT${DateTime.now().millisecondsSinceEpoch}",
      //     "phone": condQrData?.phone ?? '',
      //     "return_url": "https://pgbiz.omniware.in/tnpv2/return_page.php",
      //     "state": condQrData?.state ?? '',
      //     // "udf1": "",
      //     // "udf2": "",
      //     // "udf3": "",
      //     // "udf4": "",
      //     // "udf5": "",
      //     "zip_code": condQrData?.zip ?? '',
      //   };

        //*_____________________***_________________________*

        //*_____________________TEST_________________________*

       condQrDataEnable==false
       ? paymentData = {
          "salt": "80c67bfdf027da08de88ab5ba903fecafaab8f6d",
          "address_line_1": "test",
          "address_line_2": "text",
          "amount": calcFare?.totalFare ?? '',
          "api_key": 'fb6bca86-b429-4abf-a42f-824bdd29022e',
          "city": busdet?.city ?? '',
          "country": busdet?.country ?? '',
          "currency": "INR",
          "description": "bus ticket payment",
          "email": 'rsn7rohith@gmail.com',
          "enable_auto_refund": "n",
          "interface_type": "ios_sdk",
          "mode": "TEST",
          "name": 'Rohith Test',
          "order_id": "TKT${DateTime.now().millisecondsSinceEpoch}",
          "phone": '9745528173',
          "return_url": "https://pgbiz.omniware.in/tnpv2/return_page.php",
          "state": busdet?.state ?? '',
          "zip_code": busdet?.zip ?? '',
          // Optional: Use real phone number if available
        }:paymentData = {
          "salt": "80c67bfdf027da08de88ab5ba903fecafaab8f6d",
          "address_line_1": "test",
          "address_line_2": "text",
          "amount": condQrData?.totalAmt ?? '',
          "api_key": 'fb6bca86-b429-4abf-a42f-824bdd29022e',
          "city": condQrData?.city ?? '',
          "country": condQrData?.country ?? '',
          "currency": "INR",
          "description": "bus ticket payment",
          "email": 'rsn7rohith@gmail.com',
          "enable_auto_refund": "n",
          "interface_type": "ios_sdk",
          "mode": "TEST",
          "name": 'Rohith Test',
          "order_id": "TKT${DateTime.now().millisecondsSinceEpoch}",
          "phone": '9745528173',
          "return_url": "https://pgbiz.omniware.in/tnpv2/return_page.php",
          "state": condQrData?.state ?? '',
          "zip_code": condQrData?.zip ?? '',
          // Optional: Use real phone number if available
        };

        //*_____________________***_________________________*
      }
      final now = DateTime.now();

      transdate = DateFormat("yyyy-MM-dd").format(now);
      transtime = DateFormat("h:mm:ss a").format(now);

      log("transdate: $transdate");
      log("transtime: $transtime");
      params = generatePaymentParams(paymentData!);
      //final value = await SharedPrefManager.instance.getSharedData();
      final tktreq =condQrDataEnable==false
      ? TicketsaveReq(
        tripId: busdet?.tripId ?? '',
        busid: busdet?.busid ?? '',
        approvalRefNo: transRespVal?.transactionId ?? '',
        frmselected: selectedFromStop!.stopId,
        toselected: selectedToStop!.stopId,
        adultsselected: countadult,
        kidsselected: countkid,
        handiselected: counthandi,
        studselected: countstud,
        userId: val?.userId ?? '',
        userName: val?.name ?? '',
        phoneNo: val?.mobno ?? "",
        merchantCode: busdet?.mercntCode ?? "",
        amount: calcFare?.totalFare ?? "0",
        adultFare: calcFare?.adultFare ?? "0",
        kidsFare: calcFare?.kidsFare ?? "0",
        studentSingleFare: calcFare?.singlestud ?? "0",
        handiSingleFare: calcFare?.handicappedFare ?? "0",
        orderId: params?["order_id"] ?? '',
        paymentMode: transRespVal?.paymentMode ?? '',
        paymentChannel: transRespVal?.paymentChannel ?? '',
        paymentDatetime: transRespVal?.paymentDatetime ?? '',
        responseCode: transRespVal?.responseCode,
        responseMessage: transRespVal?.responseMessage ?? '',
        errorDesc: transRespVal?.errorDesc ?? '',
        cardMasked: transRespVal?.cardmasked ?? '',
        reqTime: transtime,
      ):TicketsaveReq(
        tripId: condQrData?.tripId ?? '',
        busid: condQrData?.busId ?? '',
        approvalRefNo: transRespVal?.transactionId ?? '',
        frmselected: condQrData!.fromPlaceid,
        toselected: condQrData!.toPlaceid,
        adultsselected: countadult,
        kidsselected: countkid,
        handiselected: counthandi,
        studselected: countstud,
        userId: val?.userId ?? '',
        userName: val?.name ?? '',
        phoneNo: val?.mobno ?? "",
        merchantCode: condQrData?.merchantCode ?? "",
        amount: condQrData?.totalAmt ?? "0",
        adultFare: condQrData?.adultAmount ?? "0",
        kidsFare: condQrData?.kidAmount ?? "0",
        studentSingleFare: condQrData?.singleStudent ?? "0",
        handiSingleFare: condQrData?.singleHandi ?? "0",
        orderId: params?["order_id"] ?? '',
        paymentMode: transRespVal?.paymentMode ?? '',
        paymentChannel: transRespVal?.paymentChannel ?? '',
        paymentDatetime: transRespVal?.paymentDatetime ?? '',
        responseCode: transRespVal?.responseCode,
        responseMessage: transRespVal?.responseMessage ?? '',
        errorDesc: transRespVal?.errorDesc ?? '',
        cardMasked: transRespVal?.cardmasked ?? '',
        reqTime: transtime,
      );
      if (!context.mounted) return;
      ticketdata = await TicketFun.instance.ticketSave(tktreq, context);
      // setState(() => _isLoading = false);
      if(ticketdata!=null){
        if (!context.mounted) return;
        open(params, context);
      }else{
        if (!context.mounted) return;

        ticketGenerationFailedPopup(context);
      }
      
    } catch (e, st) {
      debugPrint("Payment error: $e");
      debugPrint('Stack trace: $st');
    }
  }

  // void open(Map<String, dynamic>? request, BuildContext context) async {
  //   try {
  //     log("Request Params => $request");

  //     final stringParams = convertToStringMap(request!);

  //     response = await FlutterPaymentPlugin.openPayment(
  //       url: "https://pgbiz.omniware.in",
  //       params: stringParams,
  //       title: 'Payment',
  //       javaScript: true,
  //     );

  //     // response = await PaymentGatewayPlugin.open(
  //     //   "https://pgbiz.omniware.in",
  //     //   request,
  //     // );

  //     if (response != null) {
  //       log("Response => $response");
  //       //final status="${response['status']}";
  //       final message = "${response['message']}";
  //       if (response['response'] == null) {
  //         log("Payment was cancelled by the user");
  //         if (!context.mounted) return;
  //         transCncl(context, request, 0);
  //       } else {
  //         // final resp = "${response['response']}";
  //         //final code="${response['code']}";
  //         dynamic rawResp = response['response'];

  //         Map<String, dynamic> resultAsJson;

  //         // ANDROID → response is JSON string
  //         if (rawResp is String) {
  //           resultAsJson = jsonDecode(rawResp);
  //         }
  //         // IOS → response is already a Map
  //         else if (rawResp is Map) {
  //           resultAsJson = Map<String, dynamic>.from(rawResp);
  //         } else {
  //           throw Exception("Unexpected response format");
  //         }

  //         transRespVal = TransResponse.fromJson(resultAsJson);

  //         // final resultAsJson = jsonDecode(resp.toString());
  //         // transRespVal = TransResponse.fromJson(
  //         //   resultAsJson as Map<String, dynamic>,
  //         // );

  //         final dttime = transRespVal?.paymentDatetime;
  //         DateTime parsed = DateTime.parse(dttime ?? '');

  //         formatted = DateFormat("yyyy-MM-dd h:mm:ss a").format(parsed);
  //         log(formatted ?? '');
  //         if (formatted != null) {
  //           List<String> parts = formatted!.split(' ');
  //           transdate = parts[0];
  //           transtime = '${parts[1]} ${parts[2]}';
  //           log(transdate ?? 'null');
  //           log(transtime ?? 'null');
  //         } else {
  //           transdate = '';
  //           transtime = '';
  //         }
  //         //final validHash = hash == transRespVal?.hash ? "Yes" : "No";
  //         final respcode =
  //             int.tryParse(transRespVal?.responseCode.toString() ?? '') ?? 0;
  //         final respmsg = transRespVal?.responseMessage ?? '';
  //         final status = (respcode == 0)
  //             ? "success"
  //             : (respcode == 1000)
  //             ? "failed"
  //             : (respcode == 1006)
  //             ? "WAITING-BANK-RESPONSE"
  //             : (respcode == 1015)
  //             ? "INSUFFICIENT-FUND"
  //             : (respcode == 1030)
  //             ? "TRANSACTION-INCOMPLETE"
  //             : "unknown";
  //         if (status == "success") {
  //           log("success resp");
  //           log(respmsg);
  //           final val = await SharedPrefManager.instance.getSharedData();
  //           final tktreq = TicketsaveReq(
  //             approvalRefNo: transRespVal?.transactionId ?? '',
  //             userId: val?.userId ?? '',
  //             userName: val?.name ?? '',
  //             phoneNo: val?.mobno ?? "",
  //             merchantCode: busdet?.mercntCode ?? "",
  //             orderId: transRespVal?.orderId ?? '',
  //             paymentMode: transRespVal?.paymentMode ?? '',
  //             paymentChannel: transRespVal?.paymentChannel ?? '',
  //             paymentDatetime: transRespVal?.paymentDatetime ?? '',
  //             responseCode:
  //                 int.tryParse(transRespVal?.responseCode.toString() ?? '') ??
  //                 0,
  //             responseMessage: transRespVal?.responseMessage ?? '',
  //             errorDesc: transRespVal?.errorDesc ?? '',
  //             cardMasked: transRespVal?.cardmasked ?? '',
  //           );
  //           if (!context.mounted) return;
  //           await TicketFun.instance.paymentStatusUpdt(tktreq, context);

  //           if (!context.mounted) return;
  //           transBox(context, transRespVal, respcode, respmsg);
  //         } else {
  //           log("failed resp");
  //           log(message);
  //           final val = await SharedPrefManager.instance.getSharedData();
  //           final tktreq = TicketsaveReq(
  //             approvalRefNo: transRespVal?.transactionId ?? '',
  //             userId: val?.userId ?? '',
  //             userName: val?.name ?? '',
  //             phoneNo: val?.mobno ?? "",
  //             merchantCode: busdet?.mercntCode ?? "",
  //             orderId: transRespVal?.orderId ?? '',
  //             paymentMode: transRespVal?.paymentMode ?? '',
  //             paymentChannel: transRespVal?.paymentChannel ?? '',
  //             paymentDatetime: transRespVal?.paymentDatetime ?? '',
  //             responseCode:
  //                 int.tryParse(transRespVal?.responseCode.toString() ?? '') ??
  //                 0,
  //             responseMessage: transRespVal?.responseMessage ?? '',
  //             errorDesc: transRespVal?.errorDesc ?? '',
  //             cardMasked: transRespVal?.cardmasked ?? '',
  //           );
  //           if (!context.mounted) return;
  //           await TicketFun.instance.paymentStatusUpdt(tktreq, context);
  //           if (!context.mounted) return;
  //           transBox(context, transRespVal, respcode, respmsg);
  //         }
  //       }
  //     } else {
  //       setState(() {
  //         paymentResponse = "No response received from the payment gateway.";
  //         log(paymentResponse);
  //       });
  //     }
  //   } on PlatformException {
  //     setState(() {
  //       paymentResponse = 'Failed to initiate payment.';
  //     });
  //   }
  // }
  void open(Map<String, dynamic>? request, BuildContext context) async {
    try {
      log("Request Params => $request");

      final stringParams = convertToStringMap(request!);

      PaymentResult? response = await FlutterPaymentPlugin.openPayment(
        url: "https://pgbiz.omniware.in",
        params: stringParams,
        title: 'Payment',
        // javaScript: true,
      );
      if (response.cancelled == true) {
        log("Payment cancelled by user");
        if (!context.mounted) return;
        transCncl(context, request, 0);
        return;
      }

      if (response.data == null) {
        log("Payment cancelled by user");
        if (!context.mounted) return;
        transCncl(context, request, 0);
      } else {
        // dynamic rawResp = response.data;
        // Map<String, dynamic> respJson;

        // if (rawResp is String) {
        //   respJson = jsonDecode(rawResp);
        // } else if (rawResp is Map) {
        //   respJson = Map<String, dynamic>.from(rawResp);
        // } else {
        //   throw Exception("Unknown payment response format");
        // }

        // log("Raw Gateway Response => $respJson");

        // final normalized = <String, dynamic>{
        //   "transaction_id": respJson["transaction_id"],
        //   "order_id": respJson["order_id"],
        //   "payment_mode": respJson["payment_mode"],
        //   "payment_channel": respJson["payment_channel"],
        //   "payment_datetime": respJson["payment_datetime"],
        //   "response_code":
        //       int.tryParse(respJson["response_code"].toString()) ?? -1,
        //   "response_message": respJson["response_message"] ?? "",
        //   "error_desc": respJson["error_desc"] ?? "",
        //   "amount": respJson["amount"],
        //   "currency": respJson["currency"],
        //   "hash": respJson["hash"],
        //   "customer_name": respJson["customer_name"] ?? respJson["name"] ?? "",
        //   "customer_phone":
        //       respJson["customer_phone"] ?? respJson["phone"] ?? "",
        //   "customer_email":
        //       respJson["customer_email"] ?? respJson["email"] ?? "",
        //   "cardmasked": respJson["cardmasked"] ?? "",
        //   "bank_ref_id": respJson["bank_ref_id"] ?? "",
        //   "authorization_status": respJson["authorization_staus"] ?? "captured",
        // };

        // final transRespVal = Transactionresp.fromJson(normalized);
        // DateTime? parsedDate;
        // try {
        //   parsedDate = DateTime.parse(transRespVal.paymentDatetime ?? "");
        // } catch (_) {
        //   log("not valid format");
        // }

        dynamic rawResp = response.data;
        Map<String, dynamic> respJson;

        if (rawResp is String) {
          respJson = Map<String, dynamic>.from(jsonDecode(rawResp));
        } else if (rawResp is Map) {
          respJson = Map<String, dynamic>.from(rawResp);
        } else {
          throw Exception("Unknown payment response format");
        }

        log("Raw Gateway Response => $respJson");

        // Extract payment data from "data" array
        final data = respJson["data"];

        if (data is! List || data.isEmpty || data[0] is! Map) {
          throw Exception("Invalid payment response: data is missing or empty");
        }

        final paymentData = Map<String, dynamic>.from(data[0]);

        log("Payment Data => $paymentData");

        final normalized = <String, dynamic>{
          "transaction_id": paymentData["transaction_id"],
          "order_id": paymentData["order_id"],
          "payment_mode": paymentData["payment_mode"],
          "payment_channel": paymentData["payment_channel"],
          "payment_datetime": paymentData["payment_datetime"],
          "response_code":
              int.tryParse(paymentData["response_code"].toString()) ?? -1,
          "response_message": paymentData["response_message"] ?? "",
          "error_desc": paymentData["error_desc"] ?? "",
          "amount": paymentData["amount"],
          "currency": paymentData["currency"],
          "hash": respJson["hash"], // hash is OUTSIDE data
          "customer_name":
              paymentData["customer_name"] ?? paymentData["name"] ?? "",
          "customer_phone":
              paymentData["customer_phone"] ?? paymentData["phone"] ?? "",
          "customer_email":
              paymentData["customer_email"] ?? paymentData["email"] ?? "",
          "cardmasked": paymentData["cardmasked"] ?? "",
          "bank_ref_id": paymentData["bank_ref_id"] ?? "",
          "authorization_status":
              paymentData["authorization_staus"] ?? "captured",
        };

        log("Normalized Response => $normalized");

        final transRespVal = Transactionresp.fromJson(normalized);

        DateTime? parsedDate;

        try {
          parsedDate = DateTime.parse(transRespVal.paymentDatetime ?? "");
        } catch (_) {
          log("Invalid payment date format");
        }

        if (parsedDate != null) {
          formatted = DateFormat("yyyy-MM-dd h:mm:ss a").format(parsedDate);
          final parts = formatted!.split(" ");
          transdate = parts[0];
          transtime = "${parts[1]} ${parts[2]}";
        }

        final respCode = transRespVal.responseCode ?? -1;
        final respMsg = transRespVal.responseMessage ?? "";

        final status = respCode == 0
            ? "success"
            : respCode == 1000
            ? "failed"
            : respCode == 1006
            ? "WAITING-BANK-RESPONSE"
            : respCode == 1015
            ? "INSUFFICIENT-FUND"
            : respCode == 1030
            ? "TRANSACTION-INCOMPLETE"
            : "unknown";

        if (status == "success") {
          log("success resp");
          // log(respmsg);
          final val = await SharedPrefManager.instance.getSharedData();
          final tktreq = TicketsaveReq(
            approvalRefNo: transRespVal.transactionId ?? "",
            userId: val?.userId ?? "",
            userName: val?.name ?? "",
            phoneNo: val?.mobno ?? "",
            merchantCode: busdet?.mercntCode ?? "",
            orderId: transRespVal.orderId ?? "",
            paymentMode: transRespVal.paymentMode ?? "",
            paymentChannel: transRespVal.paymentChannel ?? "",
            paymentDatetime: transRespVal.paymentDatetime ?? "",
            responseCode: respCode,
            responseMessage: respMsg,
            errorDesc: transRespVal.errorDesc ?? "",
            cardMasked: transRespVal.cardmasked ?? "",
          );
          if (!context.mounted) return;
          await TicketFun.instance.paymentStatusUpdt(tktreq, context);

          if (!context.mounted) return;
          transBox(context, transRespVal, respCode, respMsg);
        } else {
          log("failed resp");
          // log(message);
          final val = await SharedPrefManager.instance.getSharedData();
          final tktreq = TicketsaveReq(
            approvalRefNo: transRespVal.transactionId ?? "",
            userId: val?.userId ?? "",
            userName: val?.name ?? "",
            phoneNo: val?.mobno ?? "",
            merchantCode: busdet?.mercntCode ?? "",
            orderId: transRespVal.orderId ?? "",
            paymentMode: transRespVal.paymentMode ?? "",
            paymentChannel: transRespVal.paymentChannel ?? "",
            paymentDatetime: transRespVal.paymentDatetime ?? "",
            responseCode: respCode,
            responseMessage: respMsg,
            errorDesc: transRespVal.errorDesc ?? "",
            cardMasked: transRespVal.cardmasked ?? "",
          );
          if (!context.mounted) return;
          await TicketFun.instance.paymentStatusUpdt(tktreq, context);
          if (!context.mounted) return;
          transBox(context, transRespVal, respCode, respMsg);
        }
      }
    } on PlatformException catch (e) {
      log("Payment error => ${e.message}");
      setState(() {
        paymentResponse = "Failed to initiate payment";
      });
    } catch (e) {
      log("Unexpected error => $e");
    }
  }

  Map<String, String> convertToStringMap(Map<String, dynamic> data) {
    return data.map((key, value) {
      return MapEntry(key, value == null ? '' : value.toString());
    });
  }

  Future<void> transCncl(
    BuildContext originalContext,
    Map<String, dynamic>? request,
    int retryCount,
  ) async {
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.history,
                              color: Colors.amber,
                              size: 35,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Processing",
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Please check ticket status",
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
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ScreenScanPay(busid: widget.busid),
                                  ),
                                );
                              },

                              child: Text(
                                "Cancel",
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
                              onPressed: retryCount >= 3
                                  ? null // disable after 2 taps
                                  : () async {
                                      Navigator.pop(context);

                                      Future.delayed(
                                        const Duration(milliseconds: 200),
                                        () async {
                                          if (!originalContext.mounted) return;

                                          final req = Farereq(
                                            userId: val?.userId ?? "",
                                            orderId: params?["order_id"],
                                          );

                                          ticketStatus = await TicketFun
                                              .instance
                                              .ckeckPayStatus(req, context);

                                          final int? respCode =
                                              ticketStatus?.responseCode
                                                  is String
                                              ? int.tryParse(
                                                  ticketStatus?.responseCode ??
                                                      "",
                                                )
                                              : ticketStatus?.responseCode;

                                          retryCount++; // increment tap count

                                          if (respCode == 500 &&
                                              retryCount < 3) {
                                            if (!originalContext.mounted)return;
                                            transCncl(
                                              originalContext,
                                              request,
                                              retryCount,
                                            );
                                          } else {
                                            if (respCode == 500) {
                                              if (!originalContext.mounted)return;

                                              Navigator.of(
                                                originalContext,
                                              ).pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                  builder: (originalContext) =>
                                                      ScreenMyTickets(
                                                        initialTabIndex: 1,
                                                      ),
                                                ),
                                                (Route<dynamic> route) => false,
                                              );
                                            } else {
                                              if (!originalContext.mounted)return;
                                              transBox(
                                                originalContext,
                                                ticketStatus,
                                                respCode,
                                                respCode == 0
                                                    ? "Transaction Successfull"
                                                    : "Transaction Failed",
                                              );
                                            }
                                          }
                                        },
                                      );
                                    },
                              child: Text(
                                retryCount == 0 ? "Check Status" : "Retry",
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

  Future<void> transBox(
    BuildContext originalContext,
    Transactionresp? val,
    int? code,
    String? msg,
  ) async {
    bool isSuccess = code == 0;

    await showDialog(
      context: originalContext,
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
                child: FutureBuilder(
                  future: Future.delayed(Duration(seconds: isSuccess ? 1 : 1)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset(
                            isSuccess
                                ? 'assets/lottie/transaction/Animation - 1750913123081.json'
                                : 'assets/lottie/transaction/Animation - 1750914295922.json',
                            width:
                                MediaQuery.of(context).size.width /
                                (isSuccess ? 1.5 : 1.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isSuccess
                                ? "Transaction Successful"
                                : "Transaction Failed",
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSuccess ? Colors.green : Colors.red,
                                ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isSuccess
                                ? "Transaction Successful"
                                : "Transaction Failed",
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSuccess ? Colors.green : Colors.red,
                                ),
                          ),
                          const SizedBox(height: 8),
                          if (isSuccess)
                            buildTransactionTable(val, msg)
                          else
                            buildTransactionTable(val, msg),
                          const SizedBox(height: 20),
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
                                  condQrDataEnable==false
                                    ? Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ScreenScanPay(busid: widget.busid),
                                          ),
                                        )
                                    : Navigator.pushReplacement(context, Approutes().mainScreen);

                                },
                                child: Text(
                                  isSuccess ? 'Back' : 'Cancel',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              SizedBox(
                                height: 40,
                                //width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 2,
                                    backgroundColor: const Color(0xffffa600),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (isSuccess) {
                                      final ticketvalue =
                                      condQrDataEnable==false
                                    ? Ticketview(
                                        ticketNo: ticketdata?.ticketNo ?? '',
                                        busId: ticketdata?.busid ?? '',
                                        tripId: busdet?.tripId ?? '',
                                        routename: busdet?.tripName??'',
                                        startTime: busdet?.startTime??'',
                                        endTime: busdet?.endTime??'',
                                        fromPlace:
                                            selectedFromStop?.stopName ?? '',
                                        toPlace: selectedToStop?.stopName ?? '',
                                        adults: countadult.toString(),
                                        student: countstud.toString(),
                                        kids: countkid.toString(),
                                        handicapped: counthandi.toString(),
                                        busName: busdet?.busName ?? '',
                                        registrationNo:
                                            busdet?.registrationNo ?? '',
                                        travelDate: transdate,
                                        travelTime: transtime,
                                        transactionId:
                                            transRespVal?.transactionId ?? '',
                                        singleadult:
                                            calcFare?.singleadult ?? '',
                                        singlekids: calcFare?.singlekid ?? '',
                                        singlestudent:
                                            calcFare?.singlestud ?? '',
                                        adultfare: calcFare?.adultFare ?? '',
                                        kidsfare: calcFare?.kidsFare ?? '',
                                        studentfare:
                                            calcFare?.studentFare ?? '',
                                        totalfare: calcFare?.totalFare ?? '',
                                      ):Ticketview(
                                        ticketNo: ticketdata?.ticketNo ?? '',
                                        busId: ticketdata?.busid ?? '',
                                        tripId: condQrData?.tripId ?? '',
                                        routename: condQrData?.tripName??'',
                                        startTime: condQrData?.startTime??'',
                                        endTime: condQrData?.endTime??'',
                                        fromPlace:condQrData?.fromPlace ?? '',
                                        toPlace: condQrData?.toPlace ?? '',
                                        adults: countadult.toString(),
                                        student: countstud.toString(),
                                        kids: countkid.toString(),
                                        handicapped: counthandi.toString(),
                                        busName: condQrData?.busName ?? '',
                                        registrationNo:
                                            condQrData?.regNo ?? '',
                                        travelDate: transdate,
                                        travelTime: transtime,
                                        transactionId:
                                            transRespVal?.transactionId ?? '',
                                        singleadult:
                                            condQrData?.singleAdult ?? '',
                                        singlekids: condQrData?.singleKid ?? '',
                                        singlestudent:
                                            condQrData?.singleStudent ?? '',
                                        singlehandicapped: condQrData?.singleHandi??'',
                                        adultfare: condQrData?.adultAmount ?? '',
                                        kidsfare: condQrData?.kidAmount ?? '',
                                        studentfare:
                                            condQrData?.studentAmount ?? '',
                                        handicappedfare: condQrData?.handiAmount??'',
                                        discount: condQrData?.discount.toString()??'',
                                        totalfare: condQrData?.totalAmt ?? '',
                                      );
                                      Navigator.of(
                                        originalContext,
                                      ).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (originalContext) =>
                                              ScreenLiveTicket(
                                                tktvw: ticketvalue,
                                                title: "Active Ticket",
                                                initialTab: 0,
                                              ),
                                        ),
                                        (Route<dynamic> route) => false,
                                      );
                                      // Navigator.of(originalContext).pushReplacement(
                                      //   MaterialPageRoute(
                                      //     builder:
                                      //         (originalContext) => ScreenLiveTicket(tktvw: ticketvalue,),
                                      //   ),
                                      // );
                                    } else {
                                      Navigator.pop(context);
                                      Future.delayed(
                                        Duration(milliseconds: 200),
                                        () {
                                          if (originalContext.mounted) {
                                            initiateOmniwarePayment(
                                              originalContext,
                                            );
                                            // open(params,originalContext);
                                          }
                                        },
                                      );
                                    }
                                  },
                                  child: Text(
                                    isSuccess ? 'View Ticket' : 'TryAgain',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

Future<void> ticketGenerationFailedPopup(
  BuildContext context, {
  String? message,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
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
                  Lottie.asset(
                    'assets/lottie/transaction/Animation - 1750914295922.json',
                    width: MediaQuery.of(context).size.width / 1.5,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    "Ticket Generation Failed",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    message ??
                        "Unable to generate the ticket. Something went wrong.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        backgroundColor: const Color(0xffffa600),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(dialogContext);

                        Future.delayed(
                          const Duration(milliseconds: 200),
                          () {
                            if (context.mounted) {
                              initiateOmniwarePayment(context);
                            }
                          },
                        );
                      },
                      child: Text(
                        "Try Again",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Color.fromARGB(255, 242, 32, 17),
                        fontSize: 18,
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


  Widget buildTransactionTable(Transactionresp? val, String? msg) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(4),
        1: FlexColumnWidth(.5),
        2: FlexColumnWidth(5),
      },
      children: [
        TableRow(
          children: [
            _buildFareCell(context, "Trans. ID"),
            _buildFareCell(context, ":"),
            _buildFareCell(context, val?.transactionId ?? val?.orderId ?? ''),
          ],
        ),
        TableRow(
          children: [
            _buildFareCell(context, "Trans. Amount"),
            _buildFareCell(context, ":"),
            _buildFareCell(context, condQrDataEnable==false
              ?calcFare?.totalFare ?? '':condQrData?.totalAmt??''),
          ],
        ),
        TableRow(
          children: [
            _buildFareCell(context, "Trans. Message"),
            _buildFareCell(context, ":"),
            _buildFareCell(context, msg ?? "-"),
          ],
        ),
      ],
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double radius = 15.0;
    final double cutY = size.height * 0.42;

    // Start top-left
    path.moveTo(0, 0);

    // Left edge to before cut
    path.lineTo(0, cutY - radius);

    // Left semicircle inward cut
    path.arcToPoint(
      Offset(0, cutY + radius),
      radius: Radius.circular(radius),
      clockwise: true, // ← changes direction to make it an inward cut
    );

    // Left edge to bottom-left
    path.lineTo(0, size.height);

    // Bottom-left to bottom-right
    path.lineTo(size.width, size.height);

    // Right edge from bottom to cut bottom
    path.lineTo(size.width, cutY + radius);

    // Right semicircle inward cut
    path.arcToPoint(
      Offset(size.width, cutY - radius),
      radius: Radius.circular(radius),
      clockwise: true, // inward cut
    );

    // Right edge to top-right
    path.lineTo(size.width, 0);

    // Close the path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class DottedSeparatorLine extends CustomPainter {
  final double yOffsetFactor; // 0.30 = 30% from top
  final Color color;

  DottedSeparatorLine({required this.yOffsetFactor, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double y = size.height * yOffsetFactor;

    const double dotWidth = 4;
    const double space = 4;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, y), Offset(startX + dotWidth, y), paint);
      startX += dotWidth + space;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
