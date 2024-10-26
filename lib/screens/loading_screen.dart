import 'dart:async';

import 'package:clima_weather/screens/home_screen.dart';
import 'package:flutter/material.dart';

import '../data/location_data.dart';
import '../data/notification_data.dart';
import '../data/weather_data.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? weatherData;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Duration of the animation
      vsync: this,
    );

    // Define the animation as a fade-in
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    // Start the animation
    _controller.forward();

    // Fetch the weather data after the animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _getWeatherData(); // Fetch weather data
      }
    });
  }

  Future<String> getLocation() async {
    Location location = Location();
    await location.determinePosition(context);
    String longLat = '${location.latitude},${location.longitude}';
    return longLat;
  }

  void _getWeatherData() async {
    try {
      // Get location first
      final coordinates = await getLocation();
      final data = await _weatherService.fetchWeatherData(coordinates);
      setState(() {
        weatherData = data;
      });

      // Request notification permissions only after fetching weather data
      await NotificationService.requestNotificationPermission();

      // Check if rain is expected
      bool isRainExpected = _checkRainForecast(weatherData!);
      if (isRainExpected) {
        // Schedule the daily check after initialization
        NotificationService.scheduleDailyWeatherCheck(
          title: 'Rain Alert',
          body: 'It\'s going to rain today! Remember to take an umbrella.',
        );
        print('Schedule created');
      }

      // Navigate to HomeScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(weatherData: weatherData),
        ),
      );
    } catch (e) {
      print('Error fetching weather: $e');
    }
  }

// Example function to check if rain is expected
  bool _checkRainForecast(Map<String, dynamic> weatherData) {
    // Logic to check if it will rain based on weatherData
    return weatherData['current']['condition']['text']
        .toLowerCase()
        .contains('rain');
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181C14),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        // Add padding to avoid edge clipping
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _animation,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/ic_notification.png'),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
            SizedBox(height: 13),
            Center(
              child: FadeTransition(
                opacity: _animation,
                child: const Text(
                  'Clima Weather', // App's name
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
