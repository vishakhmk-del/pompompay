import 'dart:convert';
import 'package:pompompay/core/hook/hooks.dart';

class TicketFun {
  TicketFun._internal();
  static TicketFun instance = TicketFun._internal();
  TicketFun factory() {
    return instance;
  }

  ValueNotifier<List<Ticketview>> getActiveTktListNotifier = ValueNotifier([]);
  ValueNotifier<List<Ticketview>> getDeactiveTktListNotifier = ValueNotifier([]);

  Future<DataVal?> fetchFareDet(Farereq req, BuildContext context) async {
    DataVal? value;
    try {
      final bnkLstresp = await Pompaydata().getFareDet(req);
      String? message;
      if (bnkLstresp == null) {
        if (!context.mounted) return value;
        CommonFun.instance.showApierror(context, "Something went wrong");
      } else if (bnkLstresp.statusCode == 200) {
        final resultAsJson = jsonDecode(bnkLstresp.toString());
        final bnklstVal = GetfareResp.fromJson(
          resultAsJson as Map<String, dynamic>,
        );

        if (bnklstVal.status == 'success') {
          final cpaymob = bnklstVal.data;
          return cpaymob;
        } else if (bnklstVal.status == 'failed') {
          if (!context.mounted) return value;
          CommonFun.instance.showApierror(context, "No Active Trip found");
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

  Future<DataValue?> calculateFare(Farereq req, BuildContext context) async {
    DataValue? value;
    try {
      final bnkLstresp = await Pompaydata().calculateFare(req);
      String? message;
      if (bnkLstresp == null) {
        if (!context.mounted) return value;
        CommonFun.instance.showApierror(context, "Something went wrong");
      } else if (bnkLstresp.statusCode == 200) {
        final resultAsJson = jsonDecode(bnkLstresp.toString());
        final bnklstVal = CalculateFare.fromJson(
          resultAsJson as Map<String, dynamic>,
        );

        if (bnklstVal.status == 'success') {
          final cpaymob = bnklstVal.data;
          return cpaymob;
        } else if (bnklstVal.status == 'failed') {
          if (!context.mounted) return value;
          CommonFun.instance.showApierror(context, "No Active Trip available");
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

  Future<Datatkt?> ticketSave(TicketsaveReq req, BuildContext context) async {
    Datatkt? value;
    try {
      final bnkLstresp = await Pompaydata().ticketSave(req);
      String? message;
      if (bnkLstresp == null) {
        if (!context.mounted) return value;
        CommonFun.instance.showApierror(context, "Something went wrong");
      } else if (bnkLstresp.statusCode == 200) {
        final resultAsJson = jsonDecode(bnkLstresp.toString());
        final bnklstVal = TicketResp.fromJson(
          resultAsJson as Map<String, dynamic>,
        );

        if (bnklstVal.status == 'success') {
          final cpaymob = bnklstVal.data;
          return cpaymob;
          // if(!context.mounted) return;
          //  Navigator.of(context).pushReplacement(
          //                     MaterialPageRoute(
          //                       builder:
          //                           (context) => ScreenTicket(),
          //                     ),
          //                   );
        } else if (bnklstVal.status == 'failed') {
          if (!context.mounted) return value;
          CommonFun.instance.showApierror(context, "No Active tickets");
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

  Future fetchTket(Farereq req, BuildContext context, int tktstat) async {
    TktData? value;
    try {
      final bnkLstresp = await Pompaydata().fetchTkt(req);
      String? message;
      if (bnkLstresp == null) {
        if (!context.mounted) return value;
        CommonFun.instance.showApierror(context, "Something went wrong");
        _updateNotifier(tktstat, []);
      } else if (bnkLstresp.statusCode == 200) {
        final resultAsJson = jsonDecode(bnkLstresp.toString());
        final bnklstVal = TicketFetch.fromJson(
          resultAsJson as Map<String, dynamic>,
        );

        if (bnklstVal.status == 'success') {
          final cpaymob = bnklstVal.data ?? [];
          _updateNotifier(tktstat, cpaymob);
        } else if (bnklstVal.status == 'failed') {
          if (!context.mounted) return value;
          CommonFun.instance.showApierror(context, "No Active tickets");
          _updateNotifier(tktstat, []);
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
  }

  void _updateNotifier(int tktstat, List<Ticketview> data) {
    final notifier =
        tktstat == activetkt
            ? getActiveTktListNotifier
            : getDeactiveTktListNotifier;

    notifier.value = [...data];
    notifier.notifyListeners();
  }
}
