import 'dart:convert';
import 'package:pompompay/core/hook/hooks.dart';
import 'package:pompompay/infrastructure/model/fare/trans_resp/trans_resp.dart';
import 'package:pompompay/infrastructure/model/fare/transactionresp/transactionresp.dart';

class TicketFun {
  TicketFun._internal();
  static TicketFun instance = TicketFun._internal();
  TicketFun factory() {
    return instance;
  }

  ValueNotifier<List<Ticketview>> getActiveTktListNotifier = ValueNotifier([]);
  ValueNotifier<List<Ticketview>> getDeactiveTktListNotifier = ValueNotifier(
    [],
  );
  ValueNotifier<List<Ticketview>> getHistoryTktListNotifier = ValueNotifier([]);

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
      final loadingProvider = context.read<LoadingProvider>();
      loadingProvider.show();
      final bnkLstresp = await Pompaydata().calculateFare(req);
      String? message;
      loadingProvider.resetAll();

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
      final loadingProvider = context.read<LoadingProvider>();
      loadingProvider.show();
      final bnkLstresp = await Pompaydata().ticketSave(req);
      String? message;
      loadingProvider.resetAll();

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
          CommonFun.instance.showApierror(context, "Ticket generation failed. Something went wrong.");
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

  Future<Datatkt?> paymentStatusUpdt(
    TicketsaveReq req,
    BuildContext context,
  ) async {
    Datatkt? value;
    try {
      final bnkLstresp = await Pompaydata().paymntUpdate(req);
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

  Future fetchTket(Farereq req, BuildContext context) async {
    TktData? value;
    List<Ticketview>? allTickets;
    try {
      final bnkLstresp = await Pompaydata().fetchTkt(req);
      String? message;
      if (bnkLstresp == null) {
        if (!context.mounted) return value;
        CommonFun.instance.showApierror(context, "Something went wrong");
        // _updateNotifier(tktstat, []);
      } else if (bnkLstresp.statusCode == 200) {
        final resultAsJson = jsonDecode(bnkLstresp.toString());
        final bnklstVal = TicketFetch.fromJson(
          resultAsJson as Map<String, dynamic>,
        );

        if (bnklstVal.status == 'success') {
          allTickets = bnklstVal.data ?? [];

          if (req.ticketstatus == 0) {
            getHistoryTktListNotifier.value = [...allTickets];
            getHistoryTktListNotifier.notifyListeners();
          } else {
            final activeTickets = allTickets.where((t) {
              final s = int.tryParse(t.status.toString());
              return s == 0;
            }).toList();

            final deactiveTickets = allTickets.where((t) {
              final s = int.tryParse(t.status.toString());
              return s == 1 || s == 2 || s == 3 || s == 4;
            }).toList();

            getActiveTktListNotifier.value = [...activeTickets];
            getActiveTktListNotifier.notifyListeners();

            getDeactiveTktListNotifier.value = [...deactiveTickets];
            getDeactiveTktListNotifier.notifyListeners();
          }
        } else if (bnklstVal.status == 'failed') {
          if (!context.mounted) return value;
          CommonFun.instance.showApierror(context, "Tickets not available");
          //_updateNotifier(tktstat, []);
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

  // Future<TransResponse?> ticketStatus(Farereq req, BuildContext context) async {
  //   TransResponse? value;
  //   try {
  //     final bnkLstresp = await Pompaydata().ticketStatus(req);
  //     String? message;
  //     if (bnkLstresp == null) {
  //       if (!context.mounted) return value;
  //       CommonFun.instance.showApierror(context, "Something went wrong");
  //     } else if (bnkLstresp.statusCode == 200) {
  //       final resultAsJson = jsonDecode(bnkLstresp.toString());
  //       final bnklstVal = TransResp.fromJson(
  //         resultAsJson as Map<String, dynamic>,
  //       );

  //       if (bnklstVal.status == 'success') {
  //         final cpaymob = bnklstVal.data;
  //         return cpaymob;
  //       } else if (bnklstVal.status == 'failed') {
  //         if (!context.mounted) return value;
  //         CommonFun.instance.showApierror(context, "No tickets found");
  //         return value;
  //       }
  //     } else if (message == 'Unauthenticated' || bnkLstresp.statusCode == 401) {
  //       if (!context.mounted) return value;
  //       CommonFun.instance.showApierror(context, "Unauthenticated");
  //     } else if (bnkLstresp.statusCode == 500) {
  //       if (!context.mounted) return value;
  //       CommonFun.instance.showApierror(context, "Sever Not reached");
  //       // showLoginerror(context, 3);
  //     } else if (bnkLstresp.statusCode == 408) {
  //       if (!context.mounted) return value;
  //       CommonFun.instance.showApierror(context, "Connection time out");

  //       //showLoginerror(context, 4);
  //     } else {
  //       if (!context.mounted) return value;

  //       CommonFun.instance.showApierror(context, "Something went wrong");
  //       //showLoginerror(context, 5);
  //     }
  //   } catch (e) {
  //     if (!context.mounted) return value;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('An unexpected error occurred')),
  //     );
  //   }
  //   return null;
  // }
  // void _updateNotifier(int tktstat, List<Ticketview> data) {
  //   final notifier =
  //       tktstat == activetkt
  //           ? getActiveTktListNotifier
  //           : getDeactiveTktListNotifier;

  //   notifier.value = [...data];
  //   notifier.notifyListeners();
  // }
  Future<Transactionresp?> ckeckPayStatus(
    Farereq req,
    BuildContext context,
  ) async {
    Transactionresp? value;
    try {
      final bnkLstresp = await Pompaydata().checkPayStatus(req);
      String? message;
      if (bnkLstresp == null) {
        if (!context.mounted) return value;
        CommonFun.instance.showApierror(context, "Something went wrong");
      } else if (bnkLstresp.statusCode == 200) {
        final resultAsJson = jsonDecode(bnkLstresp.toString());
        final bnklstVal = TransResp.fromJson(
          resultAsJson as Map<String, dynamic>,
        );

        if (bnklstVal.status == 'success') {
          final cpaymob = bnklstVal.data;
          return cpaymob;
        } else if (bnklstVal.status == 'failed') {
          final cpaymob = bnklstVal.data;
          return cpaymob;
          // if (!context.mounted) return value;
          // CommonFun.instance.showApierror(context, "No tickets found");
        }
      } else if (message == 'Unauthenticated' || bnkLstresp.statusCode == 401) {
        if (!context.mounted) return value;
        CommonFun.instance.showApierror(context, "Unauthenticated");
      } else if (bnkLstresp.statusCode == 500) {
        if (!context.mounted) return value;
        CommonFun.instance.showApierror(context, "Sever Not reached");
      } else if (bnkLstresp.statusCode == 408) {
        if (!context.mounted) return value;
        CommonFun.instance.showApierror(context, "Connection time out");
      } else {
        if (!context.mounted) return value;

        CommonFun.instance.showApierror(context, "Something went wrong");
      }
    } catch (e) {
      if (!context.mounted) return value;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    }
    return null;
  }
}
