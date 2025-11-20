import 'package:civicsphere/constants/api.dart';
import 'package:civicsphere/constants/colors.dart';
import 'package:civicsphere/models/offermodel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> acceptedOffers = [];

class MyJobDescription extends StatefulWidget {
  final String jobId;
  const MyJobDescription({super.key, required this.jobId});

  @override
  State<MyJobDescription> createState() => _MyJobDescriptionState();
}

class _MyJobDescriptionState extends State<MyJobDescription> {
  List<OfferModel> offers = [];
  bool isLoading = true;
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchOffers();
  }

  Future<void> fetchOffers() async {
    try {
      final token = await Api().getToken();

      if (token == null) {
        print("No token found");
        setState(() => isLoading = false);
        return;
      }
      int id = int.parse(widget.jobId);
      final response = await dio.get(
        //Api.acceptoffer(id)
        "${Api.basicurl}jobs/${widget.jobId}/offers/"
       ,
        options: Options(headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        setState(() {
          offers = data.map((e) => OfferModel.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        print("Failed to fetch offers: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching offers: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> accept() async {
    try {
      final token = await Api().getToken();

      if (token == null) {
        print("No token found");
        setState(() => isLoading = false);
        return;
      }
      int id = int.parse(widget.jobId);
      final response = await dio.get(
        Api.acceptoffer(id)
        //Api.basicurl + "jobs/${widget.jobId}/offers/"
       ,
        options: Options(headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        setState(() {
          offers = data.map((e) => OfferModel.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        print("Failed to fetch offers: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching offers: $e");
      setState(() => isLoading = false);
    }
  }

  void rejectOffer(int offerId) {
    print("Rejected offer ID: $offerId");
    // TODO: Optionally implement rejection logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("C I V I C S P H E R E"),
        centerTitle: true,
        backgroundColor: AppColors.navbarcolorbg,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : offers.isEmpty
              ? const Center(child: Text("No offers found"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: offers.length,
                  itemBuilder: (context, index) {
                    final offer = offers[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              offer.workerName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              offer.jobTitle,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '₹${offer.proposedAmount}',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(offer.message),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () => accept(
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  child: const Text("Accept"),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () => rejectOffer(offer.id),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text("Reject"),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
