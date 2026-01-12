import 'dart:convert';
import 'package:arovia/data_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {

static const String baseUrl = "https://demoapi.arovia.in/api";

static Future<Result> authTokenAPI() async {

  final url = Uri.parse("$baseUrl/authtoken/authentication");

  Map<String, dynamic> requestBody = {
  "username": "Arovia",
  "password": "Arovia@2025\$"
};

try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('AUTHTOKENAPI SUCCESSFUL-----------------------------------------');
      }
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to login");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error: $e");
    }
    throw Exception("Failed to login");
  }
}

static Future<Result> loginResultAPI(
  String mobileNo, 
  String memType, 
  String devName, 
  String imei, 
  String devToken, 
  String versionNo
  ) async {

  final url = Uri.parse("$baseUrl/Login/loginCheck");

  Map<String, dynamic> requestBody = {
  "mobile_number": mobileNo,
  "member_type": memType,
  "device_name": devName,
  "imeI_No": imei,
  "deviceToken": devToken,
  "versionNo": versionNo
};

try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('LOGINRESULTAPI SUCCESSFUL-----------------------------------------');
      }
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to login");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error: $e");
    }
    throw Exception("Failed to login");
  }
}

static Future<Result> sessionTimeOutAPI(
  int pkMemId,
  String imei, 
  ) async {

  final url = Uri.parse("$baseUrl/Login/SessionTimeOut_VersionCheck");

  Map<String, dynamic> requestBody = {
  "pk_main_member_master_id": pkMemId,
  "IMEI_No": imei,
};

try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('SESSIONTIMEOUTAPI SUCCESSFUL-----------------------------------------');
      }
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to login");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error: $e");
    }
    throw Exception("Failed to login");
  }
}

static Future<Result> userDetailAPI(
  int pkMemId, 
  ) async {

  final url = Uri.parse("$baseUrl/Login/Login_User_Details");

  Map<String, dynamic> requestBody = {
 "pk_main_member_master_id": pkMemId
};

try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('USERDETAILAPI SUCCESSFUL-----------------------------------------${response.body}');
      }
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to login");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error: $e");
    }
    throw Exception("Failed to login");
  }
}

static Future<Result> logoutAPI(
    int pkMemId
    ) async {
  final url = Uri.parse("$baseUrl/Login/logOut");

  Map<String, dynamic> requestBody = {
    "pk_main_member_master_id": pkMemId,
  };

  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('LOGOUTAPI SUCCESSFUL-----------------------------------------${response.body}');
      }
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to logout: ${response.statusCode}");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error in logoutAPI: $e");
    }
    throw Exception("Failed to logout");
  }
}

static Future<Result> appointmentlistDoctorAPI(
  String searchText,
  int fkMemId, 
  ) async {

  final url = Uri.parse("$baseUrl/Appointment/get_Appointmentlist_for_Doctor");

  Map<String, dynamic> requestBody = {
  "txt_search": searchText,
  "fk_main_member_master_id_as_doctor_id": fkMemId
};

try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('APPOINTMENTLISTDOCTORAPI SUCCESSFUL-----------------------------------------${response.body}');
      }
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to login");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error: $e");
    }
    throw Exception("Failed to login");
  }
}

static Future<Result> appointmentlistAssistantAPI(
  String searchText,
  int fkMemId, 
  ) async {

  final url = Uri.parse("$baseUrl/Appointment/get_Appointmentlist_for_Assistant");

  Map<String, dynamic> requestBody = {
  "txt_search": searchText,
  "fk_main_member_master_id_as_Assistant_id": fkMemId
};

try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('APPOINTMENTLISTURl----$url');
        print('APPOINTMENTLISTPARAM----$requestBody');
        print('APPOINTMENTLISTASSISTANTAPI SUCCESSFUL-----------------------------------------${response.body}');
      }
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to login");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error: $e");
    }
    throw Exception("Failed to login");
  }
}

