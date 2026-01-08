import 'dart:math';
import 'package:arovia/data_model.dart';
import 'package:arovia/data_provider.dart';
import 'package:arovia/widgets/greeting_header.dart';
import 'package:arovia/widgets/profile_photo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({
    super.key,
    required this.headtitle,
    required this.index,
    required this.patientID,
    required this.response,
    required this.status,
  });
  final headtitle;
  final index;
  final patientID;
  Result? response;
  List<ResultElement?> status;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int? pkid;
  bool isDoctorLogin = false;
  int? appointmentID;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _loadUserLoginType();

      // if (widget.headtitle == 'Completed Appointment') {
      //   setState(() {
      //     status.clear();
      //     status = (widget.response?.result ?? [])
      //         .where(
      //             (statuses) => (statuses.status ?? '').contains('Completed'))
      //         .toList();
      //     print('Completed Response:------ ${status[0]?.status}');
      //   });
      // } else if (widget.headtitle == 'Cancelled Appointment') {
      //   setState(() {
      //     status.clear();
      //     status = (widget.response?.result ?? [])
      //         .where(
      //             (statuses) => (statuses.status ?? '').contains('Cancelled'))
      //         .toList();
      //     print('Cancelled Response:------ ${status[0]?.status}');
      //   });
      // } else if (widget.headtitle == 'Scheduled Appointment') {
      //   setState(() {
      //     status.clear();
      //     status = (widget.response?.result ?? [])
      //         .where(
      //             (statuses) => (statuses.status ?? '').contains('Scheduled'))
      //         .toList();
      //     print('Cancelled Response:------ ${status[0]?.status}');
      //   });
      // } else if (widget.headtitle == 'Pending Payments') {
      //   setState(() {
      //     status.clear();
      //     status = (widget.response?.result ?? [])
      //         .where((statuses) =>
      //             (statuses.status ?? '').contains('Amount Pending'))
      //         .toList();
      //     print('Cancelled Response:------ ${status[0]?.status}');
      //   });
      // }
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
                //        (isDoctorLogin) ? "Dr. ${user.firstName} ${user.lastName}"
                //        : "${user.firstName} ${user.lastName}",
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
        body: Consumer<DataProvider>(builder: (context, dataProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
                child: Column(
              children: [
                // const SizedBox(height: 16),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C2A4D),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _listDetail(
                                (widget.headtitle == 'Patient History')
                                    ? 'Symptoms'
                                    : (widget.headtitle == 'Patient Documents')
                                        ? 'Title'
                                        : 'Name',
                                (widget.headtitle == 'Assistant')
                                    ? widget.response?.result[widget.index]
                                            .name ??
                                        ''
                                    : (widget.headtitle == 'Patient History')
                                        ? widget.response?.result[widget.index]
                                                .symptoms ??
                                            ''
                                        : (widget.headtitle ==
                                                'Patient Documents')
                                            ? widget
                                                    .response
                                                    ?.result[widget.index]
                                                    .title ??
                                                ''
                                            : (widget.headtitle ==
                                                        'Completed Appointment' ||
                                                    widget.headtitle ==
                                                        'Cancelled Appointment' ||
                                                    widget.headtitle ==
                                                        'Scheduled Appointment' ||
                                                    widget.headtitle ==
                                                        'Pending Payments')
                                                ? widget.status[widget.index]
                                                        ?.patiantName ??
                                                    ''
                                                : widget
                                                        .response
                                                        ?.result[widget.index]
                                                        .patiantName ??
                                                    ''),
                            if (widget.headtitle != 'Patient History')
                              _listDetail(
                                  (widget.headtitle == 'Patient Documents')
                                      ? 'Type'
                                      : 'Mobile No',
                                  (widget.headtitle == 'Assistant')
                                      ? widget.response?.result[widget.index]
                                              .mobileNumber ??
                                          ''
                                      : (widget.headtitle ==
                                              'Patient Documents')
                                          ? widget.response
                                                  ?.result[widget.index].type ??
                                              ''
                                          : (widget.headtitle ==
                                                      'Completed Appointment' ||
                                                  widget.headtitle ==
                                                      'Cancelled Appointment' ||
                                                  widget.headtitle ==
                                                      'Scheduled Appointment' ||
                                                  widget.headtitle ==
                                                      'Pending Payments')
                                              ? widget.status[widget.index]
                                                      ?.patiantMobileNumber ??
                                                  ''
                                              : widget
                                                      .response
                                                      ?.result[widget.index]
                                                      .patiantMobileNumber ??
                                                  ''),
                            _listDetail(
                                (widget.headtitle == 'Assistant')
                                    ? 'Status'
                                    : 'Date & Time',
                                (widget.headtitle == 'Assistant')
                                    ? widget.response?.result[widget.index]
                                            .cashfreeStatus ??
                                        ''
                                    : (widget.headtitle == 'Patient History')
                                        ? widget.response?.result[widget.index]
                                                .docAppointmentDate ??
                                            ''
                                        : (widget.headtitle ==
                                                'Patient Documents')
                                            ? widget
                                                    .response
                                                    ?.result[widget.index]
                                                    .docCreateddate ??
                                                ''
                                            : (widget.headtitle == 'Completed Appointment' ||
                                                    widget.headtitle ==
                                                        'Cancelled Appointment' ||
                                                    widget.headtitle ==
                                                        'Scheduled Appointment' ||
                                                    widget.headtitle ==
                                                        'Pending Payments')
                                                ? widget.status[widget.index]
                                                        ?.appointmentDate ??
                                                    ''
                                                : widget
                                                        .response
                                                        ?.result[widget.index]
                                                        .appointmentDate ??
                                                    ''),
                            // if (widget.headtitle == "Pending Payments")
                            //   _listDetail('Amount',
                            //       widget.status[widget.index]?.pendingAmount ?? ''),
                            if (widget.headtitle != 'Assistant' &&
                                widget.headtitle != 'Patient Documents')
                              _listDetail(
                                  'Status',
                                  (widget
                                                  .headtitle ==
                                              'Completed Appointment' ||
                                          widget
                                                  .headtitle ==
                                              'Cancelled Appointment' ||
                                          widget
                                                  .headtitle ==
                                              'Scheduled Appointment' ||
                                          widget
                                                  .headtitle ==
                                              'Pending Payments')
                                      ? widget.status[widget.index]?.status ??
                                          ''
                                      : widget.response?.result[widget.index]
                                              .status ??
                                          ''),
                          ],
                        ),
                      )),
                ),
                const SizedBox(height: 16),
               if (widget.headtitle == 'Scheduled Appointment' ||
                    widget.headtitle == 'Patient History' ||
                    widget.headtitle == 'Patient Documents')
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
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
                                const Spacer(),
                                Text(
                                  (widget.headtitle == 'Patient Documents')
                                      ? 'Download Document'
                                      : 'Report',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(250, 166, 28, 1)),
                                ),
                                const Spacer(),
                              ],
                            ),
                          )),
                      onTap: () async {
                        if (widget.headtitle != 'Patient Documents') {
                          var loginID = pkid;
                          var moduleID = (widget.headtitle == 'Patient History')
                              ? isDoctorLogin
                                  ? 2
                                  : 7
                              : isDoctorLogin
                                  ? 10
                                  :11;

                          if (widget.headtitle == 'Completed Appointment' ||
                              widget.headtitle == 'Cancelled Appointment' ||
                              widget.headtitle == 'Scheduled Appointment') {
                            appointmentID =
                                widget.status[widget.index]?.pkAppointmentId;
                          } else {
                            appointmentID = widget
                                .response?.result[widget.index].pkAppointmentId;
                          }

                          var patientID = (widget.headtitle ==
                                  'Patient History')
                              ? widget.patientID
                              : (widget.headtitle == 'Completed Appointment' ||
                                      widget.headtitle ==
                                          'Cancelled Appointment' ||
                                      widget.headtitle ==
                                          'Scheduled Appointment')
                                  ? widget.status[widget.index]?.fkPatientId
                                  : widget.response?.result[widget.index]
                                      .fkPatientId;

                          await dataProvider.getWeblink(loginID ?? 0, moduleID,
                              appointmentID ?? 0, patientID, 0, 0, 0, '');
                          print(
                              'WEBLINK RESULT------${dataProvider.weblinkResponse?.result}');

                          Navigator.pushNamed(context, '/webView', arguments: {
                            'url': dataProvider.weblinkResponse?.result,
                            'webTitle': 'Report'
                          });
                        } else {
                          final String fileUrl =
                              widget.response?.result[widget.index].url ?? '';
                          print('DOCUMENT URL------$fileUrl');
                          await saveFileFromUrl(context, fileUrl);
                        }
                      },
                    ),
                  ), 
                  if (widget.headtitle == 'Pending Payments')
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1C2A4D),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Spacer(),
                                        Text(
                                           'Report',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromRGBO(250, 166, 28, 1)),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  )),
                              onTap: () async {
                            
                                  var loginID = pkid;
                                  var moduleID = isDoctorLogin
                                          ? 9
                                          : 12;
                            
                                  if (widget.headtitle == 'Pending Payments') {
                                    appointmentID =
                                        widget.status[widget.index]?.pkAppointmentId;
                                  } 
                            
                                  var patientID =  widget.status[widget.index]?.fkPatientId;
                                          
                            
                                  await dataProvider.getWeblink(loginID ?? 0, moduleID,
                                      appointmentID ?? 0, patientID ?? 0, 0, 0, 0, '');
                                  print(
                                      'WEBLINK RESULT------${dataProvider.weblinkResponse?.result}');
                            
                                  Navigator.pushNamed(context, '/webView', arguments: {
                                    'url': dataProvider.weblinkResponse?.result,
                                    'webTitle': 'Report'
                                  });
                                
                              },
                            ),
                          ),
                    if (widget.headtitle == 'Pending Payments')
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1C2A4D),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Spacer(),
                                        Text( 
                                          'View',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromRGBO(250, 166, 28, 1)),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  )),
                              onTap: () async {
                                                   
                                  var loginID = pkid;
                                  var moduleID = isDoctorLogin
                                          ? 1
                                          : 6;
                                                     
                                  if (widget.headtitle == 'Pending Payments') {
                                    appointmentID =
                                        widget.status[widget.index]?.pkAppointmentId;
                                  } 
                                                     
                                  var patientID =  widget.status[widget.index]?.fkPatientId;
                                                     
                                  await dataProvider.getWeblink(loginID ?? 0, moduleID,
                                      appointmentID ?? 0, patientID ?? 0, 0, 0, 0, '');
                                  print(
                                      'WEBLINK RESULT------${dataProvider.weblinkResponse?.result}');
                                                     
                                  Navigator.pushNamed(context, '/webView', arguments: {
                                    'url': dataProvider.weblinkResponse?.result,
                                    'webTitle': 'View'
                                  });
                              },
                             ),
                  ),
              ],
            )),
          );
        }));
  }

  Widget _listDetail(String name, String detail) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            '$name:',
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(250, 166, 28, 1)),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            detail,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

