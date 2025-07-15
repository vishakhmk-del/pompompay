import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:pompompay/core/hook/hooks.dart';
import 'package:sizer/sizer.dart';

class ScreenScanPay extends StatefulWidget {
  const ScreenScanPay({super.key, required this.busid});
  final String busid;
  @override
  State<ScreenScanPay> createState() => _ScreenScanPayState();
}

class _ScreenScanPayState extends State<ScreenScanPay> {
  int countkid = 0;
  int countadult = 1;
  int countstud = 0;
  int counthandi = 0;
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
  List<String> stoplst = [];
  String? selectedFromList;
  String? selectedToList;
  String? todayDt;
  String? crntTm;
  String? usrid;
  TransResponse? transRespVal;
  String? transdate;
  String? transtime;

  @override
  void initState() {
    super.initState();
    // log(widget.busid);
    fetchfareDet(context);
    _adultController = TextEditingController(text: countadult.toString());
    _kidController = TextEditingController(text: countkid.toString());
    _studController = TextEditingController(text: countstud.toString());
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
    setState(() {
      busdet = busdetails?.busdetails;
      stopsdet = busdetails?.stopsdetails ?? [];
      if (stopsdet != null && stopsdet!.isNotEmpty) {
        stoplst = stopsdet!.map((bus) => bus.stopName ?? "").toList();
      }
    });
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
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall?.copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          busdet?.registrationNo ?? '',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall?.copyWith(
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
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall?.copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            SizedBox(width: .5.w),
                                            Text(
                                              "(${busdet?.startTime ?? ''}-${busdet?.endTime ?? ''})",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall?.copyWith(
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
                                            DropdownButtonFormField2<String>(
                                              isExpanded: true,
                                              value: selectedFromList,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedFromList = value!;
                                                });
                                              },
                                              items:
                                                  stoplst.map((valueItem) {
                                                    return DropdownMenuItem<
                                                      String
                                                    >(
                                                      value: valueItem,
                                                      child: Text(
                                                        valueItem,
                                                        overflow:
                                                            TextOverflow
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
                                                labelText: 'From Stop',
                                                labelStyle: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall?.copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0xFFE1E1E1),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(4.0),
                                                      ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
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
                                                    OutlineInputBorder(
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
                                                    OutlineInputBorder(
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
                                            DropdownButtonFormField2<String>(
                                              isExpanded: true,
                                              value: selectedToList,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedToList = value!;
                                                });
                                              },
                                              items:
                                                  stoplst.map((valueItem) {
                                                    return DropdownMenuItem<
                                                      String
                                                    >(
                                                      value: valueItem,
                                                      child: Text(
                                                        valueItem,
                                                        overflow:
                                                            TextOverflow
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
                                                labelStyle: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall?.copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0xFFE1E1E1),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(4.0),
                                                      ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
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
                                                    OutlineInputBorder(
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
                                                    OutlineInputBorder(
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
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      // Center-aligned icon
                                      Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          width: 6.5.w,
                                          height: 6.5.h,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              shape: const CircleBorder(),
                                              backgroundColor: Colors.white,
                                              foregroundColor:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                              elevation: 2,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                final temp = selectedFromList;
                                                selectedFromList =
                                                    selectedToList;
                                                selectedToList = temp;
                                              });
                                            },
                                            child: const Icon(
                                              Icons.swap_vert,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Align(
                                      //   alignment: Alignment.center,
                                      //   child: IconButton(onPressed: () {
                                      //       setState(() {
                                      //         final temp = selectedFromList;
                                      //         selectedFromList = selectedToList;
                                      //         selectedToList = temp;
                                      //       });
                                      //     },icon: const Icon(Icons.swap_vert, size: 20),),
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
                                              _adultController.text =
                                                  countadult.toString();
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
                                              _kidController.text =
                                                  countkid.toString();
                                            });
                                          },
                                          onDecrement: () {
                                            if (countkid > 0) {
                                              setState(() {
                                                countkid--;
                                                _kidController.text =
                                                    countkid.toString();
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
                                              _studController.text =
                                                  countstud.toString();
                                            });
                                          },
                                          onDecrement: () {
                                            if (countstud > 0) {
                                              setState(() {
                                                countstud--;
                                                _studController.text =
                                                    countstud.toString();
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
                                        if (selectedFromList == null) {
                                          CommonFun.instance.showApierror(
                                            context,
                                            "please select from station",
                                          );
                                        } else if (selectedToList == null) {
                                          CommonFun.instance.showApierror(
                                            context,
                                            "please select destination",
                                          );
                                        } else {
                                          final req = Farereq(
                                            adults: countadult.toString(),
                                            kids: countkid.toString(),
                                            stud: countstud.toString(),
                                            busId: busdet?.busid ?? '',
                                            from: selectedFromList,
                                            to: selectedToList,
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
                                            //backgroundColor: const Color(0xff00c7c8),
                                            //Color.fromARGB(255, 6, 173, 162),
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                    top: Radius.circular(10),
                                                  ),
                                            ),

                                            context: context,
                                            builder: (context) => buildSheet(),
                                          ).whenComplete(() {
                                            // Reset the button state when bottom sheet is closed
                                            if (!context.mounted) return;
                                            context
                                                .read<LoadingProvider>()
                                                .resetAll();
                                          });
                                        }
                                      },
                                      child: Text(
                                        'Get Fare',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Consumer<LoadingProvider>(
                                    builder: (context, loadingProvider, child) {
                                      return loadingProvider.isLoading
                                          ? const Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Color.fromARGB(
                                                      255,
                                                      2,
                                                      128,
                                                      6,
                                                    ),
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
                  ] else ...[
                    FutureBuilder(
                      future: Future.delayed(
                        const Duration(seconds: 5),
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
                              child: const CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height / 2.5,
                                horizontal:
                                    MediaQuery.of(context).size.width / 3.5,
                              ),
                              child: Text(
                                'No acitve trip found',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
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

  Widget buildSheet() {
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
        // initialChildSize: 0.475, // 50% of screen height initially
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ticket Summary',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
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
                                              busdet?.busName?.toUpperCase() ??
                                                  '',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall?.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              busdet?.registrationNo ?? '',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall?.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
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
                                              todayDt ?? '',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall?.copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              crntTm ?? '',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall?.copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        // Text(
                                        //   busdet?.routename ?? '',
                                        //   style: Theme.of(context)
                                        //       .textTheme
                                        //       .bodySmall
                                        //       ?.copyWith(
                                        //         fontSize: 14,
                                        //         fontWeight: FontWeight.w500,
                                        //       ),
                                        // ),
                                        // const SizedBox(height: 2),
                                        // Text(
                                        //   ticket.tiketNo ?? '',
                                        //   style: Theme.of(context)
                                        //       .textTheme
                                        //       .bodySmall
                                        //       ?.copyWith(
                                        //         fontSize: 14,
                                        //         fontWeight: FontWeight.bold,
                                        //       ),
                                        // ),
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
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall?.copyWith(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                selectedFromList ?? '',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall?.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
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
                                                  dashColor:
                                                      Theme.of(
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
                                                  dashColor:
                                                      Theme.of(
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
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall?.copyWith(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                selectedToList ?? '',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall?.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
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
                                                  _buildFareCell(
                                                    context,
                                                    calcFare?.singleadult ?? '',
                                                  ),
                                                  _buildFareCell(context, "="),
                                                  _buildFareCell(
                                                    context,
                                                    calcFare?.adultFare ?? '',
                                                  ),
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
                                                  _buildFareCell(
                                                    context,
                                                    calcFare?.singlekid ?? '',
                                                  ),
                                                  _buildFareCell(context, "="),
                                                  _buildFareCell(
                                                    context,
                                                    calcFare?.kidsFare ?? '',
                                                  ),
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
                                                  _buildFareCell(
                                                    context,
                                                    calcFare?.singlestud ?? '',
                                                  ),
                                                  _buildFareCell(context, "="),
                                                  _buildFareCell(
                                                    context,
                                                    calcFare?.studentFare ?? '',
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Rs ${calcFare?.totalFare}.0",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall?.copyWith(
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
                                              await initiateOmniwarePayment(
                                                context,
                                              );
                                            },
                                            child: Text(
                                              'Proceed',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
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

    final hashColumns = [
      'api_key',
      'salt_key',
      'payment_url',
      'name',
      'email',
      'phone',
      'amount',
      'description',
      'address_line_1',
      'address_line_2',
      'city',
      'state',
      'country',
      'zip_code',
      'currency',
      'mode',
      'return_url',
      "enable_auto_refund",
      'order_id',
      'udf1',
      'udf2',
      'udf3',
      'udf4',
      'udf5',
    ];

    // hashColumns.sort();
    String hashData = '';

    for (final column in hashColumns) {
      final value = data[column];
      if (value != null && value.toString().trim().isNotEmpty) {
        hashData += '|${value.toString().trim()}';
      }
    }
    final bytes = utf8.encode(hashData);
    hash = sha512.convert(bytes).toString();

    return {...data, 'hash': hash};
  }

  Future<void> initiateOmniwarePayment(BuildContext context) async {
    try {
      final val = await SharedPrefManager.instance.getSharedData();
      //final salt="dc413f7c2ddfd4d9ae63dddef2fcc5564c5309ac";

      final paymentData = {
        "api_key": busdet?.upid ?? '',
        "salt_key": "dc413f7c2ddfd4d9ae63dddef2fcc5564c5309ac",
        "payment_url": "https://pgbiz.omniware.in",
        "name": val?.name ?? '',
        "email": "shilucks@gmail.com",
        "phone": busdet?.mobileNo ?? '',
        "amount": "2",
        "description": "bus ticket payment",
        "address_line_1": "test",
        "address_line_2": "text", // Total from your UI
        "city": "Kannur",
        "state": "Kerala",
        "country": "IND",
        "zip_code": "670002",
        "currency": "INR",
        "mode": "LIVE",
        "order_id": "TKT${DateTime.now().millisecondsSinceEpoch}",
        "return_url": "https://pgbiz.omniware.in/tnpv2/return_page.php",
        //"merchant_id": busdet?.mercntCode??'',
        "enable_auto_refund": "n",
        "udf1": "",
        "udf2": "",
        "udf3": "",
        "udf4": "",
        "udf5": "",
        // Optional: Use real phone number if available
      };
      final params = generatePaymentParams(paymentData);
      if (!context.mounted) return;
      open(params, context);
    } catch (e, st) {
      debugPrint("Payment error: $e");
      debugPrint('Stack trace: $st');
    }
  }

  void open(Map<String, dynamic> request, BuildContext context) async {
    try {
      log("Request Params => $request");
      response = await PaymentGatewayPlugin.open(
        "https://pgbiz.omniware.in",
        request,
      );

      if (response != null) {
        log("Response => $response");
        //final status="${response['status']}";
        final message = "${response['message']}";
        final resp = "${response['response']}";
        //final code="${response['code']}";
        final resultAsJson = jsonDecode(resp.toString());
        transRespVal = TransResponse.fromJson(
          resultAsJson as Map<String, dynamic>,
        );
        final dttime = transRespVal?.paymentDatetime;
        DateTime parsed = DateTime.parse(dttime ?? '');

        formatted = DateFormat("yyyy-MM-dd h:mm:ss a").format(parsed);
        log(formatted ?? '');
        if (formatted != null) {
          List<String> parts = formatted!.split(' ');
          transdate = parts[0];
          transtime = '${parts[1]} ${parts[2]}';
          log(transdate ?? 'null');
          log(transtime ?? 'null');
        } else {
          transdate = '';
          transtime = '';
        }
        //final validHash = hash == transRespVal?.hash ? "Yes" : "No";
        final respcode = transRespVal?.responseCode;
        final respmsg = transRespVal?.responseMessage ?? '';
        final status =
            (respcode == 0)
                ? "success"
                : (respcode == 1000)
                ? "failed"
                : (respcode == 1006)
                ? "WAITING-BANK-RESPONSE"
                : (respcode == 1015)
                ? "INSUFFICIENT-FUND"
                : "unknown";
        if (status == "success") {
          log("success resp");
          log(respmsg);
          final val = await SharedPrefManager.instance.getSharedData();
          final tktreq = TicketsaveReq(
            tripId: busdet?.tripId ?? '',
            busid: busdet?.busid ?? '',
            approvalRefNo: transRespVal?.transactionId ?? '',
            frmselected: selectedFromList,
            toselected: selectedToList,
            adultsselected: countadult,
            kidsselected: countkid,
            handiselected: counthandi,
            studselected: countstud,
            userId: val?.userId ?? '',
            userName: val?.name ?? '',
            phoneNo: val?.mobno ?? "",
            merchantCode: busdet?.mercntCode ?? "",
            amount: calcFare?.totalFare ?? "",
            reqTime: formatted,
          );
          if (!context.mounted) return;
          ticketdata = await TicketFun.instance.ticketSave(tktreq, context);

          if (!context.mounted) return;
          transBox(context, transRespVal, respcode, respmsg);
        } else {
          log("failed resp");
          log(message);
          if (!context.mounted) return;
          transBox(context, transRespVal, respcode, respmsg);
        }
      } else {
        setState(() {
          paymentResponse = "No response received from the payment gateway.";
          log(paymentResponse);
        });
      }
    } on PlatformException {
      setState(() {
        paymentResponse = 'Failed to initiate payment.';
      });
    }
  }

  Future<void> transBox(
    BuildContext originalContext,
    TransResponse? val,
    int? code,
    String? msg,
  ) async {
    bool isSuccess = code == 0;

    await showDialog(
      context: originalContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
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
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
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
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
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
                                isSuccess
                                    ? Navigator.pushReplacement(
                                      context,
                                      Approutes().qrscreen,
                                    )
                                    : Navigator.pop(context);
                              },
                              child: Text(
                                isSuccess ? 'Back' : 'Cancel',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(
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
                                    final ticketvalue = Ticketview(
                                      tiketNo: ticketdata?.ticketNo ?? '',
                                      busId: ticketdata?.busid ?? '',
                                      tripId: busdet?.tripId ?? '',
                                      fromPlace: selectedFromList,
                                      toPlace: selectedToList,
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
                                      singleadult: calcFare?.singleadult ?? '',
                                      singlekids: calcFare?.singlekid ?? '',
                                      singlestudent: calcFare?.singlestud ?? '',
                                      adultfare: calcFare?.adultFare ?? '',
                                      kidsfare: calcFare?.kidsFare ?? '',
                                      studentfare: calcFare?.studentFare ?? '',
                                      totalfare: calcFare?.totalFare ?? '',
                                    );
                                    Navigator.of(
                                      originalContext,
                                    ).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder:
                                            (originalContext) =>
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
                                        }
                                      },
                                    );
                                  }
                                },
                                child: Text(
                                  isSuccess ? 'View Ticket' : 'TryAgain',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(
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
        );
      },
    );
  }

  Widget buildTransactionTable(TransResponse? val, String? msg) {
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
            _buildFareCell(context, val?.transactionId ?? ''),
          ],
        ),
        TableRow(
          children: [
            _buildFareCell(context, "Trans. Amount"),
            _buildFareCell(context, ":"),
            _buildFareCell(context, val?.amount ?? ''),
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
    final double cutY = size.height * 0.40;

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

    final paint =
        Paint()
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
