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
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  String _otpValue = '';

  bool isValid = false;

  @override
  void dispose() {
    _controller!.dispose();
    _otpController.dispose();
    _otpFocusNode.dispose();
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
    String enteredOtp = _otpValue;

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
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
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
                        GestureDetector(
                          onTap: () {
                            _otpFocusNode.requestFocus();
                          },
                          child: Stack(
                            children: [
                              // Hidden TextField - single field, no focus switching
                              Opacity(
                                opacity: 0,
                                child: SizedBox(
                                  height: 1,
                                  child: TextField(
                                    controller: _otpController,
                                    focusNode: _otpFocusNode,
                                    keyboardType: TextInputType.number,
                                    maxLength: 4,
                                    autofocus: true,
                                    onChanged: (value) {
                                      setState(() {
                                        _otpValue = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              // Visual OTP boxes
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(4, (index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: _buildOtpBox(index),
                                  );
                                }),
                              ),
                            ],
                          ),
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

  Widget _buildOtpBox(int index) {
    bool isFilled = index < _otpValue.length;
    bool isActive = index == _otpValue.length && _otpFocusNode.hasFocus;
    return Container(
      width: MediaQuery.of(context).size.width / 6,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: isActive ? Colors.blue : Colors.grey,
          width: isActive ? 2 : 1,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        isFilled ? _otpValue[index] : '',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
