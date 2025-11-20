import 'package:civicsphere/InAppPagesCustomer/IndividualChat.dart';
import 'package:civicsphere/constants/api.dart';
import 'package:civicsphere/constants/colors.dart';
import 'package:civicsphere/constants/location.dart';
import 'package:civicsphere/models/job_displaymodel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Api api = Api();
  final Dio dio = Dio();
  bool isLoading = true;
  String errorMessage = '';
  List<Map<String, dynamic>> trendingData = [];

  Position? _currentPosition;
  String _currentAddress = 'Fetching location...';

  final List<Map<String, dynamic>> hireAgainData = [
    {
      'name': 'John Doe',
      'role': 'Plumber',
      'rating': 4,
      'image': 'assets/image 5.png',
    },
    {
      'name': 'Jane Smith',
      'role': 'Electrician',
      'rating': 5,
      'image': 'assets/image 5.png',
    },
    {
      'name': 'Mike Johnson',
      'role': 'Carpenter',
      'rating': 3,
      'image': 'assets/image 5.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchTrendingWorkers();
    fetchLocation();
  }

  Future<void> fetchLocation() async {
    try {
      Position position = await LocationService.getCurrentLocation();
      String address = await LocationService.getAddressFromPosition(position);

      if (!mounted) return;

      setState(() {
        _currentPosition = position;
        _currentAddress = address;
      });

      print("User location: ${position.latitude}, ${position.longitude}");
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _currentAddress = "Error fetching location";
      });

      print("Error fetching location: $e");
    }
  }

  Future<void> fetchTrendingWorkers() async {
    final token = await api.getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response =
          await dio.get(Api.userearnings, options: Options(headers: headers));
      print('Status Code: ${response.statusCode}');
      print('Response Type: ${response.data.runtimeType}');

      if (response.statusCode == 200 && response.data is List) {
        final List<dynamic> data = response.data;

        setState(() {
          trendingData = data.map((item) {
            final worker = Worker.fromJson(item);
            return {
              'user': worker.user?.name,
              'role1': worker.user?.role,
              'id': worker.id,
              'earnings': double.tryParse(worker.earnings.toString()) ?? 0.00,
              'image': 'assets/image 5.png',
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Error fetching workers: ${e.toString()}';
        isLoading = false;
      });
      print('Error fetching workers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navbarcolorbg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
              child: Row(
                children: [
                  SizedBox(
                    height: 40,
                    child: Image.asset('assets/teamwork-1.png', scale: 0.8),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentAddress,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.midviolet,
                          fontSize: 14,
                        ),
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
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Trending In Your Area",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.darkviolet,
                ),
              ),
            ),
            SizedBox(height: 10),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                    ? Center(child: Text(errorMessage))
                    : trendingData.isEmpty
                        ? Center(child: Text('No trending workers available'))
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(10),
                            itemCount: trendingData.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 3 / 2,
                            ),
                            itemBuilder: (context, index) {
                              final item = trendingData[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.person, size: 18),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            item['user']?.toString() ??
                                                'Unknown',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      "Role: ${item['role1']?.toString() ?? 'N/A'}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "ID: ${item['id']?.toString() ?? 'N/A'}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700]),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 5),
                                          // margin: EdgeInsets.symmetric(
                                          //     vertical: 8, horizontal: 12),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(16),
                                              topRight: Radius.circular(16),
                                              bottomRight: Radius.circular(16),
                                              bottomLeft: Radius.circular(16)
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 35),
                                            child: Text(
                                            
                                              'Start a chat!',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black87),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(context ,MaterialPageRoute(builder: (builder) =>IndividualChat(chatid: item['id'].toString(), name: item['user']) )
                                            );
                                          },
                                          icon: Icon(Icons.chat),
                                          color: AppColors.darkviolet,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          )
          ],
        ),
      ),
    );
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
}
