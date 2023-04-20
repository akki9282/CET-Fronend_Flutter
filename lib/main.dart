import 'package:college_predict/screen/splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:responsive_framework/responsive_framework.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //********************************************* */
      builder: (context, widget) => ResponsiveWrapper.builder(
        ClampingScrollWrapper.builder(context, widget!),
        breakpoints: const [
          ResponsiveBreakpoint.resize(350, name: MOBILE),
          ResponsiveBreakpoint.autoScale(600, name: TABLET),
          ResponsiveBreakpoint.resize(800, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(1700, name: 'XL'),
        ],
      ), //********************************************* */
      title: "College Predict",
      home: SplashScreen(),
    );
  }
}
