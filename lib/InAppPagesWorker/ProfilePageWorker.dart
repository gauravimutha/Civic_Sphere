import 'package:civicsphere/Login/login.dart';
import 'package:civicsphere/constants/api.dart';
import 'package:civicsphere/constants/colors.dart';
import 'package:civicsphere/models/profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePageWorker extends StatefulWidget {
  const ProfilePageWorker({super.key});

  @override
  State<ProfilePageWorker> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageWorker> {
  final Api api = Api();
  final Dio dio = Dio();
  UserProfile? userProfile;
  bool isLoading = true;
  String profession = '';



  @override
  void initState() {
    super.initState();
      SharedPreferences.getInstance().then((prefs) {
    setState(() {
      profession = prefs.getString('skill') ?? '';
    });
  });
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
  Map<String, String> headers = {'Content-Type': 'application/json'};
  final token = await api.getToken();
  headers['Authorization'] = 'Bearer $token';

  try {
    Response? response = await dio.get(Api.profile, options: Options(headers: headers));

    if (response.statusCode == 200) {
      UserProfile profile = UserProfile.fromJson(response.data);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (profile.id != null) {
        await prefs.setInt('worker_id', profile.id!);
      }

      setState(() {
        userProfile = profile;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      print("Failed to load profile: ${response.statusCode}");
    }
  } catch (e) {
    setState(() => isLoading = false);
    print("Error loading profile: $e");
  }
}


  void _handleLogout() async {
    print('User logged out');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ));
  }

  void _handleEdit() {
    print('Edit profile');
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : userProfile == null
            ? Center(
                child: Text("Failed to load profile",
                    style: TextStyle(fontSize: 16)))
            : Column(children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
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
                        SizedBox(height: 20),
                        Text(
                          userProfile!.name ?? "",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30),
                        Card(
                          elevation: 2,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                            userProfile!.email ?? '',
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                            userProfile!.id.toString() ?? '',
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                            userProfile!.role ?? '',
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Earnings",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            userProfile!.profile?.earnings ??
                                                '',
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Rating",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            userProfile!.profile?.averageRating
                                                    .toString() ??
                                                '',
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Profession",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                           profession ,
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
                                //const Divider(),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
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
                
              ]);
  }
}
