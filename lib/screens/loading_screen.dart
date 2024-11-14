import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  static const routeName = '/loading';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Simulate a delay for app initialization
    Timer(Duration(seconds: 1), () {
      // Navigate to the main screen after 3 seconds
      Navigator.pushReplacementNamed(context, '/index');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color
      body: Center(
        child: CircularProgressIndicator(), // Loading spinner
      ),
    );
  }
}
