import 'package:civicsphere/InAppPagesWorker/myjobdescription_worker.dart';
import 'package:civicsphere/constants/api.dart';
import 'package:civicsphere/models/job_displaymodel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActiveworkWorker extends StatefulWidget {
  const ActiveworkWorker({super.key});

  @override
  State<ActiveworkWorker> createState() => _ActiveworkState();
}

class _ActiveworkState extends State<ActiveworkWorker> {
  List<dynamic> jobList = [];
  bool isLoading = true;
  final Api api = Api();
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
  try {
    final response = await dio.get(Api.workerjob);
    if (response.data != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int currentWorkerId = prefs.getInt('worker_id') ?? -1;

      List<Job> fetchedJobs = (response.data as List)
          .map((e) => Job.fromJson(e))
          .where((job) => job.worker?.id == currentWorkerId)
          .toList();

      

      setState(() {
        jobList = fetchedJobs;
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


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Center(
              child: const Text(
                'My Jobs',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: jobList.length,
                      itemBuilder: (context, index) {
                        final job = jobList[index];
                        return Column(
                          children: [
                            jobCard(
                              title: job['title'] ?? 'No Title',
                              status: job['status'] ?? 'Unknown',
                              location: job['location'] ?? 'Unknown',
                              time: job['schedule_time'] ?? 'ASAP',
                              price: job['amount'] ?? '0.00',
                              color: job['status'] == 'open'
                                  ? Colors.green
                                  : Colors.yellow,
                              showOffers: false,
                              context: context,
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget jobCard({
    required String title,
    required String status,
    required String location,
    required String time,
    required String price,
    required Color color,
    required BuildContext context,
    bool showOffers = false,
    String offers = '',
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyJobDescriptionWorker(),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: color,
                      radius: 6,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      status,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.red,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          location,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 4),
                    Text(time),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      'Price:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Rs. $price',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (showOffers)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  offers,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
