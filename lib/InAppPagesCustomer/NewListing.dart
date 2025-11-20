import 'package:civicsphere/constants/api.dart';
import 'package:civicsphere/constants/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Newlisting extends StatefulWidget {
  const Newlisting({super.key});

  @override
  State<Newlisting> createState() => _NewlistingState();
}

class _NewlistingState extends State<Newlisting> {
  final Api api = Api();
  String selectedTimePreference = "Now"; // Default time preference
  TimeOfDay? selectedTime;
  String? selectedCategory;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  final List<String> categories = [
    "Plumbing",
    "Electrical",
    "Carpentry",
    "Cleaning",
    "Other"
  ];

  Future<void> _postJob() async {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedCategory == null ||
        amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields.")),
      );
      return;
    }

    String timePreference = selectedTimePreference;
    if (selectedTimePreference == "Later" && selectedTime != null) {
      timePreference = selectedTime!.format(context);
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    double latitude = prefs.getDouble('latitude') ?? 0;
    double longitude = prefs.getDouble('longitude') ?? 0;
    Map<String, dynamic> jobData = {
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'category': selectedCategory,
      'amount': double.tryParse(amountController.text.trim()) ?? 0.0,
      'status': "open",
      'time_preference': timePreference,
      'job_latitude': latitude.toStringAsFixed(6),
      'job_longitude': longitude.toStringAsFixed(6),
    
    };
    print('Latitude type: ${latitude.runtimeType}');
    print('Longitude type: ${longitude.runtimeType}');
    print('Amount type: ${jobData['amount'].runtimeType}');

    print("Job Data: $jobData");

    try {
      Response? response = await api.postData(Api.newlisting, jobData);

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Job posted successfully!")),
        );

        titleController.clear();
        descriptionController.clear();
        amountController.clear();
        setState(() {
          selectedCategory = null;
          selectedTimePreference = "Now";
          selectedTime = null;
        });

        Navigator.pop(context);
      } else {
        if (response?.statusCode == 400) {
          print("Bad Request: ${response?.data}");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Invalid data. Please check your input.")),
          );
        } else if (response?.statusCode == 401) {
          print("Unauthorized: ${response?.data}");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("You are not authorized. Please log in.")),
          );
        } else {
          print("Job post failed: ${response?.data}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    "Failed to post job. Status code: ${response?.statusCode}")),
          );
        }
      }
    } catch (e) {
      print("An error occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navbarcolorbg,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Need Help?',
                      style: TextStyle(
                        color: AppColors.darkviolet,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close,
                          size: 25, color: AppColors.secondaryColor),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'What do you need help with?',
                style: TextStyle(
                  color: AppColors.darkviolet,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Fix my sink',
                  filled: true,
                  fillColor: Colors.grey[200],
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        BorderSide(color: AppColors.darkviolet, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Category',
                style: TextStyle(
                  color: AppColors.darkviolet,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Time Preference',
                style: TextStyle(
                  color: AppColors.darkviolet,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                initialValue: selectedTimePreference,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                items: ["Now", "Later"].map((String preference) {
                  return DropdownMenuItem<String>(
                    value: preference,
                    child: Text(preference),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedTimePreference = newValue!;
                    if (newValue == "Now") {
                      selectedTime = null;
                    }
                  });
                },
              ),
              if (selectedTimePreference == "Later") ...[
                const SizedBox(height: 10),
                InkWell(
                  onTap: () => _selectTime(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Text(
                      selectedTime == null
                          ? "Select Time"
                          : selectedTime!.format(context),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              const Text(
                'Description',
                style: TextStyle(
                  color: AppColors.darkviolet,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: descriptionController,
                maxLines: 7,
                decoration: InputDecoration(
                  hintText:
                      'My sink is leaking under the cabinet, need help ASAP',
                  filled: true,
                  fillColor: Colors.grey[200],
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        BorderSide(color: AppColors.darkviolet, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Amount',
                style: TextStyle(
                  color: AppColors.darkviolet,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter the amount (e.g., 6900)',
                  filled: true,
                  fillColor: Colors.grey[200],
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        BorderSide(color: AppColors.darkviolet, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: InkWell(
                  onTap: _postJob,
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColors.midviolet,
                    ),
                    child: Center(
                      child: Text(
                        'Post',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.navbarcolorbg,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
