import 'dart:developer';
import 'package:pompompay/core/hook/hooks.dart';

class ScreenMyTickets extends StatefulWidget {
  const ScreenMyTickets({super.key});

  @override
  State<ScreenMyTickets> createState() => _ScreenMyTicketsState();
}

class _ScreenMyTicketsState extends State<ScreenMyTickets>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return; // avoid intermediate states
      setState(() {}); // Triggers rebuild to reflect active tab visually
      log('Tab changed to: ${_tabController.index}');
    });
  }

  Future<bool?> popscreen(BuildContext context) async {
    TicketFun.instance.getActiveTktListNotifier.value = [];
    TicketFun.instance.getDeactiveTktListNotifier.value = [];

    if (mounted) {
      Navigator.pushReplacement(context, Approutes().mainScreen);
    }
    return true;
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
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.03,
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
                            TicketFun.instance.getActiveTktListNotifier.value =
                                [];
                            TicketFun
                                .instance
                                .getDeactiveTktListNotifier
                                .value = [];

                            Navigator.pushReplacement(
                              context,
                              Approutes().mainScreen,
                            );
                          },
                        ),
                      ),
                      Center(
                        child: Text(
                          'My Tickets',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                        dividerColor: Colors.white,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xffffa600),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: const [Tab(text: "Active"), Tab(text: "History")],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: const [
                            TicketListWidget(ticketStatus: activetkt),
                            TicketListWidget(ticketStatus: deactivetkt),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
