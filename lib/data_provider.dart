import 'dart:async';
import 'dart:io';

import 'package:arovia/api_services.dart';
import 'package:arovia/data_model.dart';
import 'package:flutter/material.dart';

class DataProvider with ChangeNotifier {
  bool? _isDoctor;
  bool? get isDoctor => _isDoctor;

  //AUTHTOKEN API getAuthToken
  Result? _authToken;
  String _authError = '';
  bool _loading = false;
  Result? get authToken => _authToken;
  String get authError => _authError;
  bool get loading => _loading;

  //LOGINRESULT API getLoginResult
  Result? _loginResponse;
  bool _loginLoading = false;

  Result? get loginResponse => _loginResponse;
  bool get loginLoading => _loginLoading;

  //SESSIONTIMEOUT API getSessionTimeOut
  Result? _sessionTimeOutResponse;
  Result? get sessionTimeOutResponse => _sessionTimeOutResponse;

  // LOGOUT API
  Result? _logoutResponse;
  bool _logoutLoading = false;

  Result? get logoutResponse => _logoutResponse;
  bool get logoutLoading => _logoutLoading;

  //USERDETAIL API getUserDetail
  Result? _userDetailResponse;
  bool _userDetailLoading = false;
  Result? get userDetailResponse => _userDetailResponse;
  bool get userDetailLoading => _userDetailLoading;

  //APPOINTMENTLISTDOCTOR API getAppointmentListDoctor
  Result? _appointmentListDoctorResponse;
  bool _appointmentListDocLoading = false;
  Result? get appointmentListDoctorResponse => _appointmentListDoctorResponse;
  bool get appointmentListDocLoading => _appointmentListDocLoading;

  //APPOINTMENTLISTASSISTANT API getAppointmentListAssistant
  Result? _appointmentListAssistantResponse;
  bool _appointmentListAssisLoading = false;
  Result? get appointmentListAssistantResponse =>
      _appointmentListAssistantResponse;
  bool get appointmentListAssisLoading => _appointmentListAssisLoading;

  //PENDINGAPPOINTMENTLISTDOCTOR API getPendingAppointmentListDoctor
  Result? _pendingAppointmentListDoctorResponse;
  bool _pendingAppointmentListDocLoading = false;
  Result? get pendingAppointmentListDoctorResponse =>
      _pendingAppointmentListDoctorResponse;
  bool get pendingAppointmentListDocLoading =>
      _pendingAppointmentListDocLoading;

  //PENDINGAPPOINTMENTLISTASSISTANT API getPendingAppointmentListAssistant
  Result? _pendingAppointmentListAssistantResponse;
  bool _pendingAppointmentListAssisLoading = false;
  Result? get pendingAppointmentListAssistantResponse =>
      _pendingAppointmentListAssistantResponse;
  bool get pendingAppointmentListAssisLoading =>
      _pendingAppointmentListAssisLoading;

  //PATIENTLISTDOCTOR API getPatientListDoctor
  Result? _patientListDoctorResponse;
  bool _patientListDocLoading = false;
  Result? get patientListDoctorResponse => _patientListDoctorResponse;
  bool get patientListDocLoading => _patientListDocLoading;

  //PATIENTLISTASSISTANT API getPatientListAssistant
  Result? _patientListAssistantResponse;
  bool _patientListAssisLoading = false;
  Result? get patientListAssistantResponse => _patientListAssistantResponse;
  bool get patientListAssisLoading => _patientListAssisLoading;

  //ASSISTANT API getAssistant
  Result? _assistantResponse;
  bool _assisLoading = false;
  Result? get assistantResponse => _assistantResponse;
  bool get assisLoading => _assisLoading;

  //deleteAssistantAPI
  Result? _deleteAssistantResponse;
  bool _deleteAssisLoading = false;
  Result? get deleteAssistantResponse => _deleteAssistantResponse;
  bool get deleteAssisLoading => _deleteAssisLoading;

  //SEARCHAPPOINTMENTDOCTOR API getSearchAppointmentDoctor
  Result? _searchAppointmentDoctorResponse;
  bool _searchAppointmentDocLoading = false;
  Result? get searchAppointmentDoctorResponse =>
      _searchAppointmentDoctorResponse;
  bool get searchAppointmentDocLoading => _searchAppointmentDocLoading;

