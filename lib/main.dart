import 'package:clima_weather/data/units_data.dart';
import 'package:clima_weather/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => UnitData(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter', // Set your custom font family here
      ),
      home: const LoadingScreen(),
    ),
  ));
}
