import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final int cost;
  final String doctorName;
  final String pateintName;
  final String orderId;

  const PaymentScreen(
      {Key key,
      @required this.cost,
      @required this.doctorName,
      @required this.pateintName,
      @required this.orderId})
      : super(key: key);
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        onPageStarted: (input) {},
        onPageFinished: (output) {
          print('Paaaayymmeeeeeeeeeeeeeeeeeeeeeeent');
          print(output);
        },
        initialUrl:
            "https://onlineconsultation.sphinxkc.com/NBEPayment.php?s_name=${widget.doctorName}&s_price=${widget.cost}&OID=${widget.orderId}",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
