import 'dart:async';

import 'package:flutter/material.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 2),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext) => HomeScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Container(
          width: 400,
          height: 500,
          child: Column(
            children: [
              Center(
                child: Image.asset('assets/image/applogo2.png'),
              ),
              Text(
                "College Predict",
                style: TextStyle(fontSize: 27, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Predict Your College \nBased on Percentege & Category.",
                style: TextStyle(
                    fontSize: 15, color: Color.fromARGB(255, 73, 73, 73)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )),
      ),
    );
  }
}