static Future<Result> pendingAppointmentlistDoctorAPI(
  String searchText,
  int fkMemId, 
  ) async {

  final url = Uri.parse("$baseUrl/Appointment/get_Pending_Appointmentlist_for_Doctor");
if (kDebugMode) {
  print("fkMemId ::: $fkMemId");
}
  Map<String, dynamic> requestBody = {
  "txt_search": searchText,
  "fk_main_member_master_id_as_doctor_id": fkMemId
};

  if (kDebugMode) {
    print("pendingAppointmentlistDoctorAPI <<<>>>>  $baseUrl/Appointment/get_Pending_Appointmentlist_for_Doctor");
    print("pendingAppointmentlistDoctorAPI requestBody <<<>>>>  $requestBody");
  }


try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('PENDINGAPPOINTMENTLISTDOCTORAPI SUCCESSFUL-----------------------------------------');
      }
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to login");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error: $e");
    }
    throw Exception("Failed to login");
  }
}

static Future<Result> pendingAppointmentlistAssistantAPI(
  String searchText,
  int fkMemId, 
  ) async {

  final url = Uri.parse("$baseUrl/Appointment/get_Pending_Appointmentlist_for_Assistant");

  Map<String, dynamic> requestBody = {
  "txt_search": searchText,
  "fk_main_member_master_id_as_Assistant_id": fkMemId
};

  if (kDebugMode) {
    print("pendingAppointmentlistAssistantAPI :: $url");
    print("pendingAppointmentlistAssistantAPI requestBody :: $requestBody");
  }


try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('PENDINGAPPOINTMENTLISTASSISTANTAPI SUCCESSFUL-----------------------------------------${response.body}');
      }
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to login");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error: $e");
    }
    throw Exception("Failed to login");
  }
}

static Future<Result> patientListDoctorAPI(
  String searchText,
  int fkMemId, 
  ) async {

  final url = Uri.parse("$baseUrl/Patients/get_patientlist_for_Doctor");

  Map<String, dynamic> requestBody = {
  "txt_search": searchText,
  "fk_main_member_master_id_as_doctor_id": fkMemId
};

try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('PATIENTLISTDOCTORAPI SUCCESSFUL-----------------------------------------');
      }
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to login");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error: $e");
    }
    throw Exception("Failed to login");
  }
}

static Future<Result> patientListAssistantAPI(
  String searchText,
  int fkMemId, 
  ) async {

  final url = Uri.parse("$baseUrl/Patients/get_patientlist_for_Assistant");

  Map<String, dynamic> requestBody = {
  "txt_search": searchText,
  "fk_main_member_master_id_as_Assistant_id": fkMemId
};

try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('PATIENTLISTASSISTANTAPI SUCCESSFUL-----------------------------------------');
      }
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to login");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error: $e");
    }
    throw Exception("Failed to login");
  }
}



static Future<Result> searchAppointmentDoctorAPI(
  String mobileNo,
  int fkMemId, 
  ) async {

  final url = Uri.parse("$baseUrl/Appointment/get_search_Appointment_by_Doctor");

  Map<String, dynamic> requestBody = {
  "mobile_number": mobileNo,
  "fk_main_member_master_id_as_doctor_id": fkMemId
};

try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('SEARCHAPPOINTMENTDOCTORAPI SUCCESSFUL-----------------------------------------');
      }
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to login");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error: $e");
    }
    throw Exception("Failed to login");
  }
}

static Future<Result> searchAppointmentAssistantAPI(
  String mobileNo,
  int fkMemId, 
  ) async {

  final url = Uri.parse("$baseUrl/Appointment/get_search_Appointment_by_Assistant");

  Map<String, dynamic> requestBody = {
  "mobile_number": mobileNo,
  "fk_main_member_master_id_as_doctor_id": fkMemId
};

try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('SEARCHAPPOINTMENTASSISTANTAPI SUCCESSFUL-----------------------------------------');
      }
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to login");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error: $e");
    }
    throw Exception("Failed to login");
  }
}

