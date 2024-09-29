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
  late Animation<double> animation;
  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    controller.forward();
    controller.repeat(reverse: true);
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
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
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: SweepGradient(
            colors: [
              Color(0xFF3D3191),
              Colors.white,
              Color(0xFF254BC0),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: animation,
                child:const Icon(
                  Icons.note_alt_rounded,
                  size: 100,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Note App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'version 1.0.1',
                style: TextStyle(fontSize: 13, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
