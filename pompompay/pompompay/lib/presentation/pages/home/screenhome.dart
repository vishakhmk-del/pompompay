import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:pompompay/core/hook/hooks.dart';
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

  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
      Livelocationfun.instance.startTracking(
          context: context,
          onLocationUpdate: (position) {
           // if (!mounted) return;
            setState(() {
              doublelat = position.latitude;
              doublelong = position.longitude;
              locationMessage =
                  'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
              log("homescreen init:$locationMessage");
            });
          });
          
          });
    fetchstop(context);
    userdet();
    recentValue();
  }

  Future fetchstop(BuildContext context) async {
    cpayMoblst = await SearchFun.instance.fetchStage(context);
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
        filteredFromPlace =
            cpayMoblst
                ?.where(
                  (item) => item.stopName!.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
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
        filteredToPlace =
            cpayMoblst
                ?.where(
                  (item) => item.stopName!.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
                )
                .toList();
      }
    });
  }



  void userdet() async {
    final val = await SharedPrefManager.instance.getSharedData();

    setState(() {
      usrNm = val!.name;
    });
  }

  Future<bool?> showWarning(BuildContext context) async => showDialog<bool>(
    barrierDismissible: false,
    context: context,
    builder:
        (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Center(
            child: Text(
              "Exit App?",
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontSize: 18.sp,color:Colors.white),
            ),
          ),
          content: Text(
            "Are you sure you want to exit?",
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontSize: 18.sp,color:Colors.white),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'NO',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(color:Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                Navigator.pop(context, true);
                // Livelocationfun.instance.stopTracking();
              },
              child: Text(
                'YES',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(color:Colors.white),
              ),
            ),
          ],
        ),
  );

