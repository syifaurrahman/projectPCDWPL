import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserOpener extends StatefulWidget {
  final String url; // Declare a URL parameter

  const BrowserOpener({Key? key, required this.url})
      : super(key: key); // Add required url in constructor

  @override
  State<BrowserOpener> createState() => _BrowserOpenerState();
}

class _BrowserOpenerState extends State<BrowserOpener> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
          Uri.parse(widget.url)); // Use the URL parameter from the widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browser')),
      body: WebViewWidget(controller: controller),
    );
  }
}
