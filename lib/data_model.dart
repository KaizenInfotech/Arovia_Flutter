//---------DATA MODEL-----------

class Result {
  final String? status;
  final String? message;
  final String? token;
  final String? otp;
  final String? expiry;
  final String? timeleft;
  final String? subsciptionStatus;
  final String? amount;
  final String? paymentlink;
  final int? pkMainMemberMasterId;
  final List<ResultElement> result; // Ensuring this is always a list

  Result({
    required this.status,
    required this.message,
    required this.token,
    required this.otp,
    required this.expiry,
    required this.timeleft,
    required this.subsciptionStatus,
    required this.amount,
    required this.paymentlink,
    required this.pkMainMemberMasterId,
    required this.result,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      status: json["result"]?["status"],
      message: json["result"]?["message"],
      token: json["result"]?["token"],
      otp: json["result"]?["otp"],
      expiry: json["result"]?["expiry"],
      timeleft: json["result"]?["timeleft"],
      subsciptionStatus: json["result"]?["subsciption_Status"],
      amount: json["result"]?["amount"],
      paymentlink: json["result"]?["paymentlink"],
      pkMainMemberMasterId: json["result"]?["pk_main_member_master_id"],
      result: (json["result"]?["result"] as List?)?.map((item) => ResultElement.fromJson(item)).toList() ?? [],
    );
  }
}

class ResultElement {
  final int? pkMainMemberMasterId;
  final String? membertype;
  final String? cashfreeStatus;
  final String? vendorId;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? mobileNumber;
  final String? emailAddress;
  final String? profilePhoto;
  final int? srno;
  final int? pkDocumentId;
  final int? fkAppointmentId;
  final int? pkAppointmentId;
  final int? fkPatientId;
  final String? symptoms;
  final String? docAppointmentDate;
  final String? fkStatusId;
  final String? patiantName;
  final String? patiantMobileNumber;
  final String? title;
  final String? type;
  final String? url;
  final String? docCreateddate;
  final String? appointmentDate;
  final String? status;
  final int? pkPatientId;
  final String? createddate;
  final String? pendingAmount;
  final int? fkMainMemberMasterIdAsDoctorId;
  final List<PatientDetails>? patientDetails;
  final List<AppointmentDetails>? appointmentDetails;
  final List<AppointmentDocument>? appointmentDocuments;

  ResultElement({
    required this.pkMainMemberMasterId,
    required this.membertype,
    required this.name,
    required this.cashfreeStatus,
    required this.vendorId,
    required this.fkAppointmentId,
    required this.pkDocumentId,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.emailAddress,
    required this.profilePhoto,
    required this.srno,
    required this.pkAppointmentId,
    required this.fkPatientId,
    required this.patiantName,
    required this.patiantMobileNumber,
    required this.appointmentDate,
    required this.status,
    required this.title,
    required this.type,
    required this.url,
    required this.docCreateddate,
    required this.symptoms,
    required this.docAppointmentDate,
    required this.fkStatusId,
    required this.pkPatientId,
    required this.createddate,
    required this.pendingAmount,
    required this.fkMainMemberMasterIdAsDoctorId,
    required this.patientDetails,
    required this.appointmentDetails,
    required this.appointmentDocuments,
  });

  factory ResultElement.fromJson(Map<String, dynamic> json) {
    return ResultElement(
      pkMainMemberMasterId: json["pk_main_member_master_id"],
      membertype: json["membertype"] ?? "",
      pkDocumentId: json["pk_document_id"],
      fkAppointmentId: json["fk_appointment_id"],
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      mobileNumber: json["mobile_Number"] ?? "",
      emailAddress: json["email_address"] ?? "",
      profilePhoto: json["profile_photo"] ?? "",
      srno: json["srno"],
      pkAppointmentId: json["pk_appointment_id"],
      fkPatientId: json["fk_Patient_id"],
      patiantName: json["patiant_name"] ?? "",
      symptoms: json["symptoms"] ?? "",
      docAppointmentDate: json["doc_appointment_date"] ?? "",
      fkStatusId: json["fk_status_id"] ?? "",
      patiantMobileNumber: json["patiant_mobile_number"] ?? "",
      appointmentDate: json["appointment_date"] ?? "",
      status: json["status"] ?? "",
      pkPatientId: json["pk_Patient_id"],
      title: json["title"] ?? "",
      type: json["type"] ?? "",
      url: json["url"] ?? "",
      name: json["name"] ?? "",
      cashfreeStatus: json["status"] ?? "",
      vendorId: json["vendor_id"] ?? "",
      docCreateddate: json["doc_createddate"] ?? "",
      createddate: json["createddate"] ?? "",
      pendingAmount: json["pendingAmount"] ?? "",
      fkMainMemberMasterIdAsDoctorId: json["fk_main_member_master_id_as_doctor_id"],
      patientDetails: (json["patient_details"] as List?)?.map((item) => PatientDetails.fromJson(item)).toList() ?? [],
      appointmentDetails: (json["appointment_details"] as List?)?.map((item) => AppointmentDetails.fromJson(item)).toList() ?? [],
      appointmentDocuments: (json["appointment_Documents"] as List?)?.map((item) => AppointmentDocument.fromJson(item)).toList() ?? [],
    );
  }
}

