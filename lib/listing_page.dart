import 'package:arovia/data_model.dart';
import 'package:arovia/data_provider.dart';
import 'package:arovia/widgets/greeting_header.dart';
import 'package:arovia/widgets/profile_photo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ListingPage extends StatefulWidget {
  ListingPage(
      {super.key,
      required this.headtitle,
      required this.response,
      required this.subscripPayment});
  final headtitle;
  final subscripPayment;
  Result? response;

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  int? selectedIndex;
  int? pkaID;
  int? pkid;
  int? assistantID;
  int? patientID;
  String? amountPending;

  String? patientName;
  int? searchQuery;
  int? itemStatusCount;
  int? itemResponseCount;
  String? statusforapp;
  String? appntforapp;
  String? mobforapp;
  String? patNameforapp;

  String loginUserMobileNo = "";
  List<ResultElement?> status = [];
  List<ResultElement?> filteredStatus = [];
  bool isDoctorLogin = false;
  FocusNode searchFocusNode = FocusNode();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _loadUserLoginType();
      _filteredData('');
    });
  }

  Future<void> _loadUserLoginType() async {
    final prefs = await SharedPreferences.getInstance();
    pkid = prefs.getInt('pkID');

    // Load the login type and trigger rebuild
    bool doctorLogin = prefs.getBool('isDoctorLogin') ?? false;

    if (mounted) {
      setState(() {
        isDoctorLogin = doctorLogin;
      });
    }

    print("isDoctorLogin loaded: $isDoctorLogin");

    // Now safe to filter data
    _filteredData('');

    loginUserMobileNo =  prefs.getString('login_user') ?? "";
  }

  void _filteredData(String query) {
    if (widget.headtitle == 'Completed Appointment') {
      setState(() {
        status.clear();
        status = (widget.response?.result ?? [])
            .where((statuses) => (statuses.status ?? '').contains('Completed'))
            .toList();
        // print('Completed Response:------ ${status[0]?.status}');

        if (query.length > 2) {
          status = status
              .where(
                  (q) => (q?.patiantName ?? '').toLowerCase().contains(query))
              .toList();
        }
      });
    } else if (widget.headtitle == 'Cancelled Appointment') {
      setState(() {
        status.clear();
        status = (widget.response?.result ?? [])
            .where((statuses) => (statuses.status ?? '').contains('Cancelled'))
            .toList();
        // print('Cancelled Response:------ ${status[0]?.status}');
        if (query.length > 2) {
          status = status
              .where(
                  (q) => (q?.patiantName ?? '').toLowerCase().contains(query))
              .toList();
        }
      });
    } else if (widget.headtitle == 'Scheduled Appointment') {
      setState(() {
        status.clear();
        status = (widget.response?.result ?? [])
            .where((statuses) => (statuses.status ?? '').contains('Scheduled'))
            .toList();
        // print('Scheduled Response:------ ${status[0]?.status}');
        if (query.length > 2) {
          status = status
              .where(
                  (q) => (q?.patiantName ?? '').toLowerCase().contains(query))
              .toList();
        }
      });
    } else if (widget.headtitle == 'Pending Payments') {
      setState(() {
        status.clear();
        status = (widget.response?.result ?? [])
            .where((statuses) =>
                (statuses.status ?? '').contains('Amount Pending'))
            .toList();
        // print('Pending Payments Response:------ ${status[0]?.status}');
        if (query.length > 2) {
          status = status
              .where(
                  (q) => (q?.patiantName ?? '').toLowerCase().contains(query))
              .toList();
        }
      });
    }
    itemStatusCount = status.length ?? 0;
    itemResponseCount = widget.response?.result.length ?? 0;
  }


  Future<void> _refreshListData(DataProvider dataProvider, String searchText) async {
    print("_refreshListData isDoctorLogin :: $isDoctorLogin");
    // Refresh the appointment list
    if (isDoctorLogin) {
      // await dataProvider.getPendingAppointmentListDoctor('', pkid ?? 0);
      await dataProvider.getAssistant("", pkid ?? 0);
      setState(() {
        // widget.response = dataProvider.pendingAppointmentListDoctorResponse;
        widget.response = dataProvider.assistantResponse;
      });
    } else {
     await dataProvider.getPendingAppointmentListAssistant('', pkid ?? 0);
      setState(() {
        widget.response = dataProvider.pendingAppointmentListAssistantResponse;
      });
    }
    if (mounted) {
      setState(() {
        selectedIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final userDetail = dataProvider.userDetailResponse;
    if (userDetail == null || userDetail.result.isEmpty) {
      return const Center(child: Text("No User Data Found"));
    }
    final user = userDetail.result.first;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFFAA61C), // Orange
        toolbarHeight: 120,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            profilePhotoWidget(user.profilePhoto),
            const SizedBox(width: 12),
            Expanded(
              child: GreetingHeader(
                firstName: user.firstName ?? "",
                lastName: user.lastName ?? "",
                memberType: isDoctorLogin ? "Doctor" : "Assistant",
              ),


              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     const Text(
              //       "Hi, Welcome Back,",
              //       style: TextStyle(
              //         fontSize: 16,
              //         color: Color(0xFF858585),
              //       ),
              //     ),
              //     const SizedBox(height: 4),
              //     Text(
              //       isDoctorLogin == true ? "Dr. ${user.firstName} ${user.lastName}"
              //       : "${user.firstName} ${user.lastName}",
              //       style: const TextStyle(
              //         fontSize: 18,
              //         fontWeight: FontWeight.w600,
              //         color: Colors.black,
              //       ),
              //     ),
              //   ],
              // ),
            ),
            // const Icon(Icons.notifications_none, size: 28, color: Colors.black),
          ],
        ),
      ),
      backgroundColor: const Color.fromRGBO(251, 246, 227, 1),
      resizeToAvoidBottomInset: true,
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, child) {
          return Column(
            children: [
              if (widget.headtitle != 'Subscription')
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            focusNode: searchFocusNode,
                            onChanged: (value) async {
                              print("Typed text: $value");
                              if ((value.length > 2) || (value.isEmpty)) {
                                switch (widget.headtitle) {
                                  case 'Completed Appointment':
                                    _filteredData(value);
                                    break;

                                  case 'Cancelled Appointment':
                                    _filteredData(value);
                                    break;

                                  case 'Scheduled Appointment':
                                    _filteredData(value);
                                    break;

                                  case 'Pending Payments':
                                    _filteredData(value);
                                    break;

                                  case 'Patients':
                                    isDoctorLogin
                                        ? await dataProvider
                                            .getPatientListDoctor(
                                                value, pkid ?? 0)
                                        : await dataProvider
                                            .getPatientListAssistant(
                                                value, pkid ?? 0);
                                    widget.response = isDoctorLogin
                                        ? dataProvider.patientListDoctorResponse
                                        : dataProvider
                                            .patientListAssistantResponse;
                                    break;

                                  case 'Assistant':
                                    await dataProvider.getAssistant(
                                        value, pkid ?? 0);
                                    widget.response =
                                        dataProvider.assistantResponse;
                                    break;
                                }
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: 'Search',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (widget.headtitle == 'Subscription')
                      const SizedBox(height: 16),
                    Row(
                      children: [
                        IconButton(
                          iconSize: 32,
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.headtitle ?? '',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    (widget.headtitle == 'Subscription')
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                _subscriptionPage(
                                    'assets/sandclock.png',
                                    'Time left :',
                                    widget.response?.timeleft ?? '',
                                    "",
                                    false),
                                _subscriptionPage(
                                    'assets/calendar.png',
                                    'Expiry Date :',
                                    widget.response?.expiry ?? '',
                                    "",
                                    false),
                                _subscriptionPage(
                                    'assets/status.png',
                                    'Status :',
                                    widget.response?.subsciptionStatus ?? '',
                                    "",
                                    false),
                                _subscriptionPage(
                                    'assets/rupee.png',
                                    'Amount :',
                                    widget.response?.amount ?? '',
                                    widget.subscripPayment,
                                    true),
                              ],
                            ))
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                // color: const Color(0xFF1C2A4D),
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  // Buttons Row
                                  Padding(
                                    padding: EdgeInsets.all(((widget
                                                    .headtitle ==
                                                'Scheduled Appointment') ||
                                            (widget.headtitle == 'Assistant'))
                                        ? 16.0
                                        : 0),
                                    child: Row(
                                      children: [
                                        if (widget.headtitle ==
                                                'Scheduled Appointment' ||
                                            widget.headtitle == 'Assistant')
                                          // _buildTopButton(
                                          //     Icons.delete, 'Delete', () async{
                                          //   if (selectedIndex != null) {
                                          //
                                          //     if (widget.headtitle ==
                                          //         'Scheduled Appointment') {
                                          //       await dataProvider
                                          //           .getCancelAppointment(
                                          //           '', pkaID ?? 0, 1);
                                          //       isDoctorLogin
                                          //           ? await dataProvider
                                          //           .getPendingAppointmentListDoctor(
                                          //           '', pkid ?? 0)
                                          //           : await dataProvider
                                          //           .getPendingAppointmentListAssistant(
                                          //           '', pkid ?? 0);
                                          //
                                          //       setState(()  {
                                          //         widget.response = isDoctorLogin
                                          //             ? dataProvider
                                          //             .pendingAppointmentListDoctorResponse
                                          //             : dataProvider
                                          //         .pendingAppointmentListAssistantResponse;
                                          //         selectedIndex = null;
                                          //       });
                                          //
                                          //     } else {
                                          //       await dataProvider.getDeleteAssistant(
                                          //           widget
                                          //               .response
                                          //               ?.result[
                                          //           selectedIndex ??
                                          //               0]
                                          //               .pkMainMemberMasterId ??
                                          //               0,
                                          //           pkid ?? 0);
                                          //       await dataProvider
                                          //           .getAssistant(
                                          //           '', pkid ?? 0);
                                          //       widget.response = dataProvider
                                          //           .assistantResponse;
                                          //     }
                                          //
                                          //     ScaffoldMessenger.of(context)
                                          //         .showSnackBar(const SnackBar(
                                          //         content: Text(
                                          //             "Deleted Successfully")));
                                          //   } else {
                                          //     ScaffoldMessenger.of(context)
                                          //         .showSnackBar(const SnackBar(
                                          //             content: Text(
                                          //                 "Please select member to delete")));
                                          //   }
                                          // }),
                                          _buildTopButton(Icons.delete, 'Delete', () async {
                                            if (selectedIndex == null) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text("Please select member to delete")),
                                              );
                                              return;
                                            }

                                            try {
                                              if (widget.headtitle == 'Scheduled Appointment') {
                                                // Cancel the appointment
                                                await dataProvider.getCancelAppointment('', pkaID ?? 0, 1);

                                                // Refresh the appointment list
                                                if (isDoctorLogin) {
                                                  await dataProvider.getPendingAppointmentListDoctor('', pkid ?? 0);
                                                } else {
                                                  await dataProvider.getPendingAppointmentListAssistant('', pkid ?? 0);
                                                }

                                                // Update the response from provider
                                                final newResponse = isDoctorLogin
                                                    ? dataProvider.pendingAppointmentListDoctorResponse
                                                    : dataProvider.pendingAppointmentListAssistantResponse;

                                                // Trigger rebuild with new data
                                                if (mounted) {
                                                  setState(() {
                                                    widget.response = newResponse;
                                                    selectedIndex = null;
                                                  });
                                                }
                                              } else if (widget.headtitle == 'Assistant') {
                                                // Delete assistant
                                                await dataProvider.getDeleteAssistant(
                                                  widget.response?.result[selectedIndex!].pkMainMemberMasterId ?? 0,
                                                  pkid ?? 0,
                                                );

                                                // Refresh assistant list
                                                await dataProvider.getAssistant('', pkid ?? 0);

                                                if (mounted) {
                                                  setState(() {
                                                    widget.response = dataProvider.assistantResponse;
                                                    selectedIndex = null;
                                                  });
                                                }
                                              }

                                              // Re-apply any active search filter
                                              _filteredData(searchController.text);

                                              // Show success message
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text("Deleted Successfully")),
                                              );
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text("Delete failed. Please try again.")),
                                              );
                                            }
                                          }),
                                        const SizedBox(width: 8),
                                        if (widget.headtitle ==
                                                'Scheduled Appointment' ||
                                            widget.headtitle == 'Assistant')
                                          // _buildTopButton(
                                          //     Icons.person_add, 'Add', () {
                                          //   setState(() async {
                                          //     var loginID = pkid;
                                          //     var moduleID = (widget
                                          //                 .headtitle ==
                                          //             'Scheduled Appointment')
                                          //         ? isDoctorLogin
                                          //             ? 1
                                          //             : 6
                                          //         : 4;
                                          //     var title = (widget.headtitle ==
                                          //             'Scheduled Appointment')
                                          //         ? 'Scheduled Appointment'
                                          //         : 'Assistant';
                                          //
                                          //     await dataProvider.getWeblink(
                                          //         loginID ?? 0,
                                          //         moduleID,
                                          //         0,
                                          //         0,
                                          //         0,
                                          //         0,
                                          //         0,
                                          //         '');
                                          //     print(
                                          //         'WEBLINK RESULT------${dataProvider.weblinkResponse?.result}');
                                          //    var result = Navigator.pushNamed(
                                          //         context, '/webView',
                                          //         arguments: {
                                          //           'url': dataProvider
                                          //               .weblinkResponse
                                          //               ?.result,
                                          //           'webTitle': title
                                          //         });
                                          //    if(result == true){
                                          //      print("result :: $result");
                                          //      final prefs = await SharedPreferences.getInstance();
                                          //      pkid = prefs.getInt('pkID');
                                          //      await dataProvider.getAppointmentListDoctor(
                                          //          '', pkid!);
                                          //      widget.response =
                                          //          dataProvider.appointmentListDoctorResponse;
                                          //
                                          //    }
                                          //   });
                                          // }),
                                          _buildTopButton(Icons.person_add, 'Add', () async {
                                            var loginID = pkid;
                                            var moduleID = (widget.headtitle == 'Scheduled Appointment')
                                                ? isDoctorLogin ? 1 : 6
                                                : 4;
                                            var title = (widget.headtitle == 'Scheduled Appointment')
                                                ? 'Scheduled Appointment'
                                                : 'Assistant';

                                            await dataProvider.getWeblink(
                                                loginID ?? 0, moduleID, 0, 0, 0, loginID ?? 0, 0, '');

                                            final result = await Navigator.pushNamed(
                                              context,
                                              '/webView',
                                              arguments: {
                                                'url': dataProvider.weblinkResponse?.result,
                                                'webTitle': title
                                              },
                                            );

                                            // If user came back and action was successful (you popped with true)
                                            if (result == true && mounted) {
                                              // Refresh the appropriate list
                                              if (widget.headtitle == 'Scheduled Appointment') {
                                                if(isDoctorLogin){
                                                  await dataProvider.getPendingAppointmentListDoctor('', pkid ?? 0);
                                                  // Or use assistant version if needed
                                                  setState(() {
                                                    widget.response = dataProvider.pendingAppointmentListDoctorResponse;
                                                  });
                                                }else{
                                                  await dataProvider.getPendingAppointmentListAssistant('', pkid ?? 0);
                                                  // Or use assistant version if needed
                                                  setState(() {
                                                    widget.response = dataProvider.pendingAppointmentListAssistantResponse;
                                                  });
                                                }
                                              } else if (widget.headtitle == 'Assistant') {
                                                await dataProvider.getAssistant('', pkid ?? 0);
                                                setState(() {
                                                  widget.response = dataProvider.assistantResponse;
                                                });
                                              }
                                              _filteredData(''); // Reapply any active search filter
                                            }
                                          }),
                                        const SizedBox(width: 8),
                                        if (widget.headtitle ==
                                                'Scheduled Appointment' ||
                                            widget.headtitle == 'Assistant')
                                          // _buildTopButton(Icons.edit, 'Edit',
                                          //     () {
                                          //   if (selectedIndex != null) {
                                          //     setState(() async {
                                          //       var loginID = pkid;
                                          //       var moduleID = (widget
                                          //                   .headtitle ==
                                          //               'Scheduled Appointment')
                                          //           ? isDoctorLogin
                                          //               ? 1
                                          //               : 6
                                          //           : 4;
                                          //       var appntID = pkaID;
                                          //       var patntID = patientID;
                                          //       var assisID = assistantID;
                                          //       var title = (widget.headtitle ==
                                          //               'Scheduled Appointment')
                                          //           ? 'Scheduled Appointment'
                                          //           : 'Assistant';
                                          //
                                          //       await dataProvider.getWeblink(
                                          //           loginID ?? 0,
                                          //           moduleID,
                                          //           appntID ?? 0,
                                          //           patntID ?? 0,
                                          //           assisID ?? 0,
                                          //           (widget.headtitle ==
                                          //                   'Assistant')
                                          //               ? loginID ?? 0
                                          //               : 0,
                                          //           0,
                                          //           '');
                                          //       print(
                                          //           'WEBLINK RESULT------${dataProvider.weblinkResponse?.result}');
                                          //       Navigator.pushNamed(
                                          //           context, '/webView',
                                          //           arguments: {
                                          //             'url': dataProvider
                                          //                 .weblinkResponse
                                          //                 ?.result,
                                          //             'webTitle': title
                                          //           });
                                          //
                                          //       selectedIndex = null;
                                          //     });
                                          //   } else {
                                          //     ScaffoldMessenger.of(context)
                                          //         .showSnackBar(const SnackBar(
                                          //             content: Text(
                                          //                 "Please select member to Edit")));
                                          //   }
                                          // }),

                                          _buildTopButton(Icons.edit, 'Edit', () async {
                                            if (selectedIndex == null) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text("Please select member to Edit")),
                                              );
                                              return;
                                            }

                                            var loginID = pkid;
                                            var moduleID = (widget.headtitle == 'Scheduled Appointment')
                                                ? isDoctorLogin ? 1 : 6
                                                : 4;
                                            var appntID = pkaID;
                                            var patntID = patientID;
                                            var assisID = assistantID;
                                            var title = (widget.headtitle == 'Scheduled Appointment')
                                                ? 'Scheduled Appointment'
                                                : 'Assistant';

                                            await dataProvider.getWeblink(
                                              loginID ?? 0,
                                              moduleID,
                                              appntID ?? 0,
                                              patntID ?? 0,
                                              assisID ?? 0,
                                              (widget.headtitle == 'Assistant') ? loginID ?? 0 : 0,
                                              0,
                                              '',
                                            );

                                            final result = await Navigator.pushNamed(
                                              context,
                                              '/webView',
                                              arguments: {
                                                'url': dataProvider.weblinkResponse?.result,
                                                'webTitle': title
                                              },
                                            );

                                            if (result == true && mounted) {
                                              print("isDoctorLogin :: $isDoctorLogin");
                                              if (widget.headtitle == 'Scheduled Appointment') {
                                                // await dataProvider.getPendingAppointmentListDoctor('', pkid ?? 0);
                                                // // Or assistant version
                                                // setState(() {
                                                //   widget.response = dataProvider.pendingAppointmentListDoctorResponse;
                                                // });
                                                if(isDoctorLogin){
                                                  await dataProvider.getPendingAppointmentListDoctor('', pkid ?? 0);
                                                  // Or use assistant version if needed
                                                  setState(() {
                                                    widget.response = dataProvider.pendingAppointmentListDoctorResponse;
                                                  });
                                                }else{
                                                  await dataProvider.getPendingAppointmentListAssistant('', pkid ?? 0);
                                                  // Or use assistant version if needed
                                                  setState(() {
                                                    widget.response = dataProvider.pendingAppointmentListAssistantResponse;
                                                  });
                                                }
                                              } else if (widget.headtitle == 'Assistant') {
                                                await dataProvider.getAssistant('', pkid ?? 0);
                                                setState(() {
                                                  widget.response = dataProvider.assistantResponse;
                                                });
                                              }
                                              _filteredData(''); // Reapply search filter if any
                                              selectedIndex = null; // Clear selection
                                            }
                                          }),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 12),
                                    // color: const Color(0xFF1B2235),
                                    decoration: BoxDecoration(
                                      // color: const Color(0xFF1C2A4D),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                          ((widget.headtitle !=
                                                      'Scheduled Appointment') &&
                                                  (widget.headtitle !=
                                                      'Assistant'))
                                              ? 20
                                              : 0),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 10),
                                        Expanded(
                                            child: Text(
                                                (widget.headtitle ==
                                                        'Subscription')
                                                    ? 'Plans'
                                                    : 'Name',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600))),
                                        const Spacer(),
                                        Text(
                                            (widget.headtitle == 'Patients' ||
                                                    widget.headtitle ==
                                                        'Assistant')
                                                ? 'Phone No.'
                                                : 'Status',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600)),
                                        const SizedBox(width: 50),
                                        // if ((widget.headtitle != 'Appointment') && (widget.headtitle != 'Assistant'))
                                        const Text('View',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600)),
                                        const SizedBox(width: 20),
                                      ],
                                    ),
                                  ),

                                  // Scrollable List
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: SizedBox(
                                      height: ((widget.headtitle ==
                                                  'Scheduled Appointment') ||
                                              (widget.headtitle == 'Assistant'))
                                          ? MediaQuery.of(context).size.height -
                                              422
                                          : MediaQuery.of(context).size.height -
                                              355,
                                      child: Builder(builder: (context) {
                                        final isStatusList =
                                            (widget.headtitle ==
                                                    'Completed Appointment' ||
                                                widget.headtitle ==
                                                    'Cancelled Appointment' ||
                                                widget.headtitle ==
                                                    'Scheduled Appointment' ||
                                                widget.headtitle ==
                                                    'Pending Payments');

                                        final itemCount = isStatusList
                                            ? status.length
                                            : (widget.response?.result.length ??
                                                0);

                                        if (itemCount == 0) {
                                          return const Center(
                                            child: Text(
                                              'Record Not Found',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          );
                                        }
                                        return ListView.separated(
                                          itemCount: itemCount,
                                          separatorBuilder: (_, __) =>
                                              const Divider(
                                                  height: 1,
                                                  color: Colors.black45),
                                          itemBuilder: (context, index) {
                                            final isSelected =
                                                selectedIndex == index;
                                            final isStatusList = (widget.headtitle == 'Completed Appointment' ||
                                                widget.headtitle == 'Cancelled Appointment' ||
                                                widget.headtitle == 'Scheduled Appointment' ||
                                                widget.headtitle == 'Pending Payments');

                                            // 1. GET THE CORRECT DATA ITEM
                                            // If we are in a filtered list, use 'status[index]', otherwise use 'response.result[index]'
                                            final item = isStatusList ? status[index] : widget.response?.result[index];

                                            // 2. PARSE THE DATE SAFELY
                                            bool isAppointmentExpired = false;

                                            // Only check expiration if the status is actually 'Scheduled'
                                            if (item?.status == 'Scheduled' && item?.appointmentDate != null) {
                                              try {
                                                // Your JSON format is "31/1/2026 15:25" which matches "d/M/yyyy HH:mm"
                                                final inputFormat = DateFormat("d/M/yyyy HH:mm");
                                                final DateTime apptDate = inputFormat.parse(item!.appointmentDate!);

                                                // Check if NOW is after the appointment date
                                                isAppointmentExpired = DateTime.now().isAfter(apptDate);
                                              } catch (e) {
                                                print("Error parsing date for ${item?.patiantName}: $e");
                                                isAppointmentExpired = false;
                                              }
                                            }

                                            // final inputFormat = DateFormat("d/M/yyyy HH:mm");
                                            //
                                            // final apptDateString =
                                            //     widget.response?.result[index].appointmentDate;
                                            //
                                            // DateTime? apptDate;
                                            //
                                            // if (apptDateString != null && apptDateString.isNotEmpty) {
                                            //   apptDate = inputFormat.parse(apptDateString);
                                            // }
                                            //
                                            // final bool isAppointmentExpired =
                                            //     apptDate != null &&
                                            //         widget.response?.result[index].status == 'Scheduled' &&
                                            //         apptDate.isBefore(DateTime.now());


                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedIndex = index;

                                                  if (widget.headtitle == 'Completed Appointment' ||
                                                      widget.headtitle ==
                                                          'Cancelled Appointment' ||
                                                      widget.headtitle ==
                                                          'Scheduled Appointment' ||
                                                      widget.headtitle ==
                                                          'Pending Payments') {
                                                    pkaID = status[index]
                                                            ?.pkAppointmentId ??
                                                        0;
                                                    patientID = status[index]
                                                            ?.fkPatientId ??
                                                        0;
                                                    assistantID = status[index]
                                                            ?.pkMainMemberMasterId ??
                                                        0;
                                                  } else {
                                                    pkaID = widget
                                                            .response
                                                            ?.result[index]
                                                            .pkAppointmentId ??
                                                        0;
                                                    patientID = widget
                                                            .response
                                                            ?.result[index]
                                                            .fkPatientId ??
                                                        0;
                                                    assistantID = widget
                                                            .response
                                                            ?.result[index]
                                                            .pkMainMemberMasterId ??
                                                        0;
                                                  }
                                                  if (widget.headtitle ==
                                                      'Patients') {
                                                    patientID = widget
                                                            .response
                                                            ?.result[index]
                                                            .pkPatientId ??
                                                        0;
                                                  }
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: isAppointmentExpired ? const Color(
                                                      0xFFEFC8E6):Colors.white70,
                                                  // color: Colors.white70,
                                                  // borderRadius:
                                                  //     BorderRadius.circular(20),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 14),
                                                child: Row(
                                                  children: [
                                                    (widget.headtitle ==
                                                                'Completed Appointment' ||
                                                            widget.headtitle ==
                                                                'Cancelled Appointment' ||
                                                            widget.headtitle ==
                                                                'Patients' ||
                                                            widget.headtitle ==
                                                                'Pending Payments')
                                                        ? SizedBox()
                                                        : Icon(
                                                            isSelected
                                                                ? Icons
                                                                    .radio_button_checked
                                                                : Icons
                                                                    .radio_button_unchecked,
                                                            size: 16,
                                                            color: Colors.black,
                                                          ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                          (widget.headtitle ==
                                                                  'Assistant')
                                                              ? widget
                                                                      .response
                                                                      ?.result[
                                                                          index]
                                                                      .name ??
                                                                  ''
                                                              : ((widget
                                                                              .headtitle ==
                                                                          'Completed Appointment') ||
                                                                      (widget.headtitle ==
                                                                          'Cancelled Appointment') ||
                                                                      (widget.headtitle ==
                                                                          'Scheduled Appointment') ||
                                                                      widget.headtitle ==
                                                                          'Pending Payments')
                                                                  ?
                                                          status[index]
                                                                          ?.patiantName ??
                                                                      ''
                                                                  : widget
                                                                          .response
                                                                          ?.result[
                                                                              index]
                                                                          .patiantName ??
                                                                      '',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis)),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedIndex = index;
                                                          if (widget.headtitle == 'Completed Appointment' ||
                                                              widget.headtitle ==
                                                                  'Cancelled Appointment' ||
                                                              widget.headtitle ==
                                                                  'Scheduled Appointment' ||
                                                              widget.headtitle ==
                                                                  'Pending Payments') {
                                                            pkaID = status[
                                                                        index]
                                                                    ?.pkAppointmentId ??
                                                                0;
                                                            patientID = status[
                                                                        index]
                                                                    ?.fkPatientId ??
                                                                0;
                                                            assistantID = status[
                                                                        index]
                                                                    ?.pkMainMemberMasterId ??
                                                                0;
                                                          } else {
                                                            pkaID = widget
                                                                    .response
                                                                    ?.result[
                                                                        index]
                                                                    .pkAppointmentId ??
                                                                0;
                                                            patientID = widget
                                                                    .response
                                                                    ?.result[
                                                                        index]
                                                                    .fkPatientId ??
                                                                0;
                                                            assistantID = widget
                                                                    .response
                                                                    ?.result[
                                                                        index]
                                                                    .pkMainMemberMasterId ??
                                                                0;
                                                          }
                                                          if (widget
                                                                  .headtitle ==
                                                              'Patients') {
                                                            patientID = widget
                                                                    .response
                                                                    ?.result[
                                                                        index]
                                                                    .pkPatientId ??
                                                                0;
                                                          }
                                                        });
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10,
                                                                vertical: 4),
                                                        decoration:
                                                            BoxDecoration(
                                                          // color: const Color(0xFFE6F2FA),
                                                          color: isAppointmentExpired ? Color(
                                                              0xFFEFC8E6) : Colors.white70,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
                                                        child: Text(
                                                            (widget.headtitle ==
                                                                    'Patients')
                                                                ? widget
                                                                        .response
                                                                        ?.result[
                                                                            index]
                                                                        .patiantMobileNumber ??
                                                                    ''
                                                                : (widget.headtitle ==
                                                                        'Assistant')
                                                                    ? widget
                                                                            .response
                                                                            ?.result[
                                                                                index]
                                                                            .mobileNumber ??
                                                                        ''
                                                                    : ((widget.headtitle == 'Completed Appointment') ||
                                                                            (widget.headtitle ==
                                                                                'Cancelled Appointment') ||
                                                                            (widget.headtitle ==
                                                                                'Scheduled Appointment') ||
                                                                            (widget.headtitle ==
                                                                                'Pending Payments'))
                                                                        ? status[index]?.status ??
                                                                            ''
                                                                        : widget.response?.result[index].status ??
                                                                            '',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .blue)),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 50),
                                                    // if ((widget.headtitle != 'Appointment') && (widget.headtitle != 'Assistant'))
                                                    // GestureDetector(
                                                    //   onTap: () {
                                                    //     setState(() async {
                                                    //       selectedIndex = index;
                                                    //       if (widget.headtitle == 'Completed Appointment' ||
                                                    //           widget.headtitle ==
                                                    //               'Cancelled Appointment' ||
                                                    //           widget.headtitle ==
                                                    //               'Scheduled Appointment' ||
                                                    //           widget.headtitle ==
                                                    //               'Pending Payments') {
                                                    //         pkaID = status[
                                                    //                     index]
                                                    //                 ?.pkAppointmentId ??
                                                    //             0;
                                                    //         patientID = status[
                                                    //                     index]
                                                    //                 ?.fkPatientId ??
                                                    //             0;
                                                    //         assistantID = status[
                                                    //                     index]
                                                    //                 ?.pkMainMemberMasterId ??
                                                    //             0;
                                                    //       } else {
                                                    //         pkaID = widget
                                                    //                 .response
                                                    //                 ?.result[
                                                    //                     index]
                                                    //                 .pkAppointmentId ??
                                                    //             0;
                                                    //         patientID = widget
                                                    //                 .response
                                                    //                 ?.result[
                                                    //                     index]
                                                    //                 .fkPatientId ??
                                                    //             0;
                                                    //         assistantID = widget
                                                    //                 .response
                                                    //                 ?.result[
                                                    //                     index]
                                                    //                 .pkMainMemberMasterId ??
                                                    //             0;
                                                    //       }
                                                    //       if (widget.headtitle == 'Patients') {
                                                    //         patientID = widget
                                                    //                 .response
                                                    //                 ?.result[
                                                    //                     index]
                                                    //                 .pkPatientId ??
                                                    //             0;
                                                    //         print("Patient Name :: ${widget
                                                    //             .response
                                                    //             ?.result[
                                                    //         index]
                                                    //             .patiantName ??
                                                    //             ''}");
                                                    //         amountPending = widget
                                                    //                 .response
                                                    //                 ?.result[
                                                    //                     index]
                                                    //                 .pendingAmount ??
                                                    //             '';
                                                    //
                                                    //         patientName = widget
                                                    //             .response
                                                    //             ?.result[
                                                    //         index]
                                                    //             .patiantName ?? "";
                                                    //         Navigator.pushNamed(
                                                    //             context,
                                                    //             '/patientDetail',
                                                    //             arguments: {
                                                    //               'patientID':
                                                    //                   patientID,
                                                    //               'amtPending':
                                                    //                   amountPending,
                                                    //               'phoneNo': widget
                                                    //                   .response
                                                    //                   ?.result[
                                                    //                       index]
                                                    //                   .patiantMobileNumber,
                                                    //                 'isDoctorLogin' : isDoctorLogin,
                                                    //               'patientName': patientName
                                                    //             });
                                                    //       } else {
                                                    //      final result = await Navigator.pushNamed(
                                                    //             context,
                                                    //             '/detailScreen',
                                                    //             arguments: {
                                                    //               'headTitle':
                                                    //                   widget
                                                    //                       .headtitle,
                                                    //               'response': widget
                                                    //                   .response,
                                                    //               'indexes':
                                                    //                   index,
                                                    //               'status':
                                                    //                   status
                                                    //             });
                                                    //      if (result == true && mounted &&  widget.headtitle == "Assistant") {
                                                    //        final dataProvider = Provider.of<DataProvider>(context, listen: false);
                                                    //
                                                    //        // Refresh original data depending on login type
                                                    //        // if (isDoctorLogin) {
                                                    //        //   await dataProvider.getPendingAppointmentListDoctor('', pkid ?? 0);
                                                    //        //   widget.response = dataProvider.pendingAppointmentListDoctorResponse;
                                                    //        //
                                                    //        //
                                                    //        //
                                                    //        // }
                                                    //         if (isDoctorLogin) {
                                                    //         await dataProvider.getAssistant("", pkid ?? 0);
                                                    //         setState(() {
                                                    //         widget.response = dataProvider.assistantResponse;
                                                    //         });}
                                                    //        else {
                                                    //          await dataProvider.getPendingAppointmentListAssistant('', pkid ?? 0);
                                                    //          widget.response = dataProvider.pendingAppointmentListAssistantResponse;
                                                    //        }
                                                    //
                                                    //        // Re-apply filter with current search text
                                                    //        _filteredData(searchController.text);
                                                    //
                                                    //        setState(() {
                                                    //          selectedIndex = null;
                                                    //        });
                                                    //      }
                                                    //       }
                                                    //     });
                                                    //     debugPrint(
                                                    //         'Tapped view icon at index $index');
                                                    //   },
                                                    //   child: const Icon(
                                                    //       Icons
                                                    //           .remove_red_eye_outlined,
                                                    //       color: Colors.black),
                                                    // ),

                                                    GestureDetector(
                                                      onTap: () async { // 1. Mark onTap as async
                                                        // 2. Update UI immediately (highlight selection)
                                                        setState(() {
                                                          selectedIndex = index;
                                                        });

                                                        // 3. Perform Logic (Calculation/Variable assignment doesn't need setState)
                                                        if (widget.headtitle == 'Completed Appointment' ||
                                                            widget.headtitle == 'Cancelled Appointment' ||
                                                            widget.headtitle == 'Scheduled Appointment' ||
                                                            widget.headtitle == 'Pending Payments') {
                                                          pkaID = status[index]?.pkAppointmentId ?? 0;
                                                          patientID = status[index]?.fkPatientId ?? 0;
                                                          assistantID = status[index]?.pkMainMemberMasterId ?? 0;
                                                        } else {
                                                          pkaID = widget.response?.result[index].pkAppointmentId ?? 0;
                                                          patientID = widget.response?.result[index].fkPatientId ?? 0;
                                                          assistantID = widget.response?.result[index].pkMainMemberMasterId ?? 0;
                                                        }

                                                        if (widget.headtitle == 'Patients') {
                                                          patientID = widget.response?.result[index].pkPatientId ?? 0;

                                                          amountPending = widget.response?.result[index].pendingAmount ?? '';
                                                          patientName = widget.response?.result[index].patiantName ?? "";

                                                          debugPrint("Patient Name :: $patientName");

                                                          // Navigate (No await needed here unless you rely on the result)
                                                          Navigator.pushNamed(
                                                              context,
                                                              '/patientDetail',
                                                              arguments: {
                                                                'patientID': patientID,
                                                                'amtPending': amountPending,
                                                                'phoneNo': widget.response?.result[index].patiantMobileNumber,
                                                                'isDoctorLogin': isDoctorLogin,
                                                                'patientName': patientName
                                                              }
                                                          );
                                                        } else {
                                                          // 4. Perform Async Navigation
                                                          final result = await Navigator.pushNamed(
                                                              context,
                                                              '/detailScreen',
                                                              arguments: {
                                                                'headTitle': widget.headtitle,
                                                                'response': widget.response,
                                                                'indexes': index,
                                                                'status': status
                                                              }
                                                          );

                                                          // 5. Check if widget is still on screen after await
                                                          if (result == true && mounted && widget.headtitle == "Assistant") {
                                                            final dataProvider = Provider.of<DataProvider>(context, listen: false);

                                                            if (isDoctorLogin) {
                                                              // Perform async data fetch
                                                              await dataProvider.getAssistant("", pkid ?? 0);

                                                              // 6. Update UI with new data
                                                              if (mounted) {
                                                                setState(() {
                                                                  widget.response = dataProvider.assistantResponse;
                                                                });
                                                              }
                                                            } else {
                                                              await dataProvider.getPendingAppointmentListAssistant('', pkid ?? 0);
                                                              // Note: If you need to update widget.response here for non-doctor, add a setState
                                                              widget.response = dataProvider.pendingAppointmentListAssistantResponse;
                                                            }

                                                            // Re-apply filter
                                                            _filteredData(searchController.text);

                                                            // 7. Final UI update (reset selection)
                                                            if (mounted) {
                                                              setState(() {
                                                                selectedIndex = null;
                                                              });
                                                            }
                                                          }
                                                        }
                                                        debugPrint('Tapped view icon at index $index');
                                                      },
                                                      child: const Icon(
                                                          Icons.remove_red_eye_outlined,
                                                          color: Colors.black
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              )),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopButton(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 35,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.black, size: 16),
                const SizedBox(width: 4),
                Text(label, style: const TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String subsData) async {
    final Uri url = Uri.parse(subsData);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Widget _subscriptionPage(
      String img, String header, String subsData, String subsPayData, bool isIconHide) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1C2A4D),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                   Image.asset(
                      img,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      header,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                            subsData,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(250, 166, 28, 1)),
                          ),
                          if(loginUserMobileNo != "9988776655" && loginUserMobileNo !=  "8877665544")...[
                            Spacer(),
                            if (isIconHide)
                              InkWell(
                                onTap: () {
                                  _launchURL(subsPayData);
                                },
                                child: Container(
                                  width: 160,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(250, 166, 28, 1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Text('Pay',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                              )
                          ]

                      ],
                    )
                    // isIconHide
                    //     ? InkWell(
                    //         onTap: () {
                    //           _launchURL(subsData);
                    //         },
                    //         child: Container(
                    //           width: 160,
                    //           decoration: BoxDecoration(
                    //             color: const Color.fromRGBO(250, 166, 28, 1),
                    //             borderRadius: BorderRadius.circular(8),
                    //           ),
                    //           child: const Padding(
                    //             padding: EdgeInsets.all(10.0),
                    //             child: Center(
                    //               child: Text('Pay',
                    //                   style: TextStyle(
                    //                       fontSize: 18,
                    //                       fontWeight: FontWeight.w600,
                    //                       color: Colors.white)),
                    //             ),
                    //           ),
                    //         ),
                    //       )
                    //     : Text(
                    //         subsData,
                    //         style: const TextStyle(
                    //             fontSize: 18,
                    //             fontWeight: FontWeight.bold,
                    //             color: Color.fromRGBO(250, 166, 28, 1)),
                    //       ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
