import 'dart:convert';
import 'dart:developer';
import 'package:pompompay/core/hook/hooks.dart';

class SearchFun {
  SearchFun._internal();
  static SearchFun instance = SearchFun._internal();
  SearchFun factory() {
    return instance;
  }
  ValueNotifier<List<Datumlist>> getBusListNotifier = ValueNotifier([]);


  Future<List<Datum>?> fetchStage(BuildContext context) async {
    try {
      final bnkLstresp = await Pompaydata().getStageList();
      String? message;
      if (bnkLstresp == null) {
        if (!context.mounted) return [];
        CommonFun.instance.showApierror(context, "Something went wrong");
      } else if (bnkLstresp.statusCode == 200) {
        final resultAsJson = jsonDecode(bnkLstresp.toString());
        final bnklstVal = GetStagelist.fromJson(
          resultAsJson as Map<String, dynamic>,
        );

        if (bnklstVal.status == 'success') {
          final cpaymob = bnklstVal.data;
          return cpaymob;
        } else if (bnklstVal.status == 'failed') {
          if (!context.mounted) return [];
          CommonFun.instance.showApierror(
            context,
            "No Stops found",
          );
          return [];
        }
      } else if (message == 'Unauthenticated' || bnkLstresp.statusCode == 401) {
        if (!context.mounted) return [];
        CommonFun.instance.showApierror(context, "Unauthenticated");
      } else if (bnkLstresp.statusCode == 500) {
        if (!context.mounted) return [];
        CommonFun.instance.showApierror(context, "Sever Not reached");
        // showLoginerror(context, 3);
      } else if (bnkLstresp.statusCode == 408) {
        if (!context.mounted) return [];
        CommonFun.instance.showApierror(context, "Connection time out");

        //showLoginerror(context, 4);
      } else {
        if (!context.mounted) return [];

        CommonFun.instance.showApierror(context, "Something went wrong");
        //showLoginerror(context, 5);
      }
    } catch (e) {
      if (!context.mounted) return [];
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    }
    return null;
  }
  Future searchBus(Farereq req,BuildContext context) async {
    try {
      final bnkLstresp = await Pompaydata().searchBus(req);
      String? message;
      if (bnkLstresp == null) {
        getBusListNotifier.value.clear();
      getBusListNotifier.value.addAll([]);
      getBusListNotifier.notifyListeners();
        if (!context.mounted) return ;
        CommonFun.instance.showApierror(context, "Something went wrong");
      } else if (bnkLstresp.statusCode == 200) {
        final resultAsJson = jsonDecode(bnkLstresp.toString());
        final bnklstVal = SearchlistResp.fromJson(
          resultAsJson as Map<String, dynamic>,
        );

        if (bnklstVal.status == 'success') {
          final cpaymob = bnklstVal.data;
          getBusListNotifier.value.clear();
          getBusListNotifier.value.addAll(cpaymob!);
          getBusListNotifier.notifyListeners();
          
        } else if (bnklstVal.status == 'failed') {
          getBusListNotifier.value.clear();
          getBusListNotifier.value.addAll([]);
          getBusListNotifier.notifyListeners();
          if (!context.mounted) return ;
          CommonFun.instance.showApierror(
            context,
            "No matches found for Search",
          );
          
        }
      } else if (message == 'Unauthenticated' || bnkLstresp.statusCode == 401) {
        if (!context.mounted) return ;
        CommonFun.instance.showApierror(context, "Unauthenticated");
      } else if (bnkLstresp.statusCode == 500) {
        if (!context.mounted) return ;
        CommonFun.instance.showApierror(context, "Sever Not reached");
        // showLoginerror(context, 3);
      } else if (bnkLstresp.statusCode == 408) {
        if (!context.mounted) return ;
        CommonFun.instance.showApierror(context, "Connection time out");

        //showLoginerror(context, 4);
      } else {
        if (!context.mounted) return ;

        CommonFun.instance.showApierror(context, "Something went wrong");
        //showLoginerror(context, 5);
      }
    } catch (e) {
      if (!context.mounted) return ;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    }
  }
  Future sortBus(Farereq req,BuildContext context) async {
    try {
      final bnkLstresp = await Pompaydata().sortBus(req);
      String? message;
      if (bnkLstresp == null) {
        getBusListNotifier.value.clear();
      getBusListNotifier.value.addAll([]);
      getBusListNotifier.notifyListeners();
        if (!context.mounted) return ;
        CommonFun.instance.showApierror(context, "Something went wrong");
      } else if (bnkLstresp.statusCode == 200) {
        final resultAsJson = jsonDecode(bnkLstresp.toString());
        final bnklstVal = SearchlistResp.fromJson(
          resultAsJson as Map<String, dynamic>,
        );

        if (bnklstVal.status == 'success') {
          final cpaymob = bnklstVal.data;
          getBusListNotifier.value.clear();
          getBusListNotifier.value.addAll(cpaymob!);
          getBusListNotifier.notifyListeners();
          
        } else if (bnklstVal.status == 'failed') {
          getBusListNotifier.value.clear();
          getBusListNotifier.value.addAll([]);
          getBusListNotifier.notifyListeners();
          if (!context.mounted) return ;
          CommonFun.instance.showApierror(
            context,
            "No matches found for Search",
          );
          
        }
      } else if (message == 'Unauthenticated' || bnkLstresp.statusCode == 401) {
        if (!context.mounted) return ;
        CommonFun.instance.showApierror(context, "Unauthenticated");
      } else if (bnkLstresp.statusCode == 500) {
        if (!context.mounted) return ;
        CommonFun.instance.showApierror(context, "Sever Not reached");
        // showLoginerror(context, 3);
      } else if (bnkLstresp.statusCode == 408) {
        if (!context.mounted) return ;
        CommonFun.instance.showApierror(context, "Connection time out");

        //showLoginerror(context, 4);
      } else {
        if (!context.mounted) return ;

        CommonFun.instance.showApierror(context, "Something went wrong");
        //showLoginerror(context, 5);
      }
    } catch (e) {
      if (!context.mounted) return ;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    }
  }

