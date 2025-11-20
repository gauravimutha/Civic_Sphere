import 'dart:convert';

import 'package:civicsphere/InAppPagesCustomer/NavAndAppBar.dart';
import 'package:civicsphere/InAppPagesWorker/NavApp_Worker.dart';
import 'package:civicsphere/SignUp/signup.dart';
import 'package:civicsphere/constants/api.dart';
import 'package:civicsphere/constants/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  final String _selectedRole = "worker";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final api = Api();
  final dio = Dio();

  Future<void> loginUser() async {
    Map<String, String> headers = {'Content-Type': 'application/json'};

    final response = await dio.post(Api.login,
        data: jsonEncode(
          {
            "email": _emailController.text,
            "password": _passwordController.text,
          },
        ),
        options: Options(headers: headers));

    if (response.statusCode == 200) {
      final data = response.data;
      String jwtToken = data["access"];
      String role = data["user_type"];
      await api.storeToken(jwtToken);
      print("Login Successful. Token Stored: $jwtToken");

      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('role', role);
      if (role == "worker") {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const NavappWorker()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Navandappbar()));
      }
    } else {
      print("Login Failed: ${response.data}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              Image.asset(
                'assets/login.png',
                height: 350,
                width: 400,
              ),
              const SizedBox(height: 20),
              Text('Login',
                  style: TextStyle(
                      fontSize: 30,
                      color: AppColors.darkviolet,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(
                    color: AppColors.secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: AppColors.darkviolet, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(
                    color: AppColors.darkviolet,
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: AppColors.secondaryColor, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.secondaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(color: AppColors.midviolet),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.midviolet,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: loginUser,
                child: const Text("Sign in"),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                },
                child: const Text(
                  "Click here to sign up",
                  style: TextStyle(
                    color: AppColors.darkviolet,
                    fontWeight: FontWeight.bold,
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
