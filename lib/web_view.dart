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