//   Future<void> downloadFile(String fileUrl) async {
//   final dio = Dio();
//   final status = await Permission.storage.request();

//   try {
//     // No need to request storage permission for app-private directory on Android 10+
//     if (Platform.isAndroid) {
//       final androidInfo = await DeviceInfoPlugin().androidInfo;
//       if (androidInfo.version.sdkInt <= 28) {

//         if (!status.isGranted) {
//           print("Permission denied");
//           return;
//         }
//       }
//     } else {
//        if (!status.isGranted) {
//           print("Permission denied");
//           return;
//         }
//     }

//     final dir = await getApplicationDocumentsDirectory();

//     final fileName = fileUrl.split('/').last;
//     final savePath = "${dir.path}/$fileName";

//     print("Downloading from: $fileUrl");
//     print("Saving to: $savePath");

//     await dio.download(fileUrl, savePath);
//     await OpenFile.open(savePath);
//   } catch (e) {
//     print("Download error: $e");
//   }
// }

  Future<void> saveFileFromUrl(BuildContext context, String fileUrl) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    String? message;

    try {
      // Get file extension (e.g. ".png", ".pdf")
      final uri = Uri.parse(fileUrl);
      final fileExtension = uri.path.split('.').last;
      final isPdf = fileExtension.toLowerCase() == 'pdf';

      // Download file
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to download file (status ${response.statusCode})');
      }

      // Temporary file creation
      final tempDir = await getTemporaryDirectory();
      final random = Random().nextInt(1000);
      final tempFilePath =
          '${tempDir.path}/downloaded_file_$random.$fileExtension';
      final tempFile = File(tempFilePath);
      await tempFile.writeAsBytes(response.bodyBytes);

      // Show save dialog
      final savePath = await FlutterFileDialog.saveFile(
        params: SaveFileDialogParams(sourceFilePath: tempFilePath),
      );

      message = savePath != null
          ? '${isPdf ? "PDF" : "Image"} saved successfully'
          : 'Save cancelled';
    } catch (e) {
      message = 'Error: $e';
    }

    // Show result
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          message ?? 'Unknown error',
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor:  Colors.black,
      ),
    );
  }

// Future<void> downloadFile(String fileUrl) async {

//   final dio = Dio();

//   final status = await Permission.storage.request();
//   if (!status.isGranted) {
//     print("Permission denied");
//     return;
//   }

//   try {
//     final dir = Platform.isAndroid
//         ? await getExternalStorageDirectory()
//         : await getApplicationDocumentsDirectory();

//     if (dir == null) {
//       print("Directory not found");
//       return;
//     }

//     final fileName = fileUrl.split('/').last;
//     final savePath = "${dir.path}/$fileName";

//     print("Downloading from: $fileUrl");
//     print("Downloading from: $fileName");
//     print("Saving to: $savePath");

//     await dio.download(fileUrl, savePath);
//     await OpenFile.open(savePath);
//   } catch (e) {
//     print("Download error: $e");
//   }
// }
}