static Future<Result> cancelAppoinmentAPI(
  String remark,
  int fkMemId, 
  int deletedBy, 
  ) async {

  final url = Uri.parse("$baseUrl/Appointment/Cancle_Appointment");

  Map<String, dynamic> requestBody = {
  "fk_appointment_id": fkMemId,
  "deletedby": deletedBy,
  "remark": remark
};

try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('CANCELAPPOINTMENTAPI SUCCESSFUL-----------------------------------------');
      }
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to login");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error: $e");
    }
    throw Exception("Failed to login");
  }
}

static Future<Result> appoinmentDetailsAPI(
  int fkMemId, 
  ) async {

  final url = Uri.parse("$baseUrl/Appointment/get_Appointment_Details_By_ID");

  Map<String, dynamic> requestBody = {
  "fk_appointment_id": fkMemId
};

try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      print('APPOINTMENTDETAILSAPI SUCCESSFUL-----------------------------------------');
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to login");
    }
  } catch (e) {
    print("Error: $e");
    throw Exception("Failed to login");
  }
}

static Future<Result> patientHistoryAPI(
  String searchText, 
  int patientID,
  ) async {

  final url = Uri.parse("$baseUrl/Patients/get_appointment_list_by_patient_id");

  Map<String, dynamic> requestBody = {
   "txt_search": searchText,
   "fk_Patient_id": patientID
};

try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      print('PATIENTHISTORYAPI SUCCESSFUL-----------------------------------------');
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("PATIENTHISTORYAPI Failed to login");
    }
  } catch (e) {
    print("Error: $e");
    throw Exception("PATIENTHISTORYAPI Failed to login");
  }
}

static Future<Result> patientDocumentListAPI(
  String searchText, 
  int patientID,
  ) async {

  final url = Uri.parse("$baseUrl/Patients/get_document_list_Patient_id");

  Map<String, dynamic> requestBody = {
   "txt_search": searchText,
   "fk_Patient_id": patientID
};

try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      print('PATIENTDocumentAPI SUCCESSFUL-----------------------------------------');
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("PATIENTDocumentAPI Failed to login");
    }
  } catch (e) {
    print("Error: $e");
    throw Exception("PATIENTDocumentAPI Failed to login");
  }
}

static Future<Result> patientDocumentDeleteAPI(
  int deletedBy,  
  int fkdocID,
  ) async {

  final url = Uri.parse("$baseUrl/Patients/Delete_Document_By_ID");

  Map<String, dynamic> requestBody = {
   "deleted by": deletedBy,
   "fk_document_id": fkdocID
};

try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      print('PATIENTDocumentDeleteAPI SUCCESSFUL-----------------------------------------');
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("PATIENTDocumentDeleteAPI Failed to login");
    }
  } catch (e) {
    print("Error: $e");
    throw Exception("PATIENTDocumentDeleteAPI Failed to login");
  }
}

static Future<Result> subscriptionDetailAPI(
  int fkMemId, 
  ) async {

  final url = Uri.parse("$baseUrl/subscription/get_subsciption_details");

  Map<String, dynamic> requestBody = {
  "fk_main_member_master_id_as_doctor_id": fkMemId
};

try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      print('SUBSCRIPTION SUCCESSFUL-----------------------------------------');
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to login");
    }
  } catch (e) {
    print("Error: $e");
    throw Exception("Failed to login");
  }
}

static Future<Result> subscriptionPaymentDoctorAPI(
  int fkMemId, 
  ) async {

  final url = Uri.parse("$baseUrl/subscription/buy_the_subscription_plan");

  Map<String, dynamic> requestBody = {
  "fk_main_member_master_id_as_doctor_id": fkMemId
};

try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      print('SUBSCRIPTION PAYMENT SUCCESSFUL-----------------------------------------');
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to login");
    }
  } catch (e) {
    print("Error: $e");
    throw Exception("Failed to login");
  }
}

