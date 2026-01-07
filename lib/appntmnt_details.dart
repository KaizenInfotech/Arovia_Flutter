import 'package:arovia/data_model.dart';
import 'package:arovia/data_provider.dart';
import 'package:arovia/listing_page.dart';
import 'package:arovia/widgets/greeting_header.dart';
import 'package:arovia/widgets/profile_photo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentDetailPage extends StatefulWidget {
  const AppointmentDetailPage(
      {super.key,
      required this.isDoctorLogin,
      required this.pkID,
      required this.response});
  final bool? isDoctorLogin;
  final int? pkID;
  final Result? response;

  @override
  State<AppointmentDetailPage> createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  // int? selectedIndex;
  // int? pkaID;
  // int? pkid;
  Result? response;

  @override
  void initState() {
    super.initState();
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
                memberType: widget.isDoctorLogin! ? "Doctor" : "Assistant",
              )
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
              //       (widget.isDoctorLogin ?? false) ? "Dr. ${user.firstName} ${user.lastName}"
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
          return SingleChildScrollView(
            child: Column(
              children: [
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
                    const Text(
                      'Appointments',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _apntmntContainer('Scheduled\nAppointment', () async {
                      print('Scheduled Appointment Tapped');
                      if (widget.isDoctorLogin ?? false) {
                        await dataProvider.getPendingAppointmentListDoctor(
                            '', widget.pkID ?? 0);
                        response =
                            dataProvider.pendingAppointmentListDoctorResponse;
                      } else {
                        await dataProvider.getPendingAppointmentListAssistant(
                            '', widget.pkID ?? 0);
                        response = dataProvider
                            .pendingAppointmentListAssistantResponse;
                      }
                      // Navigator.pushNamed(context, '/listingPagescreen',
                      //     arguments: {
                      //       'headTitle': 'Scheduled Appointment',
                      //       'response': response
                      //     });
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ListingPage(
                            headtitle: 'Scheduled Appointment',
                            response: response,
                            subscripPayment: null,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(width: 10),
                    _apntmntContainer('Completed\nAppointment', () async {
                      print('Completed Tapped');
                      // Navigator.pushNamed(context, '/listingPagescreen',
                      //     arguments: {
                      //       'headTitle': 'Completed Appointment',
                      //       'response': widget.response
                      //     });
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ListingPage(
                            headtitle: 'Completed Appointment',
                            response: widget.response, // full Result object
                            subscripPayment: null,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 10),
                Center(
                  child: _apntmntContainer('Cancelled\nAppointment', () {
                    print('Cancelled Tapped');
                    // Navigator.pushNamed(context, '/listingPagescreen',
                    //     arguments: {
                    //       'headTitle': 'Cancelled Appointment',
                    //       'response': widget.response
                    //     });
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ListingPage(
                          headtitle: 'Cancelled Appointment',
                          response: widget.response, // full Result object
                          subscripPayment: null,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _apntmntContainer(String header, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: (MediaQuery.of(context).size.width / 2) - 20,
        height: 110,
        decoration: BoxDecoration(
          color: const Color(0xFF1C2A4D),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            header,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
