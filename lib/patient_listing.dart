import 'package:arovia/data_model.dart';
import 'package:arovia/data_provider.dart';
import 'package:arovia/widgets/profile_photo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/utils.dart';

class PatientListingPage extends StatefulWidget {
  PatientListingPage(
      {super.key,
      required this.headtitle,
      required this.patientID,
      required this.phoneNo,
      required this.response, this.patientName,});
  final headtitle;
  final patientID;
  final phoneNo;
  final patientName;
  Result? response;

  @override
  State<PatientListingPage> createState() => _PatientListingPageState();
}

class _PatientListingPageState extends State<PatientListingPage> {
  int? selectedIndex;
  int? pkaID;
  int? pkid;
  // int? patientID;
  int? docID;
  bool isDoctorLogin = false;
  FocusNode searchFocusNode = FocusNode();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _loadUserLoginType();
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
                    isDoctorLogin ? "Dr. ${user.firstName} ${user.lastName}"
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
                                  case 'Patient History':
                                    await dataProvider.getPatientHistory(
                                        value, widget.patientID);
                                    widget.response =
                                        dataProvider.patientHistoryResponse;
                                    break;

                                  case 'Patient Documents':
                                    await dataProvider.getPatientDocument(
                                        value, widget.patientID);
                                    widget.response =
                                        dataProvider.patientDocumentResponse;
                                    break;
                                }
                              }
                            }, // optional, set to true if you want auto keyboard
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
                      "${Utils().capitalizeEachWord(widget.patientName ??"")} ${widget.headtitle}" ?? '',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              if (widget.headtitle != 'Patient History')
                                _buildTopButton(Icons.delete, 'Delete', () {
                                  if (selectedIndex != null) {
                                    setState(() async {
                                      await dataProvider
                                          .getPatientDocumentDelete(
                                              0, docID ?? 0);
                                      await dataProvider.getPatientDocument(
                                          '', widget.patientID);
                                      widget.response =
                                          dataProvider.patientDocumentResponse;
                                      selectedIndex = null;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Deleted Successfully")));
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Please select the document to delete")));
                                  }
                                }),
                              const SizedBox(width: 8),
                              _buildTopButton(Icons.person_add, 'Add', () {
                                setState(() async {
                                  var loginID = pkid;
                                  var moduleID = (widget.headtitle ==
                                          'Patient Documents')
                                      ? isDoctorLogin
                                          ? 3
                                          : 8
                                      : (widget.headtitle == 'Patient History')
                                          ? isDoctorLogin
                                              ? 1
                                              : 6
                                          : 0;
                                  var phnNo =
                                      (widget.headtitle == 'Patient Documents')
                                          ? ''
                                          : widget.phoneNo;

                                  await dataProvider.getWeblink(
                                      loginID ?? 0,
                                      moduleID,
                                      0,
                                      widget.patientID,
                                      0,
                                      0,
                                      0,
                                      phnNo);
                                  print(
                                      'WEBLINK RESULT------${dataProvider.weblinkResponse?.result}');
                                  Navigator.pushNamed(
                                      context, '/webView', arguments: {
                                    'url': dataProvider.weblinkResponse?.result,
                                    'webTitle': 'Patient Documents'
                                  });
                                });
                              }),
                              const SizedBox(width: 8),
                              if (widget.headtitle != 'Patient History')
                                _buildTopButton(Icons.edit, 'Edit', () async {
                                  if (selectedIndex != null) {
                                    var loginID = pkid;
                                    var moduleID = (widget.headtitle ==
                                            'Patient Documents')
                                        ? isDoctorLogin
                                            ? 3
                                            : 8
                                        : 4;

                                    await dataProvider.getWeblink(
                                        loginID ?? 0,
                                        moduleID,
                                        0,
                                        widget.patientID,
                                        0,
                                        0,
                                        docID ?? 0,
                                        '');
                                    print(
                                        'WEBLINK RESULT------${dataProvider.weblinkResponse?.result}');
                                    Navigator.pushNamed(
                                        context, '/webView', arguments: {
                                      'url':
                                          dataProvider.weblinkResponse?.result,
                                      'webTitle': 'Patient Documents'
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Please select the document to edit")));
                                  }
                                }),
                            ],
                          ),
                        ),

                        // Header Row
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          // color: const Color(0xFF1B2235),
                          color: Colors.white,
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              Expanded(
                                  child: Text(
                                      (widget.headtitle == 'Patient History')
                                          ? 'Symptoms'
                                          : 'Document',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600))),
                              const Spacer(),
                              Text(
                                  (widget.headtitle == 'Patient History')
                                      ? 'status'
                                      : 'Date & Time',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(width: 50),
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
                              height: MediaQuery.of(context).size.height - 406,
                              child: ListView.separated(
                                itemCount: widget.response?.result.length ?? 0,
                                separatorBuilder: (_, __) => const Divider(
                                    height: 1, color: Colors.black),
                                itemBuilder: (context, index) {
                                  final isSelected = selectedIndex == index;

                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = index;
                                        docID = widget.response?.result[index]
                                            .pkDocumentId;
                                      });
                                    },
                                    child: Container(
                                      color: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 14),
                                      child: Row(
                                        children: [
                                          Icon(
                                            isSelected
                                                ? Icons.radio_button_checked
                                                : Icons.radio_button_unchecked,
                                            size: 16,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                                (widget.headtitle ==
                                                        'Patient History')
                                                    ? widget
                                                            .response
                                                            ?.result[index]
                                                            .symptoms ??
                                                        ''
                                                    : widget
                                                            .response
                                                            ?.result[index]
                                                            .title ??
                                                        '',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedIndex = index;
                                                docID = widget
                                                    .response
                                                    ?.result[index]
                                                    .pkDocumentId;
                                              });
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                // color: const Color(0xFFE6F2FA),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                  (widget.headtitle ==
                                                          'Patient History')
                                                      ? widget
                                                              .response
                                                              ?.result[index]
                                                              .status ??
                                                          ''
                                                      : widget
                                                              .response
                                                              ?.result[index]
                                                              .docCreateddate ??
                                                          '',
                                                  style: const TextStyle(
                                                      color: Colors.blue)),
                                            ),
                                          ),
                                          const SizedBox(width: 50),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedIndex = index;
                                                docID = widget
                                                    .response
                                                    ?.result[index]
                                                    .pkDocumentId;
                                              });
                                              Navigator.pushNamed(
                                                  context, '/detailScreen',
                                                  arguments: {
                                                    'headTitle':
                                                        widget.headtitle,
                                                    'response': widget.response,
                                                    'indexes': index,
                                                    'patientID':
                                                        widget.patientID,
                                                        'status': widget.response?.result
                                                                      
                                                  });
                                              debugPrint(
                                                  'Tapped view icon at index ${widget.response}');
                                            },
                                            child: const Icon(
                                                Icons.remove_red_eye_outlined,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
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
              color: Colors.white70),
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
}
