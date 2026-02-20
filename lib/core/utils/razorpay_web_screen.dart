import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RazorpayWebScreen extends StatefulWidget {
  final int amount;
  final String mobile;

  const RazorpayWebScreen({
    super.key,
    required this.amount,
    required this.mobile,
  });

  @override
  State<RazorpayWebScreen> createState() => _RazorpayWebScreenState();
}

class _RazorpayWebScreenState extends State<RazorpayWebScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (error) {
            print("Web error: ${error.description}");
          },
        ),
      )
      ..addJavaScriptChannel(
        'PaymentChannel',
        onMessageReceived: (message) {
          if (message.message == "success") {
            _handlePaymentSuccess();
          } else {
            _handlePaymentCancel();
          }
        },
      )
      ..loadHtmlString(_htmlContent());
  }

  void _handlePaymentCancel() async {
    Navigator.pop(context); // close webview

    await Future.delayed(const Duration(milliseconds: 300));

    Get.offAllNamed("/home");
  }

  String _htmlContent() {
    return '''
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
  </head>
  <body>
    <script>

      function openCheckout() {
        var options = {
          "key": "rzp_test_LTysJoN6nEVmkt",
          "amount": "${widget.amount}",
          "currency": "INR",
          "name": "Home Essentials Pvt Ltd.",
          "description": "Order Payment",
          "prefill": {
            "contact": "${widget.mobile}",
            "email": "test@homeessentials.com"
          },
          "theme": {
            "color": "#c7834e"
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

        rzp.on('payment.failed', function (response){
          PaymentChannel.postMessage("failed");
        });

        rzp.open();
      }

      // 🔥 Wait until Razorpay script is available
      window.onload = function() {
        setTimeout(function() {
          if (typeof Razorpay !== "undefined") {
            openCheckout();
          } else {
            PaymentChannel.postMessage("failed");
          }
        }, 500);
      };

    </script>
  </body>
</html>
''';
  }

  void _handlePaymentSuccess() async {
    Navigator.pop(context); // Close WebView first

    await Future.delayed(const Duration(milliseconds: 300));

    Get.dialog(
      Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 80),
              SizedBox(height: 16),
              Text(
                "Payment Successful!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    await Future.delayed(const Duration(seconds: 2));

    Get.offAllNamed("/home"); // 🔥 change to your home route
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}
