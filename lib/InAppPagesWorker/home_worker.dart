import 'dart:math';

import 'package:civicsphere/InAppPagesWorker/description.dart';
import 'package:civicsphere/constants/api.dart';
import 'package:civicsphere/constants/colors.dart';
import 'package:civicsphere/constants/location.dart';
import 'package:civicsphere/models/job_displaymodel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeWorker extends StatefulWidget {
  const HomeWorker({super.key});

  @override
  State<HomeWorker> createState() => _HomeWorkerState();
}

class _HomeWorkerState extends State<HomeWorker> {
  final Api api = Api();
  final Dio dio = Dio();
  List<Job> jobs = [];
  bool isLoading = true;
  String? currentAddress;

  @override
  void initState() {
    super.initState();
    fetchJobs();
    fetchUserLocation();
  }

  Future<void> fetchUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        if (!mounted) return;
        setState(() {
          currentAddress = "Permission Denied";
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      String address = await LocationService.getAddressFromPosition(position);

      if (!mounted) return;
      setState(() {
        currentAddress = address;
      });
    } catch (e) {
      print("Error fetching location: $e");
      if (!mounted) return;
      setState(() {
        currentAddress = "Location unavailable";
      });
    }
  }

  Future<String> fetchJobLoc(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      } else {
        return "Location not found";
      }
    } catch (e) {
      print("Error fetching job location: $e");
      return "Location unavailable";
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // haversine form is used here
    const double earthRadius = 6371;
    double dLat = Rad(lat2 - lat1);
    double dLon = Rad(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(Rad(lat1)) * cos(Rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double Rad(double deg) {
    return deg * (pi / 180);
  }

 Future<void> fetchJobs() async {
  try {
    final response = await dio.get(Api.workerjob);
    if (response.data != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      double userLat = prefs.getDouble('latitude') ?? 0.0;
      double userLong = prefs.getDouble('longitude') ?? 0.0;

      const double distradius = 10.0;

      List<Job> fetchedJobs =
          (response.data as List).map((e) => Job.fromJson(e)).where((job) {
        if (job.status?.toLowerCase() != 'open') return false;

        if (job.jobLatitude != null && job.jobLongitude != null) {
          double jobLat = job.jobLatitude!;
          double jobLong = job.jobLongitude!;
          double distance =
              calculateDistance(userLat, userLong, jobLat, jobLong);
          return distance <= distradius;
        }
        return false;
      }).toList();

      for (Job job in fetchedJobs) {
        job.locationString =
            await fetchJobLoc(job.jobLatitude!, job.jobLongitude!);
      }

      setState(() {
        jobs = fetchedJobs;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load jobs');
    }
  } catch (e) {
    setState(() {
      isLoading = false;
    });
    print('Error fetching jobs: $e');
  }
}


  static Widget _buildCarouselItem(BuildContext context, String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: FractionallySizedBox(
        widthFactor: 1.6,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: Image.asset(text),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navbarcolorbg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: fetchUserLocation,
                    child: SizedBox(
                      height: 40,
                      child: Image.asset('assets/teamwork-1.png', scale: 0.8),
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              currentAddress ?? 'Fetching location...',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkviolet,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            FlutterCarousel(
              options: FlutterCarouselOptions(
                height: 200,
                showIndicator: true,
                slideIndicator: CircularSlideIndicator(),
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                viewportFraction: 0.7,
              ),
              items: [
                _buildCarouselItem(context, 'assets/im1.png'),
                _buildCarouselItem(context, 'assets/im2.png'),
                _buildCarouselItem(context, 'assets/im3.png'),
                _buildCarouselItem(context, 'assets/im4.png'),
              ],
            ),
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Jobs Near You",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.darkviolet,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            isLoading
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 12,
                      children: List.generate(6, (index) {
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: MediaQuery.of(context).size.height * 0.16,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: Offset(2, 4),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(4, (_) {
                              return Container(
                                width: double.infinity,
                                height: 10,
                                margin: EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              );
                            }),
                          ),
                        );
                      }),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 12,
                      children: jobs.map((job) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DescriptionPage(job: job)),
                            );
                            print("Job ID: ${job.jobId}");
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.height * 0.16,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 2,
                                  blurRadius: 6,
                                  offset: Offset(2, 4),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.work,
                                        size: 18, color: AppColors.darkviolet),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        job.title ?? "Unknown Job",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: AppColors.darkviolet,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.access_time,
                                        size: 14, color: Colors.grey),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        job.timePreference ??
                                            "No Time Provided",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black87),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.location_on,
                                        size: 14, color: Colors.grey),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        job.locationString ?? "No Location",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black87),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.person,
                                        size: 14, color: Colors.grey),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        "Customer: ${job.customerName ?? "Unknown"}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black87),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.currency_rupee,
                                        size: 14, color: Colors.green),
                                    SizedBox(width: 5),
                                    Text(
                                      "Price: ${job.amount ?? "0.00"}",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black87),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
