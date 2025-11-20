import 'package:civicsphere/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentPage extends StatefulWidget {
  final String amount;
  final String email;
  final String jobId;

  const PaymentPage({super.key, 
    required this.amount,
    required this.email,
    required this.jobId,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("✅ Payment Success: ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("❌ Payment Error: ${response.code} - ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("💼 External Wallet: ${response.walletName}");
  }

  void openCheckout() {
    var options = {
      'key': 'rzp_test_BvNKeMPIkwXwxi',
      'amount': (double.parse(widget.amount) * 100).toInt(),
      'name': 'CivicSphere',
      'description': '💼 Payment for Job ID: ${widget.jobId}',
      'prefill': {
        'contact': '1234567891',
        'email': widget.email,
      },
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void handleCashOnDelivery() {
    print("🚚 COD selected for Job ID: ${widget.jobId}");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return 
     Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7B375D), Color(0xFF4D194D), Color(0xFF220440)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Select payment method',
              style: TextStyle(
                  color: AppColors.navbarcolorbg, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
        ),
      ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            GestureDetector(
              onTap: openCheckout,
              child: Card(
                color: AppColors.navbarcolorbg,
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Row(
                    children: [
                      SizedBox(width: 12),
                      Text(
                        '💳 Pay Online (₹${widget.amount})',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: handleCashOnDelivery,
              child: Card(
                color: AppColors.navbarcolorbg,
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Row(
                    children: [
                      SizedBox(width: 12),
                      Text(
                        '💶 Cash',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      
    );
  }
}
