import 'package:civicsphere/constants/api.dart';
import 'package:civicsphere/constants/colors.dart';
import 'package:civicsphere/models/review_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final Api api = Api();
  List<Review> reviews = [];
  bool isLoading = true;

  int _selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCustomerReviews();
  }

  Future<void> fetchCustomerReviews() async {
    try {
      final Response? response = await api.getData(Api.customerReviews);
      if (response != null && response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final fetchedReviews =
            data.map((json) => Review.fromJson(json)).toList();
        setState(() {
          reviews = fetchedReviews;
          isLoading = false;
          
        });
      } else {
        print("Error: ${response?.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Failed to fetch reviews: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> submitReview() async {
    if (_selectedRating == 0 || _commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please give a rating and comment")),
      );
      return;
    }

    final Map<String, dynamic> reviewData = {
      "ratings": _selectedRating,
      "comments": _commentController.text.trim(),
      "worker": 2, 
      "customer": 4, 
    };

    final response =
        await api.postData(Api.customerReviews, reviewData);
    if (response != null && response.statusCode == 201) {
      _commentController.clear();
      _selectedRating = 0;
      fetchCustomerReviews(); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Review submitted")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit review")),
      );
    }
  }

  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () {
            setState(() {
              _selectedRating = index + 1;
            });
          },
          icon: Icon(
            index < _selectedRating ? Icons.star : Icons.star_border,
            color: Colors.orange,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Reviews',
              style: TextStyle(
                  color: AppColors.navbarcolorbg, fontWeight: FontWeight.bold),
            ),
            centerTitle: false,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  _buildRatingStars(),
                  TextField(
                    controller: _commentController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      hintText: "Write your comment here...",
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.midviolet),
                    onPressed: submitReview,
                    child: const Text(
                      "Submit Review",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const Divider(height: 30),
                  const Text(
                    "Past Reviews",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.midviolet),
                  ),
                  const SizedBox(height: 10),
                  ...reviews.map((review) => ListTile(
                        leading: const Icon(Icons.star, color: Colors.orange),
                        title: Text("Rating: ${review.ratings}"),
                        subtitle: Text(review.comments),
                      )),
                ],
              ),
            ),
    );
  }
}
