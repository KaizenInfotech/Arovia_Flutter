import 'package:arovia/count_down.dart';
import 'package:arovia/data_provider.dart';
import 'package:arovia/timer_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTP extends StatefulWidget {
  OTP(
      {super.key,
      required this.otp,
      required this.phn,
      required this.memType,
      required this.phnVersion,
      required this.imei,
      required this.phnName,
      required this.token});

  String? otp;
  final phn;
  final memType;
  final phnVersion;
  final imei;
  final phnName;
  final token;

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> with TickerProviderStateMixin {
  AnimationController? _controller;
  int otpTimer = 60;
  bool enableResend = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otp1Controller = TextEditingController();
  final TextEditingController _otp2Controller = TextEditingController();
  final TextEditingController _otp3Controller = TextEditingController();
  final TextEditingController _otp4Controller = TextEditingController();
  bool isValid = false;

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: otpTimer));

    _controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => enableResend = true); // enable
      } else if (status == AnimationStatus.forward) {
        setState(() => enableResend = false); // keep disabled while running
      }
    });

    _controller!.forward();
  }

  void verifyOtp() {
    String enteredOtp = _otp1Controller.text +
        _otp2Controller.text +
        _otp3Controller.text +
        _otp4Controller.text;

    isValid = (widget.otp == enteredOtp);

    if (isValid) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("OTP Verified!")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid OTP")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, dataProvider, child) {
      return Scaffold(
        backgroundColor: const Color.fromRGBO(251, 246, 227, 1),
        body: GestureDetector(
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
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildOtpField(_otp1Controller),
                            const SizedBox(
                                width: 10), // Add spacing between fields
                            _buildOtpField(_otp2Controller),
                            const SizedBox(width: 10),
                            _buildOtpField(_otp3Controller),
                            const SizedBox(width: 10),
                            _buildOtpField(_otp4Controller),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Spacer(),
                                Countdown(
                                  animation: StepTween(
                                    begin:
                                        otpTimer, // THIS IS A USER ENTERED NUMBER
                                    end: 0,
                                  ).animate(_controller!),
                                ),
                                const SizedBox(
                                  width: 7,
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width - 50,
                          child: ElevatedButton(
                            onPressed: () {
                              verifyOtp();
                              print('OTP Tapped');
                              Future.delayed(const Duration(seconds: 1),
                                  () async {
                                _login(dataProvider);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    const Color.fromRGBO(28, 40, 67, 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0))),
                            child: const Text('Verify OTP',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w400)),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Center(
                            child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            disabledForegroundColor: Colors.grey,
                            textStyle: const TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.black,
                                fontSize: 30,
                                fontStyle: FontStyle.normal),
                          ),
                          onPressed: () async {
                            print('RESEND Enabled');
                            setState(() {
                              otpTimer = 60;
                              _controller!.reset();
                              _controller!.forward();
                            });
                            await dataProvider.getLoginResult(
                                widget.phn,
                                widget.memType,
                                widget.phnName,
                                widget.imei,
                                widget.token,
                                widget.phnVersion);
                            final otp = dataProvider.loginResponse?.otp ?? '';
                            final pkMainId = dataProvider
                                    .loginResponse?.pkMainMemberMasterId ??
                                0;
                            widget.otp = otp;
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setInt('mem_ID', pkMainId);
                          },
                          child: Text('Resend OTP'),
                        ))
                      ],
                    ),
                  )),
            ),
          ),
        ),
      );
    });
  }

  void _login(DataProvider dataProvider) {
    if (isValid) {
      Navigator.pushNamed(context, '/dashboardscreen');
    }
  }

  Widget _buildOtpField(TextEditingController controller) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 6,
      height: 90,
      child: TextFormField(
        controller: controller,
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: '',
          filled: true, // Ensures background color applies
          fillColor: Colors.white, // White background
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide:
                const BorderSide(color: Colors.grey), // Default border color
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide:
                const BorderSide(color: Colors.grey), // Border when not focused
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
                color: Colors.blue, width: 2), // Highlighted border
          ),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus(); // Move to the next field
          }
        },
      ),
    );
  }
}
