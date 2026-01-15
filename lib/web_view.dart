// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'data_provider.dart';
//
// class WebViewContainer extends StatefulWidget {
//   const WebViewContainer({
//     super.key,
//     required this.selectedUrl,
//     required this.webTitle,
//   });
//
//   final String selectedUrl;
//   final String webTitle;
//
//   @override
//   State<WebViewContainer> createState() => _SimpleWebViewState();
// }
//
// class _SimpleWebViewState extends State<WebViewContainer> {
//   InAppWebViewController? _webViewController;
//
//    @override
//   Widget build(BuildContext context) { final dataProvider = Provider.of<DataProvider>(context);
//
//    if (widget.selectedUrl == "" || widget.selectedUrl.trim().isEmpty) {
//      return Scaffold(
//        appBar: AppBar(
//          title: Text(widget.webTitle),
//          leading: IconButton(
//            icon: const Icon(Icons.arrow_back),
//            onPressed: () => Navigator.pop(context),
//          ),
//        ),
//        body: const Center(
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: [
//              Icon(Icons.link_off, size: 64, color: Colors.grey),
//              SizedBox(height: 16),
//              Text(
//                'Invalid or Missing URL',
//                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//              ),
//              SizedBox(height: 8),
//              Text(
//                'No valid link was provided to open.',
//                style: TextStyle(color: Colors.grey),
//                textAlign: TextAlign.center,
//              ),
//            ],
//          ),
//        ),
//      );
//    }
//
//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (didPop, result) async {
//         if (didPop) return;
//         Navigator.pop(context, true);
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(widget.webTitle),
//           leading: IconButton(onPressed: ()async{
//              Navigator.pop(context,true);
//           }, icon: Icon(Icons.arrow_back)),
//         ),
//         body: Stack(
//           alignment: AlignmentGeometry.center,
//          children: [
//           Expanded(
//              child: InAppWebView(
//             initialUrlRequest: URLRequest(url: WebUri(widget.selectedUrl)),
//                initialSettings: InAppWebViewSettings(
//                  javaScriptEnabled: true,
//                  mediaPlaybackRequiresUserGesture: false,
//                  allowsInlineMediaPlayback: true,
//                ),
//
//                onWebViewCreated: (controller) {
//               _webViewController = controller;
//             },
//
//              ),),
//
//          ],
//         )
//       ),
//     );
//   }
// }
//
//


import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data_provider.dart';

class WebViewContainer extends StatefulWidget {
  const WebViewContainer({
    super.key,
    required this.selectedUrl,
    required this.webTitle,
  });

  final String selectedUrl;
  final String webTitle;

  @override
  State<WebViewContainer> createState() => _SimpleWebViewState();
}

class _SimpleWebViewState extends State<WebViewContainer> {
  InAppWebViewController? _webViewController;

  @override
  Widget build(BuildContext context) { final dataProvider = Provider.of<DataProvider>(context);

  return Scaffold(
      appBar: AppBar(
        title: Text(widget.webTitle),
        leading: IconButton(onPressed: ()async{
          Navigator.pop(context,true);
        }, icon: Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(widget.selectedUrl)),
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  mediaPlaybackRequiresUserGesture: false,
                  allowsInlineMediaPlayback: true,
                ),
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                }
            ),
          )
        ],
      )
  );
  }
}
// class _WebViewContainerState extends State<WebViewContainer> {
//   late final WebViewController controller;

//   @override
//   void initState() {
//     super.initState();

//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (_) {
//             if (mounted) {

//             }
//           },
//           onPageFinished: (_) {
//             if (mounted) {

//             }
//           },
//           onWebResourceError: (error) {
//             if (mounted) {

//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Error loading: ${error.description}')),
//               );
//             }
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(widget.selectedUrl));
//   }

//   @override
//   void dispose() {
//     controller.clearCache();
//     controller.setNavigationDelegate(NavigationDelegate()); // Reset delegate
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.webTitle),
//       ),
//       body: WebViewWidget(
//         controller: controller,
//       ),
//     );
//   }
// }
