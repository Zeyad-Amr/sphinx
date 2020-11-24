import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        onPageStarted: (input) {},
        onPageFinished: (output) {},
        initialUrl: "https://onlineconsultation.sphinxkc.com/",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
