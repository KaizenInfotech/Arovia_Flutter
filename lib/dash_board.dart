import 'dart:io';
import 'dart:ui';
import 'package:arovia/widgets/custom_popup.dart';
import 'package:arovia/widgets/greeting_header.dart';
import 'package:arovia/widgets/profile_photo.dart';
import 'package:arovia/data_model.dart';
import 'package:arovia/data_provider.dart';
import 'package:arovia/listing_page.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> with WidgetsBindingObserver {
  String imei = '';
  String memberType = '';
  String mobileNo = '';
  String profilePhoto = '';
  String firstName = '';
  String lastName = '';
  int pkID = 0;
  int fkID = 0;

  String? apiIOS = "";
  String? apiAndroid = "";
  String? apiStatus = "";

  bool isDoctorLogin = false;
  Result? response;

  bool _isSubscriptionPopupShown = false;

  @override
  void initState() {
    super.initState();
    // Register the observer
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      _getID();
      final dataProvider = Provider.of<DataProvider>(
        context,
        listen: false,
      );
      await dataProvider.getForceUpdate('Arovia');

      setState(() {
        apiIOS = dataProvider.loginData?.tBGroupResult?.iOS ?? '';
        apiAndroid = dataProvider.loginData?.tBGroupResult?.android ?? '';
        apiStatus = dataProvider.loginData?.tBGroupResult?.status ?? '';
        print('IOSVersion-----$apiIOS');
        print('AndroidVersion-----$apiAndroid');
        print('STATUS-----$apiStatus');
        _checkForUpdates(context);
      });
    });
  }

  @override
  void dispose() {
    // Unregister to prevent memory leaks
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    pkID = prefs.getInt('mem_ID') ?? 0;

    print('pkID FOREGROUND ---------$pkID');

    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    // If the app is back to foreground, re-run the check
    if (state == AppLifecycleState.resumed) {
      // _checkForUpdates(context);kk

    if (memberType == 'Doctor') {
      await dataProvider.getSubscriptionPayment(pkID);
         final link = dataProvider.subscriptionPaymentResponse?.paymentlink ?? '';
          await dataProvider.getSubscriptionActiveDoctorAPI(pkID);
          final subscriptionCheck = dataProvider.subscriptionActiveDoctorResponse;

          if (subscriptionCheck?.message == "Expired") {
            setState(() {
              _subscriptionCheck(link);
            });
          }

    } else {
        await dataProvider.getSubscriptionPayment(pkID);
         final link = dataProvider.subscriptionPaymentResponse?.paymentlink ?? '';
          await dataProvider.getSubscriptionActiveAssistantAPI(pkID);
          final subscriptionCheck = dataProvider.subscriptionActiveAssistantResponse;

          if (subscriptionCheck?.message == "Expired") {
            setState(() {
              _subscriptionCheck(link);
            });
          }

    }
    }
  }

  void _checkForUpdates(BuildContext context) async {
    bool isUpdateRequired = await checkForceUpdate();
    if (isUpdateRequired) {
      // Use platform-specific URLs
      String appStoreUrl = Platform.isIOS
          ? 'https://apps.apple.com/us/app/arovia/id6752427169' // iOS App Store URL
          : 'https://play.google.com/store/apps/details?id=com.kaizen.arovia'; // Android Play Store URL
      showForceUpdateDialog(context, appStoreUrl);
    }
  }

  void showForceUpdateDialog(BuildContext context, String appStoreUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Required'),
          content: const Text(
            'A new version of AROVIA is available. Please update to continue.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Update'),
              onPressed: () async {
                if (await canLaunchUrl(Uri.parse(appStoreUrl))) {
                  await launchUrl(Uri.parse(appStoreUrl));
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> checkForceUpdate() async {
// Then use the appropriate one
    final requiredVersion = Platform.isIOS ? apiIOS :  apiAndroid;

    // Get the current app version
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    print('CurrentVersion-----$currentVersion');
    print('RequiredVersion-----$requiredVersion');
    // Compare versions
    return _isVersionOutdated(currentVersion, requiredVersion ?? "");
  }

  bool _isVersionOutdated(String current, String required) {
    List<int> currentParts = current.split('.').map(int.parse).toList();
    List<int> requiredParts = required.split('.').map(int.parse).toList();

    for (int i = 0; i < requiredParts.length; i++) {
      if (i >= currentParts.length || currentParts[i] < requiredParts[i]) {
        return true;
      } else if (currentParts[i] > requiredParts[i]) {
        return false;
      }
    }
    return false;
  }

  Future<void> _launchURL(String paymentLink) async {
    final Uri url = Uri.parse(paymentLink);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  // void _subscriptionCheck(String link) async {
  //
  //   if (Platform.isIOS) {
  //       showGeneralDialog(
  //         context: context,
  //         barrierDismissible: true,
  //         barrierLabel: 'Dismiss',
  //         barrierColor: Colors.transparent, // No default dimming
  //         pageBuilder: (context, animation, secondaryAnimation) {
  //           return BackdropFilter(
  //             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  //             child: Center(
  //               child: CupertinoAlertDialog(
  //                 title: Text( ""),
  //
  //                 content: Text( "Your Subscription Expired"),
  //
  //                 actions: [
  //                   CupertinoDialogAction(
  //                     child: const Text("PAY"),
  //                     onPressed: () async {
  //                       _launchURL(link);
  //                       Navigator.of(context).pop(); // Dismiss dialog
  //                       //---Remove Login
  //                       // Navigator.of(context).pushNamedAndRemoveUntil('/',
  //                       //     (route) => false); // Navigate to initial screen
  //                       // final SharedPreferences prefs =
  //                       //     await SharedPreferences.getInstance();
  //                       // await prefs.remove('isFirstLaunch');
  //                       // await prefs.remove('isDoctorLogin');
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //         transitionDuration: const Duration(milliseconds: 200),
  //         transitionBuilder: (context, animation, secondaryAnimation, child) {
  //           return FadeTransition(
  //             opacity: animation,
  //             child: child,
  //           );
  //         },
  //       );
  //     } else {
  //       showGeneralDialog(
  //         context: context,
  //         barrierDismissible: true,
  //         barrierLabel: "Dismiss",
  //         barrierColor: Colors.black.withOpacity(0.2), // optional dim + blur
  //         transitionDuration: const Duration(milliseconds: 200),
  //         pageBuilder: (context, animation, secondaryAnimation) {
  //           return BackdropFilter(
  //             filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
  //             child: Center(
  //               child: AlertDialog(
  //                 title: Text( ""),
  //                 content: Text( "Your Subscription Expired"),
  //
  //                 actions: [
  //                   TextButton(
  //                     child: const Text("PAY"),
  //                     onPressed: () async {
  //                       Navigator.of(context).pop(); // Close dialog
  //                       //---Remove login
  //                       // Navigator.of(context)
  //                       //     .pushNamedAndRemoveUntil('/', (route) => false);
  //                       // final prefs = await SharedPreferences.getInstance();
  //                       // await prefs.remove('isFirstLaunch');
  //                       // await prefs.remove('isDoctorLogin');
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //         transitionBuilder: (context, animation, secondaryAnimation, child) {
  //           return FadeTransition(
  //             opacity: animation,
  //             child: child,
  //           );
  //         },
  //       );
  //     }
  // }

  void _subscriptionCheck(String link) {
    // Prevent showing multiple times
    if (_isSubscriptionPopupShown) return;

    _isSubscriptionPopupShown = true;

    showSubscriptionExpiredPopup(
      context: context,
      link: link,
    ).then((_) {
      // Reset the flag when popup is dismissed (by any means)
      _isSubscriptionPopupShown = false;
    });
  }

  // void _checkSessionExpired(DataProvider dataProvider) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   pkID = prefs.getInt('mem_ID') ?? 0;
  //   imei = prefs.getString('imei') ?? '';
  //
  //   await dataProvider.getSessionTimeOut(pkID, imei);
  //
  //   final sessionTimeOut = dataProvider.sessionTimeOutResponse?.status ?? '';
  //   print('Session Expired &&&&&&&&&&&& $sessionTimeOut');
  //   if (sessionTimeOut != "0") {
  //
  //     if (Platform.isIOS) {
  //       showGeneralDialog(
  //         context: context,
  //         barrierDismissible: true,
  //         barrierLabel: 'Dismiss',
  //         barrierColor: Colors.transparent, // No default dimming
  //         pageBuilder: (context, animation, secondaryAnimation) {
  //           return BackdropFilter(
  //             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  //             child: Center(
  //               child: CupertinoAlertDialog(
  //                 title: Text((sessionTimeOut == '-2')
  //                     ? "Session Expired"
  //                     : (sessionTimeOut == '-1')
  //                         ? "Member is deleted"
  //                         : "Session Expired"),
  //                 content: Text((sessionTimeOut == '-2')
  //                     ? "Your session has expired. Please log in again."
  //                     : (sessionTimeOut == '-1')
  //                         ? "Session Time out , Please Register Your Mobile Number"
  //                         : "Your session has expired. Please log in again."),
  //                 actions: [
  //                   CupertinoDialogAction(
  //                     child: const Text("OK"),
  //                     onPressed: () async {
  //                       Navigator.of(context).pop(); // Dismiss dialog
  //                       Navigator.of(context).pushNamedAndRemoveUntil('/',
  //                           (route) => false); // Navigate to initial screen
  //                       final SharedPreferences prefs =
  //                           await SharedPreferences.getInstance();
  //                       await prefs.remove('isFirstLaunch');
  //                       await prefs.remove('isDoctorLogin');
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //         transitionDuration: const Duration(milliseconds: 200),
  //         transitionBuilder: (context, animation, secondaryAnimation, child) {
  //           return FadeTransition(
  //             opacity: animation,
  //             child: child,
  //           );
  //         },
  //       );
  //     } else {
  //       showGeneralDialog(
  //         context: context,
  //         barrierDismissible: true,
  //         barrierLabel: "Dismiss",
  //         barrierColor: Colors.black.withOpacity(0.2), // optional dim + blur
  //         transitionDuration: const Duration(milliseconds: 200),
  //         pageBuilder: (context, animation, secondaryAnimation) {
  //           return BackdropFilter(
  //             filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
  //             child: Center(
  //               child: AlertDialog(
  //                 title: Text((sessionTimeOut == '-2')
  //                     ? "Session Expired"
  //                     : (sessionTimeOut == '-1')
  //                         ? "Member is deleted"
  //                         : "Session Expired"),
  //                 content: Text((sessionTimeOut == '-2')
  //                     ? "Your session has expired. Please log in again."
  //                     : (sessionTimeOut == '-1')
  //                         ? "Session Time out , Please Register Your Mobile Number"
  //                         : "Your session has expired. Please log in again."),
  //                 actions: [
  //                   TextButton(
  //                     child: const Text("OK"),
  //                     onPressed: () async {
  //                       Navigator.of(context).pop(); // Close dialog
  //                       Navigator.of(context)
  //                           .pushNamedAndRemoveUntil('/', (route) => false);
  //                       final prefs = await SharedPreferences.getInstance();
  //                       await prefs.remove('isFirstLaunch');
  //                       await prefs.remove('isDoctorLogin');
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //         transitionBuilder: (context, animation, secondaryAnimation, child) {
  //           return FadeTransition(
  //             opacity: animation,
  //             child: child,
  //           );
  //         },
  //       );
  //     }
  //   }
  // }

  void _checkSessionExpired(DataProvider dataProvider) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    pkID = prefs.getInt('mem_ID') ?? 0;
    imei = prefs.getString('imei') ?? '';

    await dataProvider.getSessionTimeOut(pkID, imei);

    final sessionTimeOut = dataProvider.sessionTimeOutResponse?.status ?? '';
    print('Session Expired &&&&&&&&&&&& $sessionTimeOut');

    if (sessionTimeOut != "0") {
      // Determine title and message
      String title = (sessionTimeOut == '-2' || sessionTimeOut == '-1')
          ? (sessionTimeOut == '-2' ? "Session Expired" : "Member is deleted")
          : "Session Expired";

      String content = (sessionTimeOut == '-2')
          ? "Your session has expired. Please log in again."
          : (sessionTimeOut == '-1')
          ? "Session Time out , Please Register Your Mobile Number"
          : "Your session has expired. Please log in again.";

      // Show non-dismissible dialog with no actions (no OK button)
      showGeneralDialog(
        context: context,
        barrierDismissible: false, // Cannot dismiss by tapping outside
        barrierLabel: "Session Expired",
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) {
          return WillPopScope(
            onWillPop: () async => false, // Blocks back button (Android) and physical back
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Center(
                child: Platform.isIOS
                    ? CupertinoAlertDialog(
                  title: Text(title),
                  content: Text(content),
                  // No actions → no buttons at all
                )
                    : AlertDialog(
                  title: Text(title),
                  content: Text(content),
                  // No actions → no buttons
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ).then((_) {
        // This runs when dialog is closed (after 3 seconds)
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        // Clean up preferences
        prefs.remove('isFirstLaunch');
        prefs.remove('isDoctorLogin');
      });

      // Auto-dismiss after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(); // Close the dialog
        }
      });
    }
  }

  Future<void> _getID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('isFirstLaunch', 1);
    pkID = prefs.getInt('mem_ID') ?? 0;
    imei = prefs.getString('imei') ?? '';
    isDoctorLogin = prefs.getBool('isDoctorLogin') ?? false;
    await prefs.setInt('pkID', pkID);

    print('pkID ---------$pkID');
    print('imei ---------$imei');

    final dataProvider = Provider.of<DataProvider>(context, listen: false);

    _checkSessionExpired(dataProvider);

    await dataProvider.getUserDetail(pkID);
    final userDetail = dataProvider.userDetailResponse;

    if (userDetail != null && userDetail.result.isNotEmpty) {
      setState(() {
        profilePhoto = userDetail.result.first.profilePhoto ?? '';
        firstName = userDetail.result.first.firstName ?? '';
        lastName = userDetail.result.first.lastName ?? '';
      });
      fkID = userDetail.result.first.fkMainMemberMasterIdAsDoctorId ?? 0;
      print('fkID ---------$fkID');
      print('profilePhoto ---------$profilePhoto');
      print('firstName ---------$firstName');
      print('lastName ---------$lastName');
      await prefs.setInt('fk_Id', fkID);

      mobileNo = userDetail.result.first.mobileNumber ?? '';
      print('mobileNo ---------$mobileNo');

      memberType = userDetail.result.first.membertype ?? '';
      print('memberType ---------$memberType');

      // Fetch appointment data based on member type
      if (memberType == 'Doctor') {
        await _fetchDoctorAppointments(dataProvider);
      } else {
        await _fetchAssistantAppointments(dataProvider);
      }
      await dataProvider.getAppointmentDetails(fkID);
    }

    if (memberType == 'Doctor') {
      await dataProvider.getSubscriptionPayment(pkID);
         final link = dataProvider.subscriptionPaymentResponse?.paymentlink ?? '';
          await dataProvider.getSubscriptionActiveDoctorAPI(pkID);
          final subscriptionCheck = dataProvider.subscriptionActiveDoctorResponse;

          if (subscriptionCheck?.message == "Expired") {
            setState(() {
              _subscriptionCheck(link);
            });
          }

    } else {
        await dataProvider.getSubscriptionPayment(pkID);
         final link = dataProvider.subscriptionPaymentResponse?.paymentlink ?? '';
          await dataProvider.getSubscriptionActiveAssistantAPI(pkID);
          final subscriptionCheck = dataProvider.subscriptionActiveAssistantResponse;

          if (subscriptionCheck?.message == "Expired") {
            setState(() {
              _subscriptionCheck(link);
            });
          }

    }
  }

  Future<void> _fetchDoctorAppointments(DataProvider dataProvider) async {
    await dataProvider.getAppointmentListDoctor('', pkID);
    response = dataProvider.appointmentListDoctorResponse;

    await dataProvider.getPendingAppointmentListDoctor('', pkID);
    response = dataProvider.pendingAppointmentListDoctorResponse;

    await dataProvider.getSearchAppointmentDoctor(mobileNo, fkID);
    final searchAppointmentDoctor =
        dataProvider.searchAppointmentDoctorResponse;
  }

  Future<void> _fetchAssistantAppointments(DataProvider dataProvider) async {
    await dataProvider.getAppointmentListAssistant('', pkID);
    response = dataProvider.appointmentListAssistantResponse;

    await dataProvider.getPendingAppointmentListAssistant('', pkID);
    response = dataProvider.pendingAppointmentListAssistantResponse;

    await dataProvider.getSearchAppointmentAssitant(mobileNo, fkID);
    final searchAppointmentAssistant =
        dataProvider.searchAppointmentAssistantResponse;
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        SystemNavigator.pop();
      },
      child: Scaffold(
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
                profilePhotoWidget(profilePhoto),
                const SizedBox(width: 12),
                Expanded(
                  child:GreetingHeader(
                    firstName: firstName,
                    lastName: lastName,
                    memberType: memberType, // or "Patient", "Nurse", etc.
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
                  //       (memberType == 'Doctor') ? "Dr. $firstName $lastName"
                  //       : "$firstName $lastName",
                  //       style: const TextStyle(
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.w600,
                  //         color: Colors.black,
                  //       ),maxLines: 2,
                  //     ),
                  //   ],
                  // ),
                ),
                // const Icon(Icons.notifications_none, size: 28, color: Colors.black),
                GestureDetector(onTap: () {
                  showLogoutPopup(context: context);
                },child: Padding(
                  padding:  const EdgeInsets.only(left: 5.0),
                  child: Image.asset("assets/logout.png"),
                ))
              ],
            ),
          ),
          backgroundColor: const Color.fromRGBO(251, 246, 227, 1),
          body: Consumer<DataProvider>(builder: (context, dataProvider, child) {
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                          child: Row(
                            children: [
                              _welcomeContainer(
                                  '', 'Appointment', 16, FontWeight.w500,
                                  () async {
                                print('Appointment Tapped');
                                if (isDoctorLogin) {
                                  await dataProvider.getAppointmentListDoctor(
                                      '', pkID);
                                  response =
                                      dataProvider.appointmentListDoctorResponse;
                                } else {
                                  await dataProvider.getAppointmentListAssistant(
                                      '', pkID);
                                  response = dataProvider
                                      .appointmentListAssistantResponse;
                                }
                                Navigator.pushNamed(
                                    context, '/appointmentDetailPage',
                                    arguments: {
                                      'loginType': isDoctorLogin,
                                      'pkID': pkID,
                                      'respon': response
                                    }).then((_) {
                                  _checkSessionExpired(dataProvider);
                                });
                              }),
                              const SizedBox(
                                width: 8.0,
                              ),
                              _welcomeContainer(
                                  '', 'Pending\nPayments', 16, FontWeight.w500,
                                  () async {
                                print('Pending Payments Tapped');
                                if (isDoctorLogin) {
                                  await dataProvider
                                      .getPendingAppointmentListDoctor('', pkID);
                                  response = dataProvider
                                      .pendingAppointmentListDoctorResponse;
                                } else {
                                  await dataProvider
                                      .getPendingAppointmentListAssistant(
                                          '', pkID);
                                  response = dataProvider
                                      .pendingAppointmentListAssistantResponse;
                                }
                                // Navigator.pushNamed(context, '/listingPagescreen',
                                //     arguments: {
                                //       'headTitle': 'Pending Payments',
                                //       'response': response
                                //     })
                                Navigator.of(context)
                                    .push(
                                  MaterialPageRoute(
                                    builder: (context) => ListingPage(
                                      headtitle: 'Pending Payments',
                                      response: response, // full Result object
                                      subscripPayment: null,
                                    ),
                                  ),
                                )
                                    .then((_) {
                                  _checkSessionExpired(dataProvider);
                                });
                              }),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: isDoctorLogin
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.center,
                            children: [

                                _welcomeContainer(
                                    '', 'Patients', 16, FontWeight.w500,
                                    () async {
                                  print('Patients Tapped');
                                  if (isDoctorLogin) {
                                    await dataProvider.getPatientListDoctor(
                                        '', pkID);
                                    response =
                                        dataProvider.patientListDoctorResponse;
                                  } else {
                                    await dataProvider.getPatientListAssistant(
                                        '', pkID);
                                    response =
                                        dataProvider.patientListAssistantResponse;
                                  }
                                  // Navigator.pushNamed(
                                  //     context, '/listingPagescreen', arguments: {
                                  //   'headTitle': 'Patients',
                                  //   'response': response
                                  // })
                                  Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) => ListingPage(
                                        headtitle: 'Patients',
                                        response: response, // full Result object
                                        subscripPayment: null,
                                      ),
                                    ),
                                  )
                                      .then((_) {
                                    _checkSessionExpired(dataProvider);
                                  });
                                }),
                              const SizedBox(
                                width: 8.0,
                              ),
                              if (isDoctorLogin)
                              _welcomeContainer(
                                  '', 'Assistant', 16, FontWeight.w500, () async {
                                print('Assistant Tapped');
                                await dataProvider.getAssistant('', pkID);
                                response = dataProvider.assistantResponse;
                                // Navigator.pushNamed(context, '/listingPagescreen',
                                //     arguments: {
                                //       'headTitle': 'Assistant',
                                //       'response': response
                                //     })
                                Navigator.of(context)
                                    .push(
                                  MaterialPageRoute(
                                    builder: (context) => ListingPage(
                                      headtitle: 'Assistant',
                                      response: response, // full Result object
                                      subscripPayment: null,
                                    ),
                                  ),
                                )
                                    .then((_) {
                                  _checkSessionExpired(dataProvider);
                                });
                              }),
                            ],
                          ),
                        ),
                        if (isDoctorLogin)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _welcomeContainer(
                                    '', 'Subscription', 16, FontWeight.w500,
                                    () async {
                                  print('Subscription Tapped');
                                  await dataProvider.getSubscriptionPayment(pkID);
                                  final link = dataProvider
                                          .subscriptionPaymentResponse
                                          ?.paymentlink ??
                                      '';
                                  await dataProvider.getSubscription(pkID);
                                  response = dataProvider.subscriptionResponse;
                                  // Navigator.pushNamed(
                                  //     context, '/listingPagescreen', arguments: {
                                  //   'headTitle': 'Subscription',
                                  //   'response': response,
                                  //   'subsLink': link
                                  // })
                                  Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) => ListingPage(
                                        headtitle: 'Subscription',
                                        response: response, // full Result object
                                        subscripPayment: link,
                                      ),
                                    ),
                                  )
                                      .then((_) {
                                    _checkSessionExpired(dataProvider);
                                  });
                                }),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ))
              ],
            );
          })),
    );
  }



  Widget _textFunction(String title, double fontSize, FontWeight fontDesign) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: fontSize, fontWeight: fontDesign, color: Colors.white),
    );
  }

  Widget _welcomeContainer(String? img, String? heading, double? fontSize,
      FontWeight? fontDesign, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: (MediaQuery.of(context).size.width / 2 - 20),
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color.fromRGBO(28, 40, 67, 1),
        ),
        child: Center(
            child: _textFunction(
                heading ?? '', fontSize ?? 0.0, fontDesign ?? FontWeight.w100)),
      ),
    );
  }
}