class AppointmentDocument {
  final int? srno;
  final int? pkDocumentId;
  final int? fkPatientId;
  final int? fkAppointmentId;
  final String? title;
  final String? type;
  final String? url;

    AppointmentDocument({
        required this.srno,
        required this.pkDocumentId,
        required this.fkPatientId,
        required this.fkAppointmentId,
        required this.title,
        required this.type,
        required this.url,
    });

    factory AppointmentDocument.fromJson(Map<String, dynamic> json) {
    return AppointmentDocument(
      srno: json["srno"],
      pkDocumentId: json["pk_document_id"],
      fkPatientId: json["fk_Patient_id"], 
      fkAppointmentId: json["fk_appointment_id"], 
      title: json["title"], 
      type: json["type"],
      url: json["url"],
      );
    }

}

class PatientDetails {
final String? title;
final String? type;
final String? url;

 PatientDetails({
        required this.title,
        required this.type,
        required this.url,
 });

    factory PatientDetails.fromJson(Map<String, dynamic> json) {
    return PatientDetails( 
      title: json["title"], 
      type: json["type"],
      url: json["url"],
      );
    }

}

class AppointmentDetails {
final String? title;
final String? type;
final String? url;

 AppointmentDetails({
        required this.title,
        required this.type,
        required this.url,
 });

    factory AppointmentDetails.fromJson(Map<String, dynamic> json) {
    return AppointmentDetails( 
      title: json["title"], 
      type: json["type"],
      url: json["url"],
      );
    }
}

class Weblink {
  final String? status;
  final String? message;
  final String? result;

    Weblink({
        required this.status,
        required this.message,
        required this.result,
    });

    factory Weblink.fromJson(Map<String, dynamic> json) {
    return Weblink(
      status: json["result"]?["status"],
      message: json["result"]?["message"],
      result: json["result"]?["result"],
    );
  }

}

class LogoutResult {
  final String status;
  final String message;

  LogoutResult({required this.status, required this.message});

  factory LogoutResult.fromJson(Map<String, dynamic> json) {
    // The actual data is inside "result"
    final resultMap = json['result'] as Map<String, dynamic>? ?? {};

    return LogoutResult(
      status: (resultMap['status'] ?? "1").toString(),
      message: resultMap['message'] ?? "Unknown error",
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
  };
}
class ForceUpdate {
  TBGroupResult? tBGroupResult;

  ForceUpdate({this.tBGroupResult});

  ForceUpdate.fromJson(Map<String, dynamic> json) {
    tBGroupResult = json['TBGroupResult'] != null
        ? TBGroupResult.fromJson(json['TBGroupResult'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tBGroupResult != null) {
      data['TBGroupResult'] = tBGroupResult!.toJson();
    }
    return data;
  }
}

class TBGroupResult {
  String? status;
  String? message;
  int? pkVID;
  String? android;
  String? iOS;
  String? dotNetVersion;
  String? description;
  String? applicationName;
  String? curDate;

  TBGroupResult({
    this.status,
    this.message,
    this.pkVID,
    this.android,
    this.iOS,
    this.dotNetVersion,
    this.description,
    this.applicationName,
    this.curDate,
  });

  TBGroupResult.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    pkVID = json['pk_VID'];
    android = json['Android'];
    iOS = json['IOS'];
    dotNetVersion = json['DotNetVersion'];
    description = json['Description'];
    applicationName = json['Application_name'];
    curDate = json['curDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['pk_VID'] = pkVID;
    data['Android'] = android;
    data['IOS'] = iOS;
    data['DotNetVersion'] = dotNetVersion;
    data['Description'] = description;
    data['Application_name'] = applicationName;
    data['curDate'] = curDate;
    return data;
  }
}