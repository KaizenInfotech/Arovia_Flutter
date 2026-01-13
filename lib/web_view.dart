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
//         body: Column(
//          children: [
//           Expanded(
//              child: InAppWebView(
//             initialUrlRequest: URLRequest(url: WebUri(widget.selectedUrl)),
//             initialSettings: InAppWebViewSettings(
//               javaScriptEnabled: true,
//               mediaPlaybackRequiresUserGesture: false,
//               allowsInlineMediaPlayback: true,
//               // Add these iOS-specific settings
//               allowsBackForwardNavigationGestures: false,
//               disableHorizontalScroll: false,
//               disableVerticalScroll: false,
//               suppressesIncrementalRendering: true,
//               allowsLinkPreview: false,
//               ignoresViewportScaleLimits: false,
//               applePayAPIEnabled: false,
//
//             ),
//             onWebViewCreated: (controller) {
//               _webViewController = controller;
//             },
//                onLoadStop: (controller, url) async {
//                  // Inject JavaScript to fix iOS touch issues
//                  await controller.evaluateJavascript(source: """
//       (function() {
//         // Prevent iOS ghost clicks
//         document.addEventListener('touchend', function(e) {
//           e.stopImmediatePropagation();
//         }, true);
//
//         // Add touch-action CSS to buttons
//         var buttons = document.querySelectorAll('button, input[type="submit"], input[type="button"]');
//         buttons.forEach(function(btn) {
//           btn.style.touchAction = 'manipulation';
//           btn.style.webkitTouchCallout = 'none';
//         });
//       })();
//     """);
//                },
//           ),
//           )
//          ],
//         )
//       ),
//     );
//   }
// }

class _SimpleWebViewState extends State<WebViewContainer> {
  InAppWebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);

    if (widget.selectedUrl == "" || widget.selectedUrl.trim().isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.webTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.link_off, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Invalid or Missing URL',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'No valid link was provided to open.',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        Navigator.pop(context, true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.webTitle),
          leading: IconButton(
            onPressed: () async {
              Navigator.pop(context, true);
            },
            icon: const Icon(Icons.arrow_back),
          ),
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

                  // User Agent - helps with server compatibility
                  userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',

                  // Cookie and session management - CRITICAL for login
                  thirdPartyCookiesEnabled: true,
                  sharedCookiesEnabled: true,
                  cacheEnabled: true,
                  clearCache: false,

                  // Allow mixed content
                  mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,

                  // iOS-specific fixes
                  suppressesIncrementalRendering: true,
                  allowsLinkPreview: false,

                  // Additional settings
                  useOnNavigationResponse: true,
                  useShouldOverrideUrlLoading: true,

                  // Allow popups and new windows
                  supportMultipleWindows: false,
                  javaScriptCanOpenWindowsAutomatically: false,
                ),
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  print('Loading started: $url');
                },
                onLoadStop: (controller, url) async {
                  print('Page loaded: $url');

                  // Fix iOS ghost clicks with JavaScript
                  await controller.evaluateJavascript(source: """
                    (function() {
                      var style = document.createElement('style');
                      style.innerHTML = `
                        * {
                          touch-action: manipulation !important;
                          -webkit-touch-callout: none !important;
                          -webkit-tap-highlight-color: transparent !important;
                        }
                      `;
                      document.head.appendChild(style);
                      document.addEventListener('touchstart', function(){}, {passive: true});
                    })();
                  """);
                },
                onLoadError: (controller, url, code, message) {
                  print('Load error: $message (code: $code)');
                },
                onConsoleMessage: (controller, consoleMessage) {
                  print('Console: ${consoleMessage.message}');
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  // Allow all navigation
                  return NavigationActionPolicy.ALLOW;
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
