import 'package:civicsphere/constants/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:civicsphere/constants/colors.dart';

class OfferPage extends StatefulWidget {
  final int jobId;

  const OfferPage({super.key, required this.jobId});

  @override
  State<OfferPage> createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;
  String? _bearerToken;

  @override
  void initState() {
    super.initState();
    _initializeToken();
  }

  Future<void> _initializeToken() async {
    final api = Api();
    _bearerToken = await api.getToken();
    if (_bearerToken == null) {
      print("Authorization token not found.");
    }
  }

  Future<void> sendOffer() async {
    final amount = _amountController.text.trim();
    final comment = _commentController.text.trim();

    // Validate input
    if (amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter an amount")),
      );
      return;
    }

    if (_bearerToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Authorization token not found")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final dio = Dio();
    final url = Api.offer(widget.jobId);

    try {
      final response = await dio.post(
        url,
        data: {
          'proposed_amount': amount,
          'message': comment,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_bearerToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        final responseData = response.data;
        print("Offer created successfully: $responseData");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Offer sent successfully!")),
        );
        Navigator.pop(context);
      } else {
        print("Failed with status: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed with status: ${response.statusCode}")),
        );
      }
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.response?.data ?? e.message}")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Make an Offer", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.midviolet,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Propose New Amount",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter your amount (₹)",
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Add a Comment",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Say something to the customer...",
              ),
            ),
            const Spacer(),
            SizedBox(
              width: screenWidth,
              child: ElevatedButton(
                onPressed: _isLoading ? null : sendOffer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.midviolet,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Send Offer",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}