   Future<DataList?> fetchStopLoc(Farereq req,BuildContext context) async {
      DataList? value;
    try {
      final bnkLstresp = await Pompaydata().fetchStopLoc(req);
      String? message;
      if (bnkLstresp == null) {
        if (!context.mounted) return value;
        CommonFun.instance.showApierror(context, "Something went wrong");
      } else if (bnkLstresp.statusCode == 200) {
        final resultAsJson = jsonDecode(bnkLstresp.toString());
        final bnklstVal = StoplocResp.fromJson(
          resultAsJson as Map<String, dynamic>,
        );
        if (bnklstVal.status == 'success') {
          final cpaymob = bnklstVal.data;
          return cpaymob;
        } else if (bnklstVal.status == 'failed') {
          if (!context.mounted) return value;
          CommonFun.instance.showApierror(
            context,
            "No matches found for Search",
          );
          return value;
        }
      } else if (message == 'Unauthenticated' || bnkLstresp.statusCode == 401) {
        if (!context.mounted) return value;
        CommonFun.instance.showApierror(context, "Unauthenticated");
      } else if (bnkLstresp.statusCode == 500) {
        if (!context.mounted) return value;
        CommonFun.instance.showApierror(context, "Sever Not reached");
        // showLoginerror(context, 3);
      } else if (bnkLstresp.statusCode == 408) {
        if (!context.mounted) return value;
        CommonFun.instance.showApierror(context, "Connection time out");

        //showLoginerror(context, 4);
      } else {
        if (!context.mounted) return value;

        CommonFun.instance.showApierror(context, "Something went wrong");
        //showLoginerror(context, 5);
      }
    } catch (e) {
      if (!context.mounted) return value;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    }
    return null;
  }
  Future<BusLocation?> fetchLiveBusLoc(Farereq req,BuildContext context) async {
      //Datalive? value;
      BusLocation? busLocation;
    try {
      final bnkLstresp = await Pompaydata().liveBusLoc(req);
      String? message;
      if (bnkLstresp == null) {
        if (!context.mounted) return busLocation;
        CommonFun.instance.showApierror(context, "Something went wrong");
      } else if (bnkLstresp.statusCode == 200) {
        final resultAsJson = jsonDecode(bnkLstresp.toString());
        final bnklstVal = LiveBusresp.fromJson(
          resultAsJson as Map<String, dynamic>,
        );
        if (bnklstVal.status == 'success') {
          final cpaymob = bnklstVal.data?.busLocation;
          return cpaymob;
        } else if (bnklstVal.status == 'failed') {
          // if (!context.mounted) return value;
          // CommonFun.instance.showApierror(
          //   context,
          //   "Gps connection lost",
          // );
          // final cpaymob = bnklstVal.data;
          // return cpaymob;
          //return value;
          log("no live location fetch");
        }
      } else if (message == 'Unauthenticated' || bnkLstresp.statusCode == 401) {
        if (!context.mounted) return busLocation;
        CommonFun.instance.showApierror(context, "Unauthenticated");
      } else if (bnkLstresp.statusCode == 500) {
        if (!context.mounted) return busLocation;
        CommonFun.instance.showApierror(context, "Sever Not reached");
        // showLoginerror(context, 3);
      } else if (bnkLstresp.statusCode == 408) {
        if (!context.mounted) return busLocation;
        CommonFun.instance.showApierror(context, "Connection time out");

        //showLoginerror(context, 4);
      } else {
        if (!context.mounted) return busLocation;

        CommonFun.instance.showApierror(context, "Something went wrong");
        //showLoginerror(context, 5);
      }
    } catch (e) {
      if (!context.mounted) return busLocation;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    }
    return null;
  }
}
