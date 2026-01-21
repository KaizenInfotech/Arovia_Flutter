import 'package:arovia/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key, required this.memType});
  final memType;
  @override
  Widget build(BuildContext context) {
    final isDoctor = Provider.of<DataProvider>(context).isDoctor ?? false;
    return Scaffold(
      backgroundColor: Colors.white,//const Color.fromRGBO(251, 246, 227, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(251, 246, 227, 1),
        elevation: 0,bottomOpacity: 0,scrolledUnderElevation: 0,
      ),
      body: SafeArea(  // ← Very important for iPad / iOS
        child: SingleChildScrollView(  // ← Makes the whole screen scrollable
          child: Column(
            children: [
              // Image section – no fixed height needed anymore
              Container(
                color: const Color.fromRGBO(251, 246, 227, 1),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                width: double.infinity,
                child: isDoctor
                    ? Image.asset('assets/get_start_doc.png', fit: BoxFit.contain)
                    : Image.asset('assets/get_start_nurse.png', fit: BoxFit.contain),
              ),

              // Bottom white container
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isDoctor
                          ? 'Effortless Appointment\nManagement at Your Fingertips'
                          : 'Seamless Scheduling and\nPatient Care Made Simple',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width > 600 ? 32 : 24,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 22),
                    Text(
                      isDoctor
                          ? 'Manage schedules, track patient information, and streamline your workflow all in one place.'
                          : 'Designed for doctors and assistants to simplify patient appointments and enhance collaboration.',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width > 600 ? 22 : 18,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 56,
                      width: MediaQuery.of(context).size.width > 600
                          ? 400
                          : MediaQuery.of(context).size.width - 48,
                      child: ElevatedButton(
                        onPressed: () {
                          print('Get Started Tapped');
                          Navigator.pushNamed(
                            context,
                            '/loginscreen',
                            arguments: {'username': memType},
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color.fromRGBO(28, 40, 67, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24), // Extra space at bottom
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // Column(
      //   children: [
      //     SizedBox(
      //        height:  MediaQuery.of(context).size.height/2 - 50,
      //       child: isDoctor ?
      //       Image.asset('assets/get_start_doc.png', fit: BoxFit.fill,) :
      //       Image.asset('assets/get_start_nurse.png', fit: BoxFit.fill,)
      //     ),
      //     // Expanded(
      //     //   child: Container(
      //     //     width: MediaQuery.of(context).size.width,
      //     //     decoration: const BoxDecoration(
      //     //       borderRadius: BorderRadius.only(
      //     //         topLeft: Radius.circular(20.0),
      //     //         topRight: Radius.circular(20.0)
      //     //       ),
      //     //       color: Colors.white
      //     //     ),
      //     //     child: Stack(
      //     //       children: [
      //     //         Padding(
      //     //           padding: const EdgeInsets.only(bottom: 16.0,top: 16.0,left: 10.0,right: 10.0),
      //     //           child: Column(
      //     //             children: [
      //     //               Text(
      //     //                 isDoctor
      //     //                     ? 'Effortless Appointment\nManagement at Your Fingertips'
      //     //                     : 'Seamless Scheduling and\nPatient Care Made Simple',
      //     //                 style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      //     //                 textAlign: TextAlign.center,
      //     //               ),
      //     //               const SizedBox(height: 20),
      //     //               Text(
      //     //                 isDoctor
      //     //                     ? 'Manage schedules, track patient information, and streamline your workflow all in one place.'
      //     //                     : 'Designed for doctors and assistants to simplify patient appointments and enhance collaboration.',
      //     //                 style: const TextStyle(fontSize: 18, color: Colors.grey),
      //     //                 textAlign: TextAlign.center,
      //     //               ),
      //     //               const SizedBox(height: 40),
      //     //
      //     //             // crossAxisAlignment: CrossAxisAlignment.center,
      //     //             // mainAxisAlignment: MainAxisAlignment.center,
      //     //             // children: [
      //     //             //   Text( isDoctor ? 'Effortless Appointment' : 'Seamless Scheduling and', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),textAlign: TextAlign.center),
      //     //             //   Text( isDoctor ? 'Management at Your Fingertips' : 'Patient Care Made Simple', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),textAlign: TextAlign.center),
      //     //             //   Text( isDoctor ? 'Manage schedules, track patient' : 'Designed for doctors and assistants to', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),textAlign: TextAlign.center),
      //     //             //   Text( isDoctor ? 'information, and streamline your' : 'simplify patient appointments and', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),textAlign: TextAlign.center),
      //     //             //   Text( isDoctor ? 'workflow all in one place.' : 'enhance collaboration.', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),textAlign: TextAlign.center),
      //     //             //   const SizedBox(
      //     //             //     height: 30,
      //     //             //   ),
      //     //               SizedBox(
      //     //                 height: 50,
      //     //                 width: MediaQuery.of(context).size.width - 50,
      //     //                 child: ElevatedButton(
      //     //                    onPressed: () {
      //     //                     print('Get Started Tapped');
      //     //                     Navigator.pushNamed(
      //     //                       context,
      //     //                       '/loginscreen',
      //     //                       arguments: {'username': memType},
      //     //                       );
      //     //
      //     //                    },
      //     //                 style: ElevatedButton.styleFrom(
      //     //                   foregroundColor: Colors.white,
      //     //                   backgroundColor: const Color.fromRGBO(28, 40, 67, 1),
      //     //                   shape: RoundedRectangleBorder(
      //     //                     borderRadius: BorderRadius.circular(20.0)
      //     //                   )
      //     //                 ),
      //     //                 child: const Text('Get Started', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
      //     //                 ),
      //     //               ),
      //     //                 const SizedBox(height: 10)
      //     //             ],
      //     //           ),
      //     //         )
      //     //       ],
      //     //     ),
      //     //   )
      //     // )
      //
      //     Expanded(
      //       child: Container(
      //         width: double.infinity,
      //         decoration: const BoxDecoration(
      //           borderRadius: BorderRadius.only(
      //             topLeft: Radius.circular(20.0),
      //             topRight: Radius.circular(20.0),
      //           ),
      //           color: Colors.white,
      //         ),
      //         child: SingleChildScrollView(  // ← Add this to make it scrollable if needed
      //           padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Text(
      //                 isDoctor
      //                     ? 'Effortless Appointment\nManagement at Your Fingertips'
      //                     : 'Seamless Scheduling and\nPatient Care Made Simple',
      //                 style: TextStyle(
      //                   fontSize: MediaQuery.of(context).size.width > 600 ? 32 : 24,  // Larger on tablets
      //                   fontWeight: FontWeight.w600,
      //                 ),
      //                 textAlign: TextAlign.center,
      //               ),
      //               const SizedBox(height: 24),
      //               Text(
      //                 isDoctor
      //                     ? 'Manage schedules, track patient information, and streamline your workflow all in one place.'
      //                     : 'Designed for doctors and assistants to simplify patient appointments and enhance collaboration.',
      //                 style: TextStyle(
      //                   fontSize: MediaQuery.of(context).size.width > 600 ? 22 : 18,
      //                   color: Colors.grey,
      //                 ),
      //                 textAlign: TextAlign.center,
      //               ),
      //               const SizedBox(height: 48),
      //               SizedBox(
      //                 height: 56,  // Slightly taller button on larger screens
      //                 width: MediaQuery.of(context).size.width > 600
      //                     ? 400  // Fixed wide button on tablets
      //                     : MediaQuery.of(context).size.width - 48,
      //                 child: ElevatedButton(
      //                   onPressed: () {
      //                     print('Get Started Tapped');
      //                     Navigator.pushNamed(
      //                       context,
      //                       '/loginscreen',
      //                       arguments: {'username': memType},
      //                     );
      //                   },
      //                   style: ElevatedButton.styleFrom(
      //                     foregroundColor: Colors.white,
      //                     backgroundColor: const Color.fromRGBO(28, 40, 67, 1),
      //                     shape: RoundedRectangleBorder(
      //                       borderRadius: BorderRadius.circular(20.0),
      //                     ),
      //                   ),
      //                   child: const Text(
      //                     'Get Started',
      //                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
      //                   ),
      //                 ),
      //               ),
      //               const SizedBox(height: 16),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),

    );
  }
}