import 'package:clima_weather/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Inter', // Set your custom font family here
    ),
    home: const HomeScreen(),
  ));
}
