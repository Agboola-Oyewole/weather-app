import 'package:clima_weather/screens/home_screen.dart';
import 'package:flutter/material.dart';

import '../data/weather_data.dart';

class SearchCities extends StatefulWidget {
  const SearchCities({super.key});

  @override
  State<SearchCities> createState() => _SearchCitiesState();
}

class _SearchCitiesState extends State<SearchCities> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? weatherData;

  // List of all cities
  List<String> allCities = [
    'Abu Dhabi',
    'Amsterdam',
    'Ankara',
    'Athens',
    'Auckland',
    'Bangkok',
    'Barcelona',
    'Beijing',
    'Berlin',
    'Bogotá',
    'Buenos Aires',
    'Cairo',
    'Cape Town',
    'Chicago',
    'Copenhagen',
    'Dallas',
    'Delhi',
    'Dubai',
    'Dublin',
    'Edinburgh',
    'Florence',
    'Frankfurt',
    'Hanoi',
    'Helsinki',
    'Hong Kong',
    'Ikeja',
    'Istanbul',
    'Jakarta',
    'Kabul',
    'Kampala',
    'Karachi',
    'Kuala Lumpur',
    'Lagos',
    'Lima',
    'Lisbon',
    'London',
    'Los Angeles',
    'Madrid',
    'Manila',
    'Mexico City',
    'Miami',
    'Moscow',
    'Mumbai',
    'Nairobi',
    'New Delhi',
    'New York',
    'Oslo',
    'Paris',
    'Prague',
    'Rio de Janeiro',
    'Rome',
    'San Francisco',
    'Santiago',
    'São Paulo',
    'Seoul',
    'Singapore',
    'Stockholm',
    'Sydney',
    'Taipei',
    'Tallinn',
    'Tehran',
    'Tokyo',
    'Toronto',
    'Vienna',
    'Vilnius',
    'Washington, D.C.',
    'Wellington',
    'Zagreb',
  ];

  // Filtered list of cities
  List<String> filteredCities = [];

  @override
  void initState() {
    super.initState();
    filteredCities = allCities; // Show all cities initially
  }

  // Function to filter cities based on search input
  void filterCities(String query) {
    List<String> tempList = [];
    if (query.isNotEmpty) {
      tempList = allCities
          .where((city) => city.toLowerCase().startsWith(query.toLowerCase()))
          .toList();
    } else {
      tempList = allCities;
    }
    setState(() {
      filteredCities = tempList;
    });
  }

  void _getWeatherData(city) async {
    try {
      final data = await _weatherService.fetchWeatherData(city);
      setState(() {
        weatherData = data;
      });
      print(weatherData);
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => HomeScreen(weatherData: weatherData)),
      );
    } catch (e) {
      print('Error fetching weather: $e');
      // Optionally, you can show an error message or navigate to an error screen here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff181C14),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back, color: Colors.white)),
              SizedBox(
                height: 20,
              ),
              Text(
                'Search Cities',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: 25.0,
              ),
              TextField(
                cursorColor: Colors.black,
                cursorErrorColor: Colors.red,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                style: TextStyle(
                  fontSize: 17.5,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                onChanged: (value) {
                  filterCities(value); // Filter the city list as the user types
                },
              ),
              SizedBox(height: 40),
              // Text(
              //   'List of Cities',
              //   style: TextStyle(
              //       fontWeight: FontWeight.w900,
              //       fontSize: 20,
              //       color: Colors.white),
              // ),
              // SizedBox(height: 15), // Spacing between the search box and list
              Expanded(
                child: filteredCities.isNotEmpty
                    ? ListView.builder(
                        itemCount: filteredCities.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _getWeatherData(filteredCities[index]);
                            },
                            child: ListTile(
                              title: Text(
                                filteredCities[index],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'No cities found',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
