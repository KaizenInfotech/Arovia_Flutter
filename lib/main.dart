import 'dart:io';
import 'package:arovia/appntmnt_details.dart';
import 'package:arovia/dash_board.dart';
import 'package:arovia/data_provider.dart';
import 'package:arovia/detail_screen.dart';
import 'package:arovia/get_started.dart';
import 'package:arovia/login_screen.dart';
import 'package:arovia/otp_screen.dart';
import 'package:arovia/patient_details.dart';
import 'package:arovia/patient_listing.dart';
import 'package:arovia/splash_screen.dart';
import 'package:arovia/web_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // await requestNotificationPermissions();
  // final prefs = await SharedPreferences.getInstance();
  // final isFirstLaunch = prefs.getInt('isFirstLaunch') == 1;
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => DataProvider()),
    ],
    child: const MainApp(initialRoute: '/'),
  ));
}

Future<void> requestNotificationPermissions() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    String? token = await messaging.getToken();
    print("FCM Device Token: $token");
    getDeviceToken(token ?? '');
    // setupNotificationListeners();
    if (Platform.isIOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true, // Show banner
        badge: true,
        sound: true,
      );
      // checkForInitialMessage();
    }
  } else {
    print('User declined or has not accepted permission');
  }
}

void getDeviceToken(String deviceTokensss) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('deviceTok', deviceTokensss);
  print('getDeviceToken()---Called'); // Set after successful login
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Named Routes Demo',
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/dashboardscreen': (context) => const DashBoard(),
      },
      onGenerateRoute: (settings) {
        final args = settings.arguments as Map<String, dynamic>?;
        print(
            'Generating route: ${settings.name}, arguments: ${settings.arguments}');

        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => const WelcomeScreen(),
            );

          case '/welcome':
            return MaterialPageRoute(
              builder: (context) => const WelcomeScreen(),
            );

          case '/getStart':
            return MaterialPageRoute(
              builder: (context) => GetStarted(memType: args?['username']),
            );

          case '/loginscreen':
            return MaterialPageRoute(
              builder: (context) => LoginScreen(memType: args?['username']),
            );

          case '/otpscreen':
            return MaterialPageRoute(
                builder: (context) => OTP(
                      otp: args?['username'],
                      phn: args?['phn'],
                      phnName: args?['phnName'],
                      phnVersion: args?['phnVersion'],
                      imei: args?['imei'],
                      memType: args?['memType'],
                      token: args?['token'],
                    ));

          case '/dashboardscreen':
            return MaterialPageRoute(
              builder: (context) => const DashBoard(),
            );

          // case '/listingPagescreen':
          //   return MaterialPageRoute(
          //     builder: (context) => ListingPage(
          //       headtitle: args?['headTitle'],
          //       response: args?['response'],
          //       subscripPayment: args?['subsLink'],
          //     ),
          //   );

          case '/patientDetail':
            return MaterialPageRoute(
                builder: (context) => PatientDetailPage(
                      patientID: args?['patientID'],
                      amtPending: args?['amtPending'],
                      phoneNumber: args?['phoneNo'],
                      isDoctorLogin: args?['isDoctorLogin'],
                    ));

          case '/PatientListingPage':
            return MaterialPageRoute(
                builder: (context) => PatientListingPage(
                      patientID: args?['patientID'],
                      response: args?['response'],
                      headtitle: args?['headTitle'],
                      phoneNo: args?['phoneNo'],
                    ));

          case '/detailScreen':
            return MaterialPageRoute(
                builder: (context) => DetailScreen(
                      headtitle: args?['headTitle'],
                      index: args?['indexes'],
                      patientID: args?['patientID'],
                      response: args?['response'],
                      status: args?['status'],
                    ));

          case '/webView':
            return MaterialPageRoute(
                builder: (context) => WebViewContainer(
                      selectedUrl: args?['url'],
                      webTitle: args?['webTitle'],
                    ));

          case '/appointmentDetailPage':
            return MaterialPageRoute(
                builder: (context) => AppointmentDetailPage(
                      isDoctorLogin: args?['loginType'],
                      pkID: args?['pkID'],
                      response: args?['respon'],
                    ));
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, dataProvider, child) {
      return Scaffold(
        backgroundColor: const Color.fromRGBO(251, 246, 227, 1),
        body: dataProvider.loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      // width: 300,
                      // height: 300,
                      child: Image.asset(
                        'assets/arovia_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    _textFunction('Welcome Back!', 24, FontWeight.w500),
                    _textFunction('Use Credentials to access your account', 15,
                        FontWeight.w300),
                    const SizedBox(
                      height: 40,
                    ),
                    _welcomeContainer('assets/doctor.png', 'I’m a Doctor',
                        () async {
                      debugPrint('Doctor Tapped');
                      dataProvider.dataProviderFunction(true);
                      await dataProvider.getAuthToken();
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString(
                          'auth_token', dataProvider.authToken?.token ?? '');
                      await prefs.setBool(
                          'isDoctorLogin', dataProvider.isDoctor ?? false);
                      Navigator.pushNamed(
                        context,
                        '/getStart',
                        arguments: {'username': 'Doctor'},
                      );
                      print('AUTHTOKEN-------${dataProvider.authToken?.token}');
                    }),
                    const SizedBox(
                      height: 40,
                    ),
                    _welcomeContainer('assets/nurse.png', 'I’m an Assistant',
                        () async {
                      print('Nurse Tapped');
                      dataProvider.dataProviderFunction(false);
                      await dataProvider.getAuthToken();
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString(
                          'auth_token', dataProvider.authToken?.token ?? '');
                      await prefs.setBool(
                          'isDoctorLogin', dataProvider.isDoctor ?? false);
                      Navigator.pushNamed(
                        context,
                        '/getStart',
                        arguments: {'username': 'Assistant'},
                      );
                      print('AUTHTOKEN-------${dataProvider.authToken?.token}');
                    }),
                  ],
                ),
              ),
      );
    });
  }

  Widget _textFunction(String title, double fontSize, FontWeight fontDesign) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: fontSize, fontWeight: fontDesign),
    );
  }

  Widget _welcomeContainer(String img, String heading, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration:
            const BoxDecoration(color: Color.fromRGBO(255, 255, 255, 1)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(img, fit: BoxFit.fill),
              const SizedBox(
                width: 20,
              ),
              _textFunction(heading, 14, FontWeight.w600)
            ],
          ),
        ),
      ),
    );
  }
}