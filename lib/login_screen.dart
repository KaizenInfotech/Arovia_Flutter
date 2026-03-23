import 'dart:io';

import 'package:arovia/data_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.memType});
  final memType;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? deviceVersion;
  String? imei;
  String? deviceName;
  String? deviceToken;

  @override
  void initState() {
    super.initState();
    getDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, dataProvider, child) {
      return Scaffold(
        backgroundColor: const Color.fromRGBO(251, 246, 227, 1),
        body: dataProvider.loginLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GestureDetector(
                onTap: () {
                  _formKey.currentState!.validate();
                  FocusScope.of(context).unfocus();
                },
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: Image.asset(
                                    'assets/arovia_logo.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              const Center(
                                  child: Text(
                                'Welcome Back!',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w500),
                              )),
                              const Center(
                                  child: Text(
                                'Use Credentials to access your account',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w300),
                              )),
                              const SizedBox(height: 30),
                              const Text(
                                'Phone Number',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,maxLength: 10,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter phone number',
                                    border: InputBorder.none,
                                    counterText: "",
                                    errorStyle: const TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 13,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 15.0),
                                  ),
                                  validator: _validatePhone,

                                ),
                              ),
                              const SizedBox(height: 40),
                              SizedBox(
                                height: 50,
                                width: MediaQuery.of(context).size.width - 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    print('Login Tapped');
                                    _login(dataProvider);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor:
                                          const Color.fromRGBO(28, 40, 67, 1),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0))),
                                  child: const Text('Continue',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w400)),
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                ),
              ),
      );
    });
  }

  void _login(DataProvider dataProvider) async {
    if (_formKey.currentState!.validate()) {
      await dataProvider.getLoginResult(
        _phoneController.text,
        widget.memType,
        deviceName ?? '',
        imei ?? '',
        deviceToken ?? '',
        deviceVersion ?? '',
      );

      final otp = dataProvider.loginResponse?.otp ?? '';
      final pkMainId = dataProvider.loginResponse?.pkMainMemberMasterId ?? 0;
      final status = dataProvider.loginResponse?.status ?? 0;

      debugPrint('''
------ LOGIN DEBUG ------
Phone            : ${_phoneController.text}
Member Type      : ${widget.memType}
Device Name      : $deviceName
Device Version   : $deviceVersion
IMEI             : $imei
Device Token     : $deviceToken

--- API RESPONSE ---
OTP              : $otp
Member ID        : $pkMainId
Status           : $status
-----------------------
''');


      if (status == "0") {
        Navigator.pushNamed(
          context,
          '/otpscreen',
          arguments: {
            'username': otp,
            'phn': _phoneController.text.trim(),
            'phnName': deviceName,
            'phnVersion': deviceVersion,
            'imei': imei,
            'memType': widget.memType,
            'token': deviceToken
          },
        );

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('login_user',_phoneController.text.trim());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("The mobile number entered is not registered.")));
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('mem_ID', pkMainId);

      print('Phone: ${_phoneController.text}');
      print('OTP: $otp');
      print('pkMainMemberMasterId: $pkMainId');
      print('STATUS: $status');
      print('STATUS: $status');
    }
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  Future<void> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    print('getDeviceInfo getting called');

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      setState(() {
        deviceName = 'Android';
        deviceVersion = androidInfo.version.release;
        imei = androidInfo.id;
      });
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      setState(() {
        deviceName = 'iOS';
        deviceVersion = iosInfo.systemVersion;
        imei = iosInfo.identifierForVendor ?? "N/A";
      });
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    deviceToken = prefs.getString('deviceTok') ?? '';
    await prefs.setString('imei', imei ?? '');

    print('DeviceName-----$deviceName');
    print('DeviceVersion-------$deviceVersion');
    print('DeviceToken-----$deviceToken');
    print('Imei---------$imei');
  }
}