static Future<Result> subscriptionActiveDoctorAPI(
  int fkMemId, 
  ) async {

  final url = Uri.parse("$baseUrl/Login/check_subsciption_by_Doctor");

  Map<String, dynamic> requestBody = {
  "fk_main_member_master_id_as_doctor_id": fkMemId
};

try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      print('SUBSCRIPTION ACTIVE DOCTOR SUCCESSFUL-----------------------------------------');
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to login");
    }
  } catch (e) {
    print("Error: $e");
    throw Exception("Failed to login");
  }
}

static Future<Result> subscriptionActiveAssistantAPI(
  int fkMemId, 
  ) async {

  final url = Uri.parse("$baseUrl/Login/check_subsciption_by_assistant");

  Map<String, dynamic> requestBody = {
  "fk_main_member_master_id_as_assistant_id": fkMemId
};

try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      print('SUBSCRIPTION ACTIVE ASSISTANT SUCCESSFUL-----------------------------------------');
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to login");
    }
  } catch (e) {
    print("Error: $e");
    throw Exception("Failed to login");
  }
}

static Future<Result> assistantAPI(
  String searchText,
  int fkMemId, 
  ) async {

  final url = Uri.parse("$baseUrl/Assistant/get_assistant_list_for_Doctor");

  Map<String, dynamic> requestBody = {
  "fk_main_member_master_id_as_doctor_id": fkMemId,
  "txt_search": searchText
};

  print("assistantAPI ::: $baseUrl/Assistant/get_assistant_list_for_Doctor");
  print("assistantAPI requestBody ::: $requestBody");

try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      print('ASSISTANTAPI SUCCESSFUL-----------------------------------------$token');
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("ASSISTANTAPI Failed to login");
    }
  } catch (e) {
    print("Error: $e");
    throw Exception("ASSISTANTAPI Failed to login");
  }
}

static Future<Result> deleteAssistantAPI(
  int fkAssisID,
  int fkMemId, 
  ) async {

  final url = Uri.parse("$baseUrl/Assistant/Delete_assistant");

  Map<String, dynamic> requestBody = {
  "fk_main_member_master_id_as_doctor_id": fkMemId,
  "fk_assistant_id":fkAssisID
};

try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      print('ASSISTANTDELETEAPI SUCCESSFUL-----------------------------------------');
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("ASSISTANTDELETEAPI Failed to login");
    }
  } catch (e) {
    print("Error: $e");
    throw Exception("ASSISTANTDELETEAPI Failed to login");
  }
}

static Future<Weblink> weblinkAPI(
  int loginMainID,
  int moduleID,
  int appointmentID,
  int patientID,
  int assistantID,
  int doctorID,
  int documentID,
  String phnNo
  ) async {

  final url = Uri.parse("$baseUrl/Login/Web_login_from_Mobile");

  Map<String, dynamic> requestBody = {
    "fk_login_main_id": loginMainID,
    "fk_module_id": moduleID,
    "fk_appointment_id": appointmentID,
    "Fk_patient_id": patientID,
    "fk_assistant_id": assistantID,
    "fk_doctor_id": doctorID,
    "fk_document_id": documentID,
    "mobile_number": phnNo
};

  print("weblinkAPI <<<>>>>  $baseUrl/Login/Web_login_from_Mobile");
  print("weblinkAPI requestBody <<<>>>>  $requestBody");

try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      print('WEBLINKAPI SUCCESSFUL-----------------------------------------');
      return Weblink.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("WEBLINKAPI Failed to login");
    }
  } catch (e) {
    print("Error: $e");
    throw Exception("WEBLINKAPI Failed to login");
  }
}

static Future<ForceUpdate> fetchForceUpdate(String appName) async {
   final url = Uri.parse(
   "http://rotaryindiaapi.rosteronwheels.com/api/Group/get_version_for_force_update_all_application",
   );

    Map<String, dynamic> requestBody = {"ApplicationName": appName};

  try {
   final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(requestBody),
   );

   if (response.statusCode == 200) {
    print("FORCE UPDATE API SUCCESSFUL");
    return ForceUpdate.fromJson(json.decode(response.body));
   } else {
    throw Exception("Failed to load posts");
   }
  } catch (e) {
   print("Error: $e");
   throw Exception("Failed to login");
  }
   }

}