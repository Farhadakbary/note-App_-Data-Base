import 'package:flutter/material.dart';
import 'dart:async';
import 'package:noteapp2/screens/loginpage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    controller.forward();
    controller.repeat(reverse: true);
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
      //
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: SweepGradient(
            colors: [
              Color(0xFF3D3191),
              Colors.white,
              Color(0xFF254BC0),
            ],
          ),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: AnimatedIcon(
                icon: AnimatedIcons.search_ellipsis,
                progress: controller,
                size: 100,
                color: Colors.black,
              ),
            ),
            const Text(
              'version 1.0.1',
              style: TextStyle(fontSize: 13),
            )
          ],
        ),
      ),
    );
  }
}
