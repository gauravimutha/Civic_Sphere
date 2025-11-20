import 'package:civicsphere/SignUp/signup.dart';
import 'package:civicsphere/constants/colors.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
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
                    'Welcome!',
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
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (builder) => SignUpPage()),
                      );
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.darkyellow,
                      ),
                      child: Center(
                        child: Text(
                          'Get Started',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    );
  }
}
