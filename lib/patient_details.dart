import 'package:arovia/constants/utils.dart';
import 'package:arovia/data_model.dart';
import 'package:arovia/data_provider.dart';
import 'package:arovia/widgets/profile_photo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientDetailPage extends StatefulWidget {
  const PatientDetailPage(
      {super.key,
      required this.patientID,
      required this.amtPending,
      required this.phoneNumber,
      required this.isDoctorLogin, this.patientName});
  final patientID;
  final String? amtPending;
  final String? phoneNumber;
  final String? patientName;
  final bool? isDoctorLogin;

  @override
  State<PatientDetailPage> createState() => _PatientDetailPageState();
}

class _PatientDetailPageState extends State<PatientDetailPage> {
  int? selectedIndex;
  int? pkaID;
  int? pkid;
  Result? response;

  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      pkid = prefs.getInt('pkID');
      print("pkid ::::::::::: $pkid");
    });
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hi, Welcome Back,",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF858585),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    (widget.isDoctorLogin ?? false) ? "Dr. ${user.firstName} ${user.lastName}"
                    : "${user.firstName} ${user.lastName}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
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
                     Text(
                      '${Utils().capitalizeEachWord(widget.patientName ??"")} Patient',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _patientPage('Patient\nDocuments', () async {
                      print('Patient Documents Tapped');
                      await dataProvider.getPatientDocument(
                          '', widget.patientID);
                      response = dataProvider.patientDocumentResponse;

                      Navigator.pushNamed(context, '/PatientListingPage',
                          arguments: {
                            'headTitle': 'Patient Documents',
                            'response': response,
                            'patientID': widget.patientID,
                            'patientName': widget.patientName
                          });
                    }),
                    const SizedBox(width: 10),
                    _patientPage('Patient\nHistory', () async {
                      print('Patient History Tapped');
                      await dataProvider.getPatientHistory(
                          '', widget.patientID);
                      response = dataProvider.patientHistoryResponse;
                      Navigator.pushNamed(context, '/PatientListingPage',
                          arguments: {
                            'headTitle': 'Patient History',
                            'response': response,
                            'patientID': widget.patientID,
                            'phoneNo': widget.phoneNumber,
                            'patientName': widget.patientName
                          });
                    }),
                  ],
                ),
                const SizedBox(height: 10),
                Center(
                  child: _patientPage('Reminder', () async {
                    print('Reminder Tapped');
                    var amntPend = widget.amtPending ?? '';
                    if (amntPend != 'Rs. 0') {
                     await dataProvider.getwhatsApp(widget.patientID ?? 0);
                     ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text( dataProvider.whatsAppResponse?.message ?? "")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("No Pending Amount")));
                    }
                  }),
                ),
                //  Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     //  _patientPage('Patient\nDetails',() {
                //     //     print('Patient Details Tapped');
                //     // }),
                //     // SizedBox(width: 10),
                //     _patientPage('Reminder',() {
                //         print('Reminder Tapped');
                //     }),
                //   ],
                // ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C2A4D),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Amount Pending:',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(width: 30),
                            Text(
                              widget.amtPending ?? '',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(250, 166, 28, 1)),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _patientPage(String header, VoidCallback onTap) {
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

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text(
              'Reminder',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            content: TextField(
              controller: _messageController,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    _sendMessageToWhatsApp(context);
                  },
                  child: const Row(children: [
                    Spacer(),
                    Icon(Icons.message_rounded),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Send To Whatsapp",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Spacer(),
                  ]))
            ],
          ));
  void _sendMessageToWhatsApp(BuildContext context) async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    try {
      final whatsappUrl = Uri.parse(
          "https://wa.me/91${widget.phoneNumber}?text=${Uri.encodeComponent(message)}");
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open WhatsApp.")));
    }
  }
}