Future<void> recentValue() async {
      final val = await SharedPrefManager.instance.loadRecentSearches();
  setState(() {
    recentSearches = val;
    isLoadingRecent = false;
  });
}

  @override
  void dispose() {
    //Livelocationfun.instance.stopTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (!didPop) {
          final confirmExit = await showWarning(context);
          if (confirmExit == true) {
            SystemNavigator.pop(); // Exit the app
          }
        }
      },
      child: Scaffold(
        //backgroundColor: Theme.of(context).colorScheme.secondary,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
            setState(() {
              showFromDropdown = false;
              showToDropdown = false;
            });
          },
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
                    top:
                        MediaQuery.of(context).size.height /
                        9.8, // Adjust position
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
                                  hintStyle: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
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
                                onChanged: (value) {
                                  filterFromList(value);
                                  showFromDropdown = true;
                                },
                                onTap: () {
                                  setState(() {
                                      showFromDropdown = !showFromDropdown;
                                      if (showFromDropdown) {
                                        showToDropdown = false;
                                      }
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
                                  hintStyle: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
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
                                onChanged: (value) {
                                  filterToList(value);
                                  showToDropdown = true;
                                },
                                onTap: () {
                                   setState(() {
                                      showToDropdown = !showToDropdown;
                                      if (showToDropdown) {
                                        showFromDropdown = false;
                                      }
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
                                      onTap:
                                          () => _selectTime(
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
                                      onTap:
                                          () => _selectTime(
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
                              Container(
                                height: 5.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).colorScheme.secondary,
                                      Theme.of(context).colorScheme.primary,
                                    ],
                                  ),
                                ),
                                child: Theme(
                                  data: MyTheme.buttonStyleTheme,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final String from = fromcontroller.text;
                                      final String to = tocontroller.text;
                                      final String frmTime =_fromtimeController.text;
                                      final String toTime =_totimeController.text;

                                      final DateFormat inputFormat = DateFormat('hh:mm a');
                                      final DateTime datefrmTime = inputFormat.parse(frmTime);
                                      final DateTime datetoTime = inputFormat.parse(toTime);

                                      final DateFormat outputFormat = DateFormat('hh:mm:ss a');
                                      final frmtm= outputFormat.format(datefrmTime);
                                      final totm= outputFormat.format(datetoTime);
                                      log("fromtime:$frmtm,totime:$totm");
                                      final now = DateTime.now();
                                      final date = DateFormat('dd-MM-yyyy').format(now);
                                      final time = DateFormat('hh:mm a').format(now); 
                                      if (_formkey.currentState!.validate()) {
                                        final farereq = Farereq(
                                          fromPlace: from,
                                          toPlace: to,
                                          startTime: frmtm,
                                          endTime: totm,
                                          crntDt: date,
                                          crntTm: time
                                        );
                                        await SharedPrefManager.instance.saveRecentSearch(farereq);
                                        if (!context.mounted) return;
                                        await SearchFun.instance.searchBus(farereq,context);
                                        if (!context.mounted) return;
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder:
                                                (context) => ScreenSearchList(
                                                  req: farereq,
                                                ),
                                          ),
                                        );
                                      }
                                    },
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
                        6.5, // Adjust position
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Theme.of(context).colorScheme.secondary,
                                        Theme.of(context).colorScheme.primary,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),

                                  child: Center(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 5.5.h,
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
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                              size: 25,
                                            ),
                                            onPressed: () {},
                                          ),
                                        ),
                                        Text(
                                          'Scan and Pay',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
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
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Theme.of(context).colorScheme.secondary,
                                        Theme.of(context).colorScheme.primary,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 5.5.h,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.local_activity_outlined,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                              size: 25,
                                            ),
                                            onPressed: () {},
                                          ),
                                        ),
                                        SizedBox(width: 3.w),
                                        Text(
                                          'Tickets',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
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
                          MediaQuery.of(context).size.height /5.8, // Adjust position
                      left: MediaQuery.of(context).size.width / 28,
                      right: MediaQuery.of(context).size.width / 28,
                      child: Container(
                        height: 150,
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
                            return ListTile(
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
                        height: 150,
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
                        height: 150,
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
                            return ListTile(
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
                        height: 150,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Search',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 1.h),
                      if (isLoadingRecent)
                        Center(child: CircularProgressIndicator())
                      else if (recentSearches.isEmpty)
                        Center(
                          child: Row(
                            children: [
                              Text(
                                'No recent searches',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              TextButton(onPressed: (){}, child: Text("more>>"))
                            ],
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: recentSearches.length > 3 ? 3 : recentSearches.length,
                          itemBuilder: (context, index) {
                            final item = recentSearches[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 2),
                              child:Container(
                                  decoration: BoxDecoration(
                                    color:Colors.white,
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
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                child: ListTile(
                                  leading: Icon(Icons.history,color:Colors.black),
                                  title: Text('${item.fromPlace} → ${item.toPlace}',style:Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(fontSize: 18,fontWeight: FontWeight.w800),),
                                  subtitle: Text('Date: ${item.crntDt} | Time: ${item.crntTm}',style:Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(fontSize: 14),),
                                  onTap: () async{
                                    // setState(() {
                                    //   fromcontroller.text = item.fromPlace ?? '';
                                    //   tocontroller.text = item.toPlace ?? '';
                                    // _fromtimeController.text=item.startTime;
                                    // _totimeController.text=item.endTime;
                                      
                                    // });
                                    final now = DateTime.now();
                                      final date = DateFormat('dd-MM-yyyy').format(now);
                                      final time = DateFormat('hh:mm a').format(now); 
                                      
                                    final farereq = Farereq(
                                          fromPlace: item.fromPlace ?? '',
                                          toPlace: item.toPlace ?? '',
                                          startTime: item.startTime,
                                          endTime: item.endTime,
                                          crntDt: date,
                                          crntTm: time
                                        );
                                        await SharedPrefManager.instance.saveRecentSearch(farereq);
                                        if (!context.mounted) return;
                                        await SearchFun.instance.searchBus(farereq,context);
                                        if (!context.mounted) return;
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder:
                                                (context) => ScreenSearchList(
                                                  req: farereq,
                                                ),
                                          ),
                                        );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.02,
                    left: MediaQuery.of(context).size.width * 0.017,
                    right: MediaQuery.of(context).size.width * 0.017,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(
                          builder:
                              (context) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Welcome,",
                                    style: TextStyle(
                                      fontFamily: 'Poppins-Medium',
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.normal,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                    ),
                                    textScaler: TextScaler.noScaling,
                                  ),
                                  Text(
                                    "$usrNm".toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: 'Poppins-Medium',
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Theme.of(
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
