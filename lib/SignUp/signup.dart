import 'dart:convert';

import 'package:civicsphere/InAppPagesCustomer/NavAndAppBar.dart';
import 'package:civicsphere/InAppPagesWorker/NavApp_Worker.dart';
import 'package:civicsphere/Login/login.dart';
import 'package:civicsphere/constants/api.dart';
import 'package:civicsphere/constants/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? selectedCategory;
  final List<String> categories = [
    "Plumbing",
    "Electrical",
    "Carpentry",
    "Cleaning",
    "Other"
  ];
  bool _obscureText1 = true;
  String _selectedRole = "customer";
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _conformpasswordcontroller = TextEditingController();

  final api = Api();
  final Dio dio = Dio();

  void signUpUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('skill', selectedCategory ?? '');
    //print('signup starte');
    Map<String, String> headers = {'Content-Type': 'application/json'};

    Response response = await dio.post(Api.register,
        data: jsonEncode(
          {
            "name": _namecontroller.text.trim(),
            "email": _emailcontroller.text.trim(),
            "password": _passwordcontroller.text.trim(),
            "confirm_password": _conformpasswordcontroller.text.trim(),
            "role": _selectedRole,
          },
        ),
        options: Options(headers: headers));

    if ((response.statusCode == 200 || response.statusCode == 201)) {
      final response = await dio.post(Api.login,
          data: jsonEncode(
            {
              "email": _emailcontroller.text,
              "password": _passwordcontroller.text,
            },
          ),
          options: Options(headers: headers));

      if (response.statusCode == 200) {
        final data = response.data;
        String jwtToken = data["access"];
        await api.storeToken(jwtToken);
        print("Login Successful. Token Stored: $jwtToken");
        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('role', _selectedRole);

        if (_selectedRole == "worker") {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const NavappWorker()));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Navandappbar()));
        }
      } else {
        print("Login Failed: ${response.data}");
      }
    } else {
      print("Signup Failed: ${response.data}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Image.asset('assets/ChatGPT Image Apr 19, 2025, 03_32_27 PM.png',
                  height: 300, width: 380),
              Text(
                  textAlign: TextAlign.center,
                  'SignUp',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkviolet)),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(
                      color: AppColors.darkviolet, fontWeight: FontWeight.bold),
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
                controller: _emailcontroller,
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(
                      color: AppColors.darkviolet, fontWeight: FontWeight.bold),
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
                controller: _namecontroller,
              ),
              const SizedBox(height: 20),
              TextField(
                obscureText: _obscureText1,
                decoration: InputDecoration(
                  labelText: "Create Password",
                  labelStyle: TextStyle(
                      color: AppColors.darkviolet, fontWeight: FontWeight.bold),
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
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscureText1 ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.secondaryColor),
                    onPressed: () {
                      setState(() {
                        _obscureText1 = !_obscureText1;
                      });
                    },
                  ),
                ),
                controller: _passwordcontroller,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: _obscureText1,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  labelStyle: TextStyle(
                      color: AppColors.darkviolet, fontWeight: FontWeight.bold),
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
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscureText1 ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.secondaryColor),
                    onPressed: () {
                      setState(() {
                        _obscureText1 = !_obscureText1;
                      });
                    },
                  ),
                ),
                controller: _conformpasswordcontroller,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    value: "customer",
                    groupValue: _selectedRole,
                    activeColor: AppColors.darkviolet,
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value.toString();
                      });
                    },
                  ),
                  const Text("Customer"),
                  const SizedBox(width: 20),
                  Radio(
                    value: "worker",
                    groupValue: _selectedRole,
                    activeColor: AppColors.darkviolet,
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value.toString();
                      });
                    },
                  ),
                  const Text("Worker"),
                ],
              ),
              if (_selectedRole == "worker")
                DropdownButtonFormField<String>(
                  initialValue: selectedCategory,
                  decoration: InputDecoration(
                    label: Text('Skilltype'),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(color: AppColors.darkviolet, width: 2),
                    ),
                    labelStyle: TextStyle(
                        color: AppColors.darkviolet,
                        fontWeight: FontWeight.bold),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.midviolet,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  signUpUser();
                },
                child: const Text("Sign up"),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                child: const Text("Already have an account? Login",
                    style: TextStyle(
                        color: AppColors.darkviolet,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
