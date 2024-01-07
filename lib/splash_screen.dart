import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import the login screen file

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a delay before navigating to the login screen
    Timer(
      Duration(seconds: 4), // Adjust the duration as needed
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Add your logo here (replace 'assets/logo1.png' with your actual asset path)
            Image.asset(
              'logo1.png',
              width: 100.0, // Adjust the width as needed
              height: 100.0, // Adjust the height as needed
            ),
            SizedBox(height: 20.0),
            Text(
              'My Note',
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }
}