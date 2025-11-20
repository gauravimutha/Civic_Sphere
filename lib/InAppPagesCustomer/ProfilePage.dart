import 'package:civicsphere/Login/login.dart';
import 'package:civicsphere/constants/api.dart';
import 'package:civicsphere/constants/colors.dart';
import 'package:civicsphere/models/profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Api api = Api();
  final Dio dio = Dio();
  int? id;
  String? name;
  String? email;
  String? role;
  UserProfile? userProfile;

  late Future<void> profileFuture;

  @override
  void initState() {
    super.initState();
    profileFuture = loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    final token = await api.getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      final response =
          await dio.get(Api.profile, options: Options(headers: headers));

      if (response.statusCode == 200) {
        final userData = response.data;
        setState(() {
          id = userData["id"];
          email = userData["email"];
          name = userData["name"];
          role = userData["role"];
        });
      } else {
        print("Failed to load profile: ${response.statusCode}");
      }
    } catch (e) {
      print("Error loading profile: $e");
    }
  }

  void _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void _handleEdit() {
    print('Edit profile');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (name == null || email == null) {
          return const Center(
              child: Text("Failed to load profile",
                  style: TextStyle(fontSize: 16)));
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      child: Icon(
                        Icons.account_circle,
                        size: 80,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      name ?? "",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Card(
                      elevation: 2,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Email",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Text(
                email ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
                            const Divider(),
                            Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "ID",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Text(
                id.toString() ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
                            const Divider(),
                             Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Name",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Text(
                name ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
                            const Divider(),
                            Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Role",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Text(
                role ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: ElevatedButton(
                                  onPressed: _handleEdit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.midviolet,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 12),
                                  ),
                                  child: Text(
                                    "Edit",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              SizedBox(
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: ElevatedButton(
                                  onPressed: _handleLogout,
                                  style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.red,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        padding: EdgeInsets.symmetric(vertical: 15),
                                  ),
                                  child: Text(
                                                        "Logout",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
            ),
            
          ],
        );
      },
    );
  }

  Widget buildProfileRow(String label, String? value,
      {bool isEditable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Text(
                value ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