  //SEARCHAPPOINTMENTDOCTOR API getSearchAppointmentAssistant
  Result? _searchAppointmentAssistantResponse;
  bool _searchAppointmentAssisLoading = false;
  Result? get searchAppointmentAssistantResponse =>
      _searchAppointmentAssistantResponse;
  bool get searchAppointmentAssisLoading => _searchAppointmentAssisLoading;

  //CANCELAPPOINTMENT API getCancelAppointment
  Result? _cancelAppointmentResponse;
  bool _cancelAppointmentLoading = false;
  Result? get cancelAppointmentResponse => _cancelAppointmentResponse;
  bool get cancelAppointmentLoading => _cancelAppointmentLoading;

  //APPOINTMENTDETAILS API getAppointmentDetails
  Result? _appointmentDetailsResponse;
  bool _appointmentDetailsLoading = false;
  Result? get appointmentDetailsResponse => _appointmentDetailsResponse;
  bool get appointmentDetailsLoading => _appointmentDetailsLoading;

  //PatientReport API getPatientHistory
  Result? _patientHistoryResponse;
  bool _patientHistoryLoading = false;
  Result? get patientHistoryResponse => _patientHistoryResponse;
  bool get patientHistoryLoading => _patientHistoryLoading;

  //PatientReport API getPatientDocument
  Result? _patientDocumentResponse;
  bool _patientDocumentLoading = false;
  Result? get patientDocumentResponse => _patientDocumentResponse;
  bool get patientDocumentLoading => _patientDocumentLoading;

  //PatientReport API getPatientDocumentDelete
  Result? _patientDocumentDeleteResponse;
  bool _patientDocumentDeleteLoading = false;
  Result? get patientDocumenDeletetResponse => _patientDocumentDeleteResponse;
  bool get patientDocumentDeleteLoading => _patientDocumentDeleteLoading;

  //SUBSCRIPTION API getsubscription
  Result? _subscriptionResponse;
  bool _subscriptionLoading = false;
  Result? get subscriptionResponse => _subscriptionResponse;
  bool get subscriptionLoading => _subscriptionLoading;

  //SUBSCRIPTION PAYMENT API getSubscriptionPayment
  Result? _subscriptionPaymentResponse;
  bool _subscriptionPaymentLoading = false;
  Result? get subscriptionPaymentResponse => _subscriptionPaymentResponse;
  bool get subscriptionPaymentLoading => _subscriptionPaymentLoading;

  //SUBSCRIPTION ACTIVE DOCTOR API getSubscriptionActiveDoctorAPI
  Result? _subscriptionActiveDoctorResponse;
  bool _subscriptionActiveDoctorLoading = false;
  Result? get subscriptionActiveDoctorResponse => _subscriptionActiveDoctorResponse;
  bool get subscriptionActiveDoctorLoading => _subscriptionActiveDoctorLoading;

  //SUBSCRIPTION ACTIVE DOCTOR API getSubscriptionActiveASSISTANTAPI
  Result? _subscriptionActiveAssistantResponse;
  bool _subscriptionActiveAssistantLoading = false;
  Result? get subscriptionActiveAssistantResponse => _subscriptionActiveAssistantResponse;
  bool get subscriptionActiveAssistantLoading => _subscriptionActiveAssistantLoading;

  //WEBLINK API getWeblink
  Weblink? _weblinkResponse;
  bool _weblinkLoading = false;
  Weblink? get weblinkResponse => _weblinkResponse;
  bool get weblinkLoading => _weblinkLoading;

  //WhatsApp API
  Result? _whatsAppResponse;
  bool _whatsAppLoading = false;
  Result? get whatsAppResponse => _whatsAppResponse;
  bool get whatsAppLoading => _whatsAppLoading;

  void dataProviderFunction(bool isDoc) {
    _isDoctor = isDoc;
    notifyListeners();
  }

