import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int cost = 500;
  String doctorName = 'Dr.Zeyad Aamr';
  String pateintName = 'Abas AHmed';
  String orderId = '123456';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        onPageStarted: (input) {},
        onPageFinished: (output) {},
        initialUrl:
            "https://onlineconsultation.sphinxkc.com/NBEPayment.php?s_name=$doctorName&s_price=$cost&oid=$orderId",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
