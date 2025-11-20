import 'package:civicsphere/InAppPagesCustomer/NavAndAppBar.dart';
import 'package:civicsphere/InAppPagesWorker/NavApp_Worker.dart';
import 'package:civicsphere/constants/colors.dart';
import 'package:civicsphere/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final role = prefs.getString('role');

    await Future.delayed(const Duration(seconds: 2));

    if (token == null || token.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Onboarding()),
      );
    } else {
      if (role == 'worker') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const NavappWorker()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Navandappbar()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/Opening (1).png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.1,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/opening_image.png'),
                  SizedBox(height: 70),
                  Text(
                    'C I V I C S P H E R E',
                    style: TextStyle(
                      fontSize: 40,
                      color: AppColors.navbarcolorbg,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Find the Right Help, Right Now.',
                    style: TextStyle(color: AppColors.navbarcolorbg),
                  ),
                  SizedBox(height: 40),
                  CircularProgressIndicator(
                    color: AppColors.navbarcolorbg,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
