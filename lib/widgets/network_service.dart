import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkMonitorService {
  static final NetworkMonitorService _instance = NetworkMonitorService._internal();

  factory NetworkMonitorService() => _instance;
  NetworkMonitorService._internal();

  late BuildContext globalContext;

  bool _isDialogShown = false;
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  void start(BuildContext context) {
    globalContext = context;
    _subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _handleConnectionChange(results.isNotEmpty ? results.first : ConnectivityResult.none);
    });
  }

  void _handleConnectionChange(ConnectivityResult result) {
    bool isDisconnected = result == ConnectivityResult.none;

    if (isDisconnected && !_isDialogShown) {
      _showNoConnectionDialog();
    } else if (!isDisconnected && _isDialogShown) {
      // Navigator.of(globalContext, rootNavigator: true).pop(); // Close dialog
      _isDialogShown = false;
    }
  }

  void _showNoConnectionDialog() {
    _isDialogShown = true;
    bool isConnected = false;

    // Listen for network changes inside the dialog
    StreamSubscription<List<ConnectivityResult>>? dialogSubscription;

    showDialog(
      context: globalContext,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Start monitoring inside the dialog once
            dialogSubscription ??= Connectivity().onConnectivityChanged.listen((results) {
              final hasConnection = results.isNotEmpty && results.first != ConnectivityResult.none;
              if (hasConnection != isConnected) {
                setState(() {
                  isConnected = hasConnection;
                });
              }
            });

            return AlertDialog(
              title: Text("No Internet Connection"),
              content: Text("Please check your network settings."),
              actions: [
                TextButton(
                  onPressed: isConnected
                      ? () {
                          dialogSubscription?.cancel();
                          Navigator.of(globalContext, rootNavigator: true).pop();
                          _isDialogShown = false;
                        }
                      : null, // disables the button when not connected
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      dialogSubscription?.cancel(); // Ensure subscription is cancelled if user navigates back
    });
  }

  void stop() {
    _subscription.cancel();
  }
}

// class NetworkMonitorService {
//   static final NetworkMonitorService _instance = NetworkMonitorService._internal();
//   factory NetworkMonitorService() => _instance;
//   NetworkMonitorService._internal();
//
//   late StreamSubscription<List<ConnectivityResult>> _subscription;
//
//   // Public stream for UI to listen to
//   final _connectionStreamController = StreamController<bool>.broadcast();
//   Stream<bool> get connectionStream => _connectionStreamController.stream;
//
//   void start() {
//     _subscription = Connectivity().onConnectivityChanged.listen((results) {
//       final hasConnection = results.isNotEmpty && results.first != ConnectivityResult.none;
//       _connectionStreamController.add(hasConnection);
//     });
//   }
//
//   void stop() {
//     _subscription.cancel();
//     _connectionStreamController.close();
//   }
// }