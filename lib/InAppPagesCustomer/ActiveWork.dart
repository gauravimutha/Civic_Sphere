import 'package:civicsphere/InAppPagesCustomer/PaymentPage.dart';
import 'package:civicsphere/InAppPagesCustomer/myjobdescription.dart';
import 'package:civicsphere/constants/api.dart';
import 'package:civicsphere/constants/colors.dart';
import 'package:civicsphere/constants/location.dart';
import 'package:civicsphere/models/job_displaymodel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Activework extends StatefulWidget {
  const Activework({super.key});

  @override
  State<Activework> createState() => _ActiveworkState();
}

class _ActiveworkState extends State<Activework> {
  bool isLoading = true;
  String errorMessage = '';
  List<Map<String, dynamic>> jobs = [];
  List<Map<String, dynamic>> donejobs = [];
  final Api api = Api();
  final Dio dio = Dio();
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    fetchJobs();
    fetchCompleteJobs();
  }

  Future<String> fetchAddress(double latitude, double longitude) async {
    try {
      String address = await LocationService.getAddressFromPosition(
        Position(
          latitude: latitude,
          longitude: longitude,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        ),
      );

      print("Resolved address: $address");
      return address;
    } catch (e) {
      print("Error resolving address: $e");
      return "Error fetching address";
    }
  }

  Future<void> fetchCompleteJobs() async {
    final token = await api.getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      final response =
          await dio.get(Api.jobs, options: Options(headers: headers));

      if (response.statusCode == 200 && response.data is List) {
        final List<Job> fetchedJobs = (response.data as List)
            .map((jobJson) => Job.fromJson(jobJson))
            .toList();

        for (var job in fetchedJobs) {
          print('Job ID: ${job.jobId}, Status: ${job.status}');
        }

        final List<Job> completedJobs = fetchedJobs
            .where((job) => job.status?.toLowerCase() == 'completed')
            .toList();

        setState(() {
          donejobs = completedJobs
              .map((job) => {
                    'job_id': job.jobId.toString(),
                    'title': job.title ?? 'No Title',
                    'category': job.category ?? 'No Category',
                    'amount': job.amount ?? '0.0',
                    'status': job.status ?? 'No Status',
                    'longitude': job.jobLongitude ?? '',
                    'latitude': job.jobLatitude ?? '',
                    'time_preference': job.timePreference ?? 'No Time',
                    'description': job.description ?? 'No Description',
                  })
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Error fetching jobs: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> fetchJobs() async {
    final token = await api.getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      final response =
          await dio.get(Api.jobs, options: Options(headers: headers));

      if (response.statusCode == 200 && response.data is List) {
        final List<Job> fetchedJobs = (response.data as List)
            .map((jobJson) => Job.fromJson(jobJson))
            .toList();

        final List<Job> completedJobs = fetchedJobs
            .where((job) =>
                ['open', 'ongoing'].contains(job.status?.toLowerCase().trim()))
            .toList();

        setState(() {
          jobs = completedJobs
              .map((job) => {
                    'job_id': job.jobId.toString(),
                    'title': job.title ?? 'No Title',
                    'category': job.category ?? 'No Category',
                    'amount': job.amount ?? '0.0',
                    'status': job.status ?? 'No Status',
                    'longitude': job.jobLongitude ?? '',
                    'latitude': job.jobLatitude ?? '',
                    'time_preference': job.timePreference ?? 'No Time',
                    'description': job.description ?? 'No Description',
                  })
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Error fetching jobs: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> _deleteJob(String jobId) async {
    if (!mounted) return;

    final token = await api.getToken();
    if (token == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication required')),
      );
      return;
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await dio.delete(
        Api.deleteJob(int.tryParse(jobId) ?? 0),
        options: Options(headers: headers),
      );

      print('Delete Response: ${response.data}');
      print('Delete Status Code: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job deleted successfully')),
        );
        await fetchJobs();
        await fetchCompleteJobs();
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete job: ${response.data}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting job: ${e.toString()}')),
      );
    }
  }

  Future<void> _submitUpdate(Map<String, dynamic> updatedJob) async {
    final token = await api.getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await dio.put(
        Api.updateJob(int.tryParse(updatedJob['job_id']) ?? 0),
        data: updatedJob,
        options: Options(headers: headers),
      );
      print('Update Response Status Code: ${response.statusCode}');
      print('Update Response Body: ${response.data}');
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job updated successfully')),
        );
        await fetchJobs();
        await fetchCompleteJobs();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update job: ${response.data}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating job: ${e.toString()}')),
      );
    }
  }

  Future<void> _completeUpdate(Map<String, dynamic> updatedJob) async {
    final token = await api.getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      final updateData = {
        'title': updatedJob['title'],
        'amount': updatedJob['amount'],
        'category': updatedJob['category'],
        'description': updatedJob['description'],
        'status': updatedJob['status'],
      };
      final response = await dio.put(
        Api.updateJob(int.tryParse(updatedJob['job_id']) ?? 0),
        data: updateData,
        options: Options(headers: headers),
      );
      print('Update Response Status Code: ${response.statusCode}');
      print('Update Response Body: ${response.data}');
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job Completed successfully')),
        );
        await fetchJobs();
        await fetchCompleteJobs();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to update status: ${response.data}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating status: ${e.toString()}')),
      );
    }
  }

  void _openUpdateDialog(Map<String, dynamic> jobData) {
    final TextEditingController titleController =
        TextEditingController(text: jobData['title']);
    final TextEditingController amountController =
        TextEditingController(text: jobData['amount'].toString());
    final TextEditingController categoryController =
        TextEditingController(text: jobData['category']);
    final TextEditingController descriptionController =
        TextEditingController(text: jobData['description']);
    // final TextEditingController timePrefController = TextEditingController(text: jobData['time_preference']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        title: const Text("Update Job",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: titleController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Amount",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: categoryController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: descriptionController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "description",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.midviolet,
            ),
            onPressed: () async {
              final updatedJob = {
                'job_id': jobData['job_id'],
                'title': titleController.text,
                'amount': double.tryParse(amountController.text) ?? 0.0,
                'amounts': amountController.text,
                'category': categoryController.text,
                'description': descriptionController.text,
              };
              await _submitUpdate(updatedJob);
              Navigator.pop(context);
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.green;
      case 'ongoing':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Active Jobs',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                      ? Center(child: Text(errorMessage))
                      : jobs.isEmpty
                          ? Center(child: Text('No active jobs available'))
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: jobs.length,
                              itemBuilder: (context, index) {
                                final job = jobs[index];

                                return GestureDetector(
                                  onTap: () {
                                    print("Job ID: ${job['job_id']}");
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyJobDescription(
                                            jobId: job['job_id']),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Center(
                                                  child: Text(
                                                    job['title'],
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              PopupMenuButton<String>(
                                                color: Colors.white,
                                                icon: Icon(Icons.more_vert),
                                                onSelected: (value) async {
                                                  if (value == 'update') {
                                                    _openUpdateDialog(job);
                                                  } else if (value ==
                                                      'delete') {
                                                    final jobId = job['job_id']
                                                        ?.toString();
                                                    if (jobId != null &&
                                                        jobId.isNotEmpty) {
                                                      await _deleteJob(jobId);
                                                    } else {
                                                      if (!mounted) return;
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'Invalid Job ID')),
                                                      );
                                                    }
                                                  }
                                                },
                                                itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                    value: 'update',
                                                    child: Text('Update'),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 'delete',
                                                    child: Text('Delete'),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        _getStatusColor(
                                                            job['status']),
                                                    radius: 6,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    job['status'],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.location_on,
                                                    size: 16,
                                                    color: Colors.red,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  FutureBuilder<String>(
                                                    future: fetchAddress(
                                                        job['latitude'],
                                                        job['longitude']),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const Text(
                                                          "Fetching address...",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        );
                                                      } else if (snapshot
                                                          .hasError) {
                                                        return const Text(
                                                          "Error fetching address",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        );
                                                      } else {
                                                        return Text(
                                                          snapshot.data ??
                                                              "No address",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        );
                                                      }
                                                    },
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.access_time,
                                                    size: 16,
                                                    color: Colors.black54,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(job['time_preference']),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.currency_rupee,
                                                    size: 16,
                                                    color: Colors.green,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${job['amount']}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(children: [
                                                const Icon(
                                                  Icons.category,
                                                  size: 16,
                                                  color: Colors.blue,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  job['category'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ]),
                                              Center(
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                              PaymentPage(amount: job['amount'], email: 'test@gmail.com', jobId: job['job_id'])
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 4,
                                                        horizontal: 8),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xFF7B375D),
                                                          Color(0xFF4D194D),
                                                          Color(0xFF220440)
                                                        ],
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black26,
                                                          blurRadius: 6,
                                                          offset: Offset(0, 3),
                                                        ),
                                                      ],
                                                    ),
                                                    child: const Text(
                                                      "Make an Offer",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Switch(
                                                value: job['status']
                                                        .toLowerCase() ==
                                                    'completed',
                                                onChanged: (bool value) async {
                                                  final newStatus = value
                                                      ? 'completed'
                                                      : 'ongoing';
                                                  final updatedJob = {
                                                    'job_id': job['job_id'],
                                                    'title': job['title'],
                                                    'amount': job['amount'],
                                                    'category': job['category'],
                                                    'description':
                                                        job['description'] ??
                                                            '',
                                                    'location': job['location'],
                                                    'time_preference':
                                                        job['time_preference'],
                                                    'status': newStatus,
                                                  };

                                                  await _completeUpdate(
                                                      updatedJob);
                                                  await fetchJobs();
                                                  await fetchCompleteJobs();
                                                },
                                                activeThumbColor: Colors.green,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
              SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  'Previous Jobs',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                      ? Center(child: Text(errorMessage))
                      : donejobs.isEmpty
                          ? Center(child: Text('No previous jobs yet'))
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: donejobs.length,
                              itemBuilder: (context, index) {
                                final job = donejobs[index];

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 12),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  job['title'],
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                      _getStatusColor(
                                                          job['status']),
                                                  radius: 6,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  job['status'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  size: 16,
                                                  color: Colors.red,
                                                ),
                                                const SizedBox(width: 4),
                                                FutureBuilder<String>(
                                                  future: fetchAddress(
                                                      job['latitude'],
                                                      job['longitude']),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Text(
                                                        "Fetching address...",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      );
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return const Text(
                                                        "Error fetching address",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      );
                                                    } else {
                                                      return Text(
                                                        snapshot.data ??
                                                            "No address",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      );
                                                    }
                                                  },
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.currency_rupee,
                                                  size: 16,
                                                  color: Colors.green,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${job['amount']}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(children: [
                                                  const Icon(
                                                    Icons.category,
                                                    size: 16,
                                                    color: Colors.blue,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    job['category'],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ]),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
            ],
          ),
        ),
      ),
    );
  }
}
