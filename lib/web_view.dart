import 'dart:io';

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
            },
          ),
          )
         ],
        )
      ),
    );
  }
}

// class _SimpleWebViewState extends State<WebViewContainer> {
//   InAppWebViewController? _webViewController;
//
//   @override
//   Widget build(BuildContext context) {
//     final dataProvider = Provider.of<DataProvider>(context);
//
//     if (widget.selectedUrl == "" || widget.selectedUrl.trim().isEmpty) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text(widget.webTitle),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ),
//         body: const Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.link_off, size: 64, color: Colors.grey),
//               SizedBox(height: 16),
//               Text(
//                 'Invalid or Missing URL',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'No valid link was provided to open.',
//                 style: TextStyle(color: Colors.grey),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       );
//     }
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
//           leading: IconButton(
//             onPressed: () async {
//               Navigator.pop(context, true);
//             },
//             icon: const Icon(Icons.arrow_back),
//           ),
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: InAppWebView(
//                 initialUrlRequest: URLRequest(url: WebUri(widget.selectedUrl)),
//                 initialSettings: InAppWebViewSettings(
//                   javaScriptEnabled: true,
//                   mediaPlaybackRequiresUserGesture: false,
//                   allowsInlineMediaPlayback: true,
//
//                   // User Agent - helps with server compatibility
//                   userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
//
//                   // Cookie and session management - CRITICAL for login
//                   thirdPartyCookiesEnabled: true,
//                   sharedCookiesEnabled: true,
//                   cacheEnabled: true,
//                   clearCache: false,
//
//                   // Allow mixed content
//                   mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
//
//                   // iOS-specific fixes
//                   suppressesIncrementalRendering: true,
//                   allowsLinkPreview: false,
//
//                   // Additional settings
//                   useOnNavigationResponse: true,
//                   useShouldOverrideUrlLoading: true,
//
//                   // Allow popups and new windows
//                   supportMultipleWindows: false,
//                   javaScriptCanOpenWindowsAutomatically: false,
//                 ),
//                 onWebViewCreated: (controller) {
//                   _webViewController = controller;
//                 },
//                 onLoadStart: (controller, url) {
//                   print('Loading started: $url');
//                 },
//                 onLoadStop: (controller, url) async {
//                   print('Page loaded: $url');
//
//                   // Fix iOS ghost clicks with JavaScript
//                   await controller.evaluateJavascript(source: """
//                     (function() {
//                       var style = document.createElement('style');
//                       style.innerHTML = `
//                         * {
//                           touch-action: manipulation !important;
//                           -webkit-touch-callout: none !important;
//                           -webkit-tap-highlight-color: transparent !important;
//                         }
//                       `;
//                       document.head.appendChild(style);
//                       document.addEventListener('touchstart', function(){}, {passive: true});
//                     })();
//                   """);
//                 },
//                 onLoadError: (controller, url, code, message) {
//                   print('Load error: $message (code: $code)');
//                 },
//                 onConsoleMessage: (controller, consoleMessage) {
//                   print('Console: ${consoleMessage.message}');
//                 },
//                 shouldOverrideUrlLoading: (controller, navigationAction) async {
//                   // Allow all navigation
//                   return NavigationActionPolicy.ALLOW;
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

///
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// // If you need Android-specific features
// import 'package:webview_flutter_android/webview_flutter_android.dart';
// // If you need iOS-specific features
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
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
//   State<WebViewContainer> createState() => _WebViewContainerState();
// }
//
// class _WebViewContainerState extends State<WebViewContainer> {
//   late final WebViewController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // ── Platform-specific creation params ─────────────────────────────────────
//     late final PlatformWebViewControllerCreationParams params;
//
//     if (WebViewPlatform.instance is WebKitWebViewPlatform) {
//       // iOS / macOS
//       params = WebKitWebViewControllerCreationParams(
//         allowsInlineMediaPlayback: true,
//         mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
//
//       );
//     } else {
//       // Android (and fallback)
//       params = const PlatformWebViewControllerCreationParams();
//     }
//
//     _controller = WebViewController.fromPlatformCreationParams(params)
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(Colors.transparent) // optional
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             // You can show progress bar here if you want
//             debugPrint('Loading: $progress%');
//           },
//           onPageStarted: (String url) {
//             debugPrint('Started: $url');
//           },
//           onPageFinished: (String url) async {
//             debugPrint('Finished: $url');
//
//             // ── iOS ghost click / touch fix injection ────────────────────────
//             // This is one of the most common remaining workarounds in 2025–2026
//             await _controller.runJavaScript('''
// (function () {
//   if (window.__ghostFixApplied) return;
//   window.__ghostFixApplied = true;
//
//   const style = document.createElement('style');
//   style.innerHTML = `
//     * {
//       touch-action: manipulation !important;
//       -webkit-touch-callout: none !important;
//       -webkit-user-select: none !important;
//       -webkit-tap-highlight-color: rgba(0,0,0,0) !important;
//     }
//
//     a, button, input, textarea, select {
//       touch-action: manipulation !important;
//     }
//   `;
//   document.head.appendChild(style);
//
//   // Force immediate click dispatch
//   document.addEventListener('touchend', function (e) {
//     const target = e.target.closest('a, button');
//     if (target) {
//       target.click();
//     }
//   }, { passive: true });
//
// })();
// ''');
//
//           },
//           onWebResourceError: (WebResourceError error) {
//             debugPrint('Error: ${error.description}');
//           },
//         ),
//       );
//
//     // ── Android-specific extras ──────────────────────────────────────────────
//     if (_controller.platform is AndroidWebViewController) {
//       AndroidWebViewController.enableDebugging(true);
//       (_controller.platform as AndroidWebViewController)
//           .setMediaPlaybackRequiresUserGesture(false);
//     }
//
//     // Load the initial URL
//     if (widget.selectedUrl.trim().isNotEmpty) {
//       _controller.loadRequest(Uri.parse(widget.selectedUrl));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final dataProvider = Provider.of<DataProvider>(context);
//
//     if (widget.selectedUrl.trim().isEmpty) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text(widget.webTitle),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ),
//         body: const Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.link_off, size: 64, color: Colors.grey),
//               SizedBox(height: 16),
//               Text(
//                 'Invalid or Missing URL',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'No valid link was provided to open.',
//                 style: TextStyle(color: Colors.grey),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (didPop, result) async {
//         if (didPop) return;
//
//         final canGoBack = await _controller.canGoBack();
//         if (canGoBack) {
//           await _controller.goBack();
//         } else {
//           if (context.mounted) {
//             Navigator.pop(context, true);
//           }
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(widget.webTitle),
//           leading: IconButton(
//             onPressed: () async {
//               final canGoBack = await _controller.canGoBack();
//               if (canGoBack) {
//                 await _controller.goBack();
//               } else {
//                 if (context.mounted) {
//                   Navigator.pop(context, true);
//                 }
//               }
//             },
//             icon: const Icon(Icons.arrow_back),
//           ),
//         ),
//         body: WebViewWidget(controller: _controller),
//       ),
//     );
//   }
// }

///
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// // Android
// import 'package:webview_flutter_android/webview_flutter_android.dart';
//
// // iOS
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
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
//   State<WebViewContainer> createState() => _WebViewContainerState();
// }
//
// class _WebViewContainerState extends State<WebViewContainer> {
//   late final WebViewController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // ───────────────── Platform creation params ─────────────────
//     late final PlatformWebViewControllerCreationParams params;
//
//     if (WebViewPlatform.instance is WebKitWebViewPlatform) {
//       params = WebKitWebViewControllerCreationParams(
//         allowsInlineMediaPlayback: true,
//         mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
//       );
//     }
//     else {
//       // Android
//       params = const PlatformWebViewControllerCreationParams();
//     }
//
//     _controller = WebViewController.fromPlatformCreationParams(params)
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(Colors.transparent)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (progress) {
//             debugPrint('Loading: $progress%');
//           },
//           onPageStarted: (url) {
//             debugPrint('Started: $url');
//           },
//           onPageFinished: (url) async {
//             debugPrint('Finished: $url');
//
//             // ───────────── iOS Ghost Click Fix ─────────────
//             await _controller.runJavaScript('''
// (function () {
//   if (window.__ghostFixApplied) return;
//   window.__ghostFixApplied = true;
//
//   const style = document.createElement('style');
//   style.innerHTML = `
//     * {
//       touch-action: manipulation !important;
//       -webkit-touch-callout: none !important;
//       -webkit-user-select: none !important;
//       -webkit-tap-highlight-color: rgba(0,0,0,0) !important;
//     }
//
//     a, button, input, textarea, select {
//       touch-action: manipulation !important;
//     }
//   `;
//   document.head.appendChild(style);
//
//   document.addEventListener('touchend', function (e) {
//     const el = e.target.closest('a, button');
//     if (el) el.click();
//   }, { passive: true });
//
// })();
// ''');
//
//           },
//           onWebResourceError: (error) {
//             debugPrint('Web error: ${error.description}');
//           },
//         ),
//       );
//
//     // ───────────────── Android extras ─────────────────
//     if (_controller.platform is AndroidWebViewController) {
//       AndroidWebViewController.enableDebugging(true);
//       (_controller.platform as AndroidWebViewController)
//           .setMediaPlaybackRequiresUserGesture(false);
//     }
//
//     // ───────────────── iOS extras ─────────────────
//     if (_controller.platform is WebKitWebViewController) {
//       // (_controller.platform as WebKitWebViewController)
//       //     .setScrollBounceEnabled(false); // reduces ghost taps
//     }
//
//     // Load URL
//     if (widget.selectedUrl.trim().isNotEmpty) {
//       _controller.loadRequest(Uri.parse(widget.selectedUrl));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final dataProvider = Provider.of<DataProvider>(context);
//
//     if (widget.selectedUrl.trim().isEmpty) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text(widget.webTitle),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ),
//         body: const Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.link_off, size: 64, color: Colors.grey),
//               SizedBox(height: 16),
//               Text(
//                 'Invalid or Missing URL',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'No valid link was provided to open.',
//                 style: TextStyle(color: Colors.grey),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (didPop, result) async {
//         if (didPop) return;
//
//         if (await _controller.canGoBack()) {
//           await _controller.goBack();
//         } else {
//           if (context.mounted) {
//             Navigator.pop(context, true);
//           }
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(widget.webTitle),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () async {
//               if (await _controller.canGoBack()) {
//                 await _controller.goBack();
//               } else {
//                 if (context.mounted) {
//                   Navigator.pop(context, true);
//                 }
//               }
//             },
//           ),
//         ),
//         body: WebViewWidget(controller: _controller),
//       ),
//     );
//   }
// }
