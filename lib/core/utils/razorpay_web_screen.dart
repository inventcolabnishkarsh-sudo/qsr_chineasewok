import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RazorpayPopupScreen extends StatefulWidget {
  final int amount; // in paise
  final String mobile;

  const RazorpayPopupScreen({
    super.key,
    required this.amount,
    required this.mobile,
  });

  @override
  State<RazorpayPopupScreen> createState() => _RazorpayPopupScreenState();
}

class _RazorpayPopupScreenState extends State<RazorpayPopupScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'PaymentChannel',
        onMessageReceived: (message) {
          if (message.message == "success") {
            _handlePaymentSuccess();
          } else if (message.message == "cancel") {
            _handlePaymentCancel();
          }
        },
      )
      ..loadHtmlString(_htmlContent());
  }

  String _htmlContent() {
    return '''
    <!DOCTYPE html>
    <html>
      <head>
        <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
      </head>
      <body onload="startPayment()" style="margin:0;">
        <script>
          function startPayment() {
            var options = {
              "key": "rzp_test_LTysJoN6nEVmkt",
              "amount": "${widget.amount}",
              "currency": "INR",
              "name": "Chinese Wok",
              "description": "Order Payment",
              "prefill": {
                "contact": "${widget.mobile}",
                "email": "customer@chinesewok.com"
              },
              "theme": {
                "color": "#E67E22"
              },
              "handler": function (response){
                PaymentChannel.postMessage("success");
              },
              "modal": {
                "ondismiss": function(){
                  PaymentChannel.postMessage("cancel");
                }
              }
            };

            var rzp = new Razorpay(options);
            rzp.open();
          }
        </script>
      </body>
    </html>
    ''';
  }

  void _handlePaymentCancel() async {
    Get.back(); // close razorpay popup

    await Future.delayed(const Duration(milliseconds: 300));

    Get.offAllNamed("/home"); // move directly to home
  }

  void _handlePaymentSuccess() async {
    Get.back(); // close payment popup

    await Future.delayed(const Duration(milliseconds: 300));

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 80),
              SizedBox(height: 20),
              Text(
                "Payment Successful!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    await Future.delayed(const Duration(seconds: 2));

    Get.offAllNamed("/home"); // change if needed
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SizedBox(
        width: 500,
        height: 650,
        child: Column(
          children: [
            /// 🌐 WEBVIEW
            Expanded(child: WebViewWidget(controller: _controller)),
          ],
        ),
      ),
    );
  }
}