  Future<void> getAuthToken() async {
    _loading = true;
    _authError = '';
    _authToken = null;
    notifyListeners();
    try {
      _authToken = await ApiService.authTokenAPI();
    } on TimeoutException catch (_) {
      _authError = 'Request timed out. Please check your internet connection.';
    } on SocketException {
      _authError = 'No internet connection. Please try again.';
    } on HttpException catch (e) {
      _authError = e.message;
    } catch (e) {
      _authError = e.toString();
      _authToken = null;
    } finally {
      print("authTokenAPI :: $_authToken");
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> getLoginResult(String mobileNo, String memType, String devName,
      String imei, String devToken, String versionNo) async {
    _loginLoading = true;
    _authError = '';
    notifyListeners();
    try {
      _loginResponse = await ApiService.loginResultAPI(
          mobileNo, memType, devName, imei, devToken, versionNo);
    } on TimeoutException catch (_) {
      _authError = 'Request timed out. Please check your internet connection.';
    } on SocketException {
      _authError = 'No internet connection. Please try again.';
    } on HttpException catch (e) {
      _authError = e.message;
    } catch (e) {
      _authError = e.toString();
    } finally {
      _loginLoading = false;
      notifyListeners(); // Move notify here so it always fires
    }
  }

  Future<void> getSessionTimeOut(
    int pkMemId,
    String imei,
  ) async {
    _authError = '';
    notifyListeners();
    try {
      _sessionTimeOutResponse =
          await ApiService.sessionTimeOutAPI(pkMemId, imei);
    } on TimeoutException catch (_) {
      _authError = 'Request timed out. Please check your internet connection.';
    } on SocketException {
      _authError = 'No internet connection. Please try again.';
    } on HttpException catch (e) {
      _authError = e.message;
    } catch (e) {
      _authError = e.toString();
    }
    notifyListeners();
  }

  Future<void> getLogout(int pkMemId) async {
    try {
      _logoutResponse = null; // optional: reset first
      notifyListeners();

      final result = await ApiService.logoutAPI(pkMemId);

      _logoutResponse = result;
      print('_logoutResponse assigned: ${result.status} - ${result.message}');

      notifyListeners();
    } catch (e) {
      print("Logout API error: $e");
      // _logoutResponse = LogoutResult(status: "1", message: "Network error");
      notifyListeners();
    }
  }

  Future<void> getUserDetail(
    int pkMemId,
  ) async {
    _userDetailLoading = true;
    _authError = '';
    notifyListeners();
    try {
      _userDetailResponse = await ApiService.userDetailAPI(pkMemId);
      _userDetailLoading = false;
    } catch (e) {
      _authError = e.toString();
    } finally {
      _userDetailLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAppointmentListDoctor(
    String searchText,
    int fkMemId,
  ) async {
    _appointmentListDocLoading = true;
    _authError = '';
    notifyListeners();
    try {
      _appointmentListDoctorResponse =
          await ApiService.appointmentlistDoctorAPI(searchText, fkMemId);
      _appointmentListDocLoading = false;
    } catch (e) {
      _authError = e.toString();
    } finally {
      _appointmentListDocLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAppointmentListAssistant(
    String searchText,
    int fkMemId,
  ) async {
    _appointmentListAssisLoading = true;
    _authError = '';
    notifyListeners();
    try {
      _appointmentListAssistantResponse =
          await ApiService.appointmentlistAssistantAPI(searchText, fkMemId);
      _appointmentListAssisLoading = false;
    } catch (e) {
      _authError = e.toString();
    } finally {
      _appointmentListAssisLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPendingAppointmentListDoctor(
    String searchText,
    int fkMemId,
  ) async {
    _pendingAppointmentListDocLoading = true;
    _authError = '';
    notifyListeners();
    try {
      _pendingAppointmentListDoctorResponse =
          await ApiService.pendingAppointmentlistDoctorAPI(searchText, fkMemId);
      _pendingAppointmentListDocLoading = false;
    } catch (e) {
      _authError = e.toString();
    } finally {
      _pendingAppointmentListDocLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPendingAppointmentListAssistant(
    String searchText,
    int fkMemId,
  ) async {
    _pendingAppointmentListAssisLoading = true;
    _authError = '';
    notifyListeners();
    try {
      _pendingAppointmentListAssistantResponse =
          await ApiService.pendingAppointmentlistAssistantAPI(
              searchText, fkMemId);
      _pendingAppointmentListAssisLoading = false;
    } catch (e) {
      _authError = e.toString();
    } finally {
      _pendingAppointmentListAssisLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPatientListDoctor(
    String searchText,
    int fkMemId,
  ) async {
    _patientListDocLoading = true;
    _authError = '';
    notifyListeners();
    try {
      _patientListDoctorResponse =
          await ApiService.patientListDoctorAPI(searchText, fkMemId);
      _patientListDocLoading = false;
    } catch (e) {
      _authError = e.toString();
    } finally {
      _patientListDocLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPatientListAssistant(
    String searchText,
    int fkMemId,
  ) async {
    _patientListAssisLoading = true;
    _authError = '';
    notifyListeners();
    try {
      _patientListAssistantResponse =
          await ApiService.patientListAssistantAPI(searchText, fkMemId);
      _patientListAssisLoading = false;
    } catch (e) {
      _authError = e.toString();
    } finally {
      _patientListAssisLoading = false;
      notifyListeners();
    }
  }

  Future<void> getSearchAppointmentDoctor(
    String mobileNo,
    int fkMemId,
  ) async {
    _searchAppointmentDocLoading = true;
    _authError = '';
    notifyListeners();
    try {
      _searchAppointmentDoctorResponse =
          await ApiService.searchAppointmentDoctorAPI(mobileNo, fkMemId);
      _searchAppointmentDocLoading = false;
    } catch (e) {
      _authError = e.toString();
    } finally {
      _searchAppointmentDocLoading = false;
      notifyListeners();
    }
  }

  Future<void> getSearchAppointmentAssitant(
    String mobileNo,
    int fkMemId,
  ) async {
    _searchAppointmentAssisLoading = true;
    _authError = '';
    notifyListeners();
    try {
      _searchAppointmentAssistantResponse =
          await ApiService.searchAppointmentAssistantAPI(mobileNo, fkMemId);
      _searchAppointmentAssisLoading = false;
    } catch (e) {
      _authError = e.toString();
    } finally {
      _searchAppointmentAssisLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCancelAppointment(
    String remark,
    int fkMemId,
    int deletedBy,
  ) async {
    _cancelAppointmentLoading = true;
    _authError = '';
    notifyListeners();
    try {
      _cancelAppointmentResponse =
          await ApiService.cancelAppoinmentAPI(remark, fkMemId, deletedBy);
      _cancelAppointmentLoading = false;
    } catch (e) {
      _authError = e.toString();
    } finally {
      _cancelAppointmentLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAppointmentDetails(
    int fkMemId,
  ) async {
    _appointmentDetailsLoading = true;
    _authError = '';
    notifyListeners();
    try {
      _appointmentDetailsResponse =
          await ApiService.appoinmentDetailsAPI(fkMemId);
      _appointmentDetailsLoading = false;
    } catch (e) {
      _authError = e.toString();
    } finally {
      _appointmentDetailsLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPatientHistory(
    String searchTxt,
    int patientID,
  ) async {
    _patientHistoryLoading = true;
    _authError = '';
    notifyListeners();
    try {
      _patientHistoryResponse =
          await ApiService.patientHistoryAPI(searchTxt, patientID);
      _patientHistoryLoading = false;
    } catch (e) {
      _authError = e.toString();
    } finally {
      _patientHistoryLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPatientDocument(
    String searchTxt,
    int patientID,
  ) async {
    _patientDocumentLoading = true;
    _authError = '';
    notifyListeners();
    try {
      _patientDocumentResponse =
          await ApiService.patientDocumentListAPI(searchTxt, patientID);
      _patientDocumentLoading = false;
    } catch (e) {
      _authError = e.toString();
    } finally {
      _patientDocumentLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPatientDocumentDelete(
    int deletedBy,
    int fkDocID,
  ) async {
    _patientDocumentDeleteLoading = true;
    _authError = '';
    notifyListeners();
    try {
      _patientDocumentDeleteResponse =
          await ApiService.patientDocumentDeleteAPI(deletedBy, fkDocID);
      _patientDocumentDeleteLoading = false;
    } catch (e) {
      _authError = e.toString();
    } finally {
      _patientDocumentDeleteLoading = false;
      notifyListeners();
    }
  }

  Future<void> getSubscription(
    int pkMemId,
  ) async {
    _subscriptionLoading = true;
    _authError = '';
    notifyListeners();
    try {
      _subscriptionResponse = await ApiService.subscriptionDetailAPI(pkMemId);
      _subscriptionLoading = false;
    } catch (e) {
      _authError = e.toString();
    } finally {
      _subscriptionLoading = false;
      notifyListeners();
    }
  }

  Future<void> getSubscriptionPayment(
    int pkMemId,
  ) async {
    _subscriptionPaymentLoading = true;
    _authError = '';
    notifyListeners();
    try {
      _subscriptionPaymentResponse =
          await ApiService.subscriptionPaymentDoctorAPI(pkMemId);
      _subscriptionPaymentLoading = false;
    } catch (e) {
      _authError = e.toString();
    } finally {
      _subscriptionPaymentLoading = false;
      notifyListeners();
    }
  }

    Future<void> getSubscriptionActiveAssistantAPI(
    int pkMemId,
  ) async {
    _subscriptionActiveAssistantLoading = true;
    _authError = '';
    notifyListeners();
    try {
      _subscriptionActiveAssistantResponse =
          await ApiService.subscriptionActiveAssistantAPI(pkMemId);
      _subscriptionActiveAssistantLoading = false;
    } catch (e) {
      _authError = e.toString();
    } finally {
      _subscriptionActiveAssistantLoading = false;
      notifyListeners();
    }
  }

  Future<void> getSubscriptionActiveDoctorAPI(
    int pkMemId,
  ) async {
    _subscriptionActiveDoctorLoading = true;
    _authError = '';
    notifyListeners();
    try {
      _subscriptionActiveDoctorResponse =
          await ApiService.subscriptionActiveDoctorAPI(pkMemId);
      _subscriptionActiveDoctorLoading = false;
    } catch (e) {
      _authError = e.toString();
    } finally {
      _subscriptionActiveDoctorLoading = false;
      notifyListeners();
    }
  }

  

  Future<void> getAssistant(
    String searchText,
    int fkMemId,
  ) async {
    _assisLoading = true;
    _authError = '';
    notifyListeners();
    try {
      _assistantResponse = await ApiService.assistantAPI(searchText, fkMemId);
      _assisLoading = false;
    } catch (e) {
      _authError = e.toString();
    } finally {
      _assisLoading = false;
      notifyListeners();
    }
  }

  Future<void> getDeleteAssistant(
    int fkAssisID,
    int fkMemId,
  ) async {
    _deleteAssisLoading = true;
    _authError = '';
    notifyListeners();
    try {
      _deleteAssistantResponse =
          await ApiService.deleteAssistantAPI(fkAssisID, fkMemId);
      _deleteAssisLoading = false;
    } catch (e) {
      _authError = e.toString();
    } finally {
      _deleteAssisLoading = false;
      notifyListeners();
    }
  }

  Future<void> getWeblink(
      int loginMainID,
      int moduleID,
      int appointmentID,
      int patientID,
      int assistantID,
      int doctorID,
      int documentID,
      String phnNo) async {
    _weblinkLoading = true;
    _authError = '';
    notifyListeners();
    try {
      _weblinkResponse = await ApiService.weblinkAPI(loginMainID, moduleID,
          appointmentID, patientID, assistantID, doctorID, documentID, phnNo);
      _weblinkLoading = false;
    } catch (e) {
      _authError = e.toString();
    } finally {
      _weblinkLoading = false;
      notifyListeners();
    }
  }

  ForceUpdate? _loginData;
  final bool _isLoginLoading = false;
  String _logineError = '';

  ForceUpdate? get loginData => _loginData;
  bool get isLoginLoading => _isLoginLoading;
  String get logineError => _logineError;

  Future<void> getForceUpdate(String appName) async {
    _logineError = '';
    notifyListeners();

    try {
      _loginData = await ApiService.fetchForceUpdate(appName);
    } catch (e) {
      _logineError = e.toString();
    }
    notifyListeners();
  }

  
  Future<void> getwhatsApp(
      int pkID
      ) async {
    _whatsAppLoading = true;
    _authError = '';
    notifyListeners();
    try {
      _whatsAppResponse = await ApiService.WhatsAppAPI(pkID);
      _whatsAppLoading = false;
    } catch (e) {
      _authError = e.toString();
    } finally {
      _whatsAppLoading = false;
      notifyListeners();
    }
  }
}

