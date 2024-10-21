import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/weather_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? weatherData;

  @override
  void initState() {
    super.initState();
    _getWeatherData();
  }

  IconData getWeatherIcon(double tempCelsius, String condition) {
    if (tempCelsius >= 30) {
      // Hot weather - sunny
      return Icons.wb_sunny;
    } else if (tempCelsius >= 20 && tempCelsius < 30) {
      // Warm weather - sunny with some clouds
      if (condition.contains('cloud')) {
        return Icons.wb_cloudy;
      } else {
        return Icons.wb_sunny;
      }
    } else if (tempCelsius >= 10 && tempCelsius < 20) {
      // Cool weather - partly cloudy or rainy
      if (condition.contains('rain')) {
        return Icons.cloudy_snowing; // Example for rain
      } else if (condition.contains('cloud')) {
        return Icons.cloud;
      } else {
        return Icons.wb_sunny; // Still sunny, but cooler
      }
    } else if (tempCelsius < 10) {
      // Cold weather - cloudy or rainy
      if (condition.contains('rain')) {
        return Icons.cloudy_snowing; // Example for rain
      } else {
        return Icons.cloud; // Cloudy
      }
    }

    // Default case (if no match)
    return Icons.help_outline; // Icon to show unknown condition
  }

  bool isWeatherClear(String condition) {
    // Convert the condition to lowercase for case-insensitive comparison
    String lowerCondition = condition.toLowerCase();

    // Check if the condition contains words indicating cloudy or rainy weather
    if (lowerCondition.contains('rain') ||
        lowerCondition.contains('cloud') ||
        lowerCondition.contains('storm')) {
      return false; // Cloudy or rainy weather
    } else {
      return true; // Clear weather
    }
  }

  String formatDate(String date) {
    // Parse the input string to a DateTime object
    DateTime parsedDate = DateTime.parse(date);

    // Format the date to desired output format
    String formattedDate = DateFormat('EEE d MMM').format(parsedDate);

    // Get the day suffix (st, nd, rd, th) based on the day
    String daySuffix = getDayOfMonthSuffix(parsedDate.day);

    // Combine the formatted date with the day suffix
    return '${DateFormat('EEE').format(parsedDate)} ${parsedDate.day}$daySuffix ${DateFormat('MMM').format(parsedDate)}';
  }

  String getDayOfMonthSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  void _getWeatherData() async {
    try {
      final data = await _weatherService.fetchWeatherData('London');
      setState(() {
        weatherData = data;
      });
      print(weatherData);
    } catch (e) {
      print('Error fetching weather: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(isWeatherClear(
                          weatherData!['current']['condition']['text'])
                      ? 'images/pexels-elia-clerici-282848-912110.jpg'
                      : 'images/pexels-pixabay-414659.jpg'),
                  // Add your image path here
                  fit: BoxFit.cover, // Makes the image cover the entire screen
                ),
              ),
            ),

            // Your main content
            Padding(
              padding: const EdgeInsets.only(
                  right: 20.0, left: 20.0, top: 20, bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      SizedBox(width: 20.0),
                      Icon(
                        Icons.settings_sharp,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 10.0),
                          Text(
                            weatherData?['location']['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 23,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            '${weatherData!['current']['temp_c'].toString()}°',
                            style: TextStyle(
                                fontSize: 90,
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            '${weatherData!['current']['condition']['text']}',
                            style: TextStyle(
                                fontSize: 23,
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 15.0),
                          Text(
                            'Last Updated: ${formatDate(weatherData!['current']['last_updated'].toString())} ${weatherData!['current']['last_updated'].toString().split(' ')[1]}',
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 40),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 30),
                            decoration: BoxDecoration(
                              color: Colors.black45.withOpacity(0.4),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6.0)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 10.0),
                                        Text(
                                          '5-Day Forecast',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 16.0),
                                        )
                                      ],
                                    ),
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       'More Details',
                                    //       style: TextStyle(
                                    //           color: Colors.white,
                                    //           fontWeight: FontWeight.w900,
                                    //           fontSize: 16.0),
                                    //     ),
                                    //     SizedBox(width: 5.0),
                                    //     Icon(
                                    //       Icons.arrow_drop_down,
                                    //       color: Colors.white,
                                    //     ),
                                    //   ],
                                    // )
                                  ],
                                ),
                                SizedBox(height: 30.0),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 0.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Today',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16.0),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            getWeatherIcon(
                                                weatherData!['current']
                                                    ['temp_c'],
                                                weatherData!['current']
                                                    ['condition']['text']),
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 70.0),
                                          Text(
                                            '${weatherData!['current']['temp_c'].toString()}°',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 16.0),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 0.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Tomorrow',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16.0),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            getWeatherIcon(
                                                weatherData!['forecast']
                                                        ['forecastday'][1]
                                                    ['day']['avgtemp_c'],
                                                weatherData!['forecast']
                                                            ['forecastday'][1]
                                                        ['day']['condition']
                                                    ['text']),
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 70.0),
                                          Text(
                                            '${weatherData!['forecast']['forecastday'][1]['day']['avgtemp_c'].toString()}°',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 16.0),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 0.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${formatDate(weatherData!['forecast']['forecastday'][2]['date'])}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16.0),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            getWeatherIcon(
                                                weatherData!['forecast']
                                                        ['forecastday'][2]
                                                    ['day']['avgtemp_c'],
                                                weatherData!['forecast']
                                                            ['forecastday'][2]
                                                        ['day']['condition']
                                                    ['text']),
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 70.0),
                                          Text(
                                            '${weatherData!['forecast']['forecastday'][2]['day']['avgtemp_c'].toString()}°',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 16.0),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 0.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${formatDate(weatherData!['forecast']['forecastday'][3]['date'])}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16.0),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            getWeatherIcon(
                                                weatherData!['forecast']
                                                        ['forecastday'][3]
                                                    ['day']['avgtemp_c'],
                                                weatherData!['forecast']
                                                            ['forecastday'][3]
                                                        ['day']['condition']
                                                    ['text']),
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 70.0),
                                          Text(
                                            '${weatherData!['forecast']['forecastday'][3]['day']['avgtemp_c'].toString()}°',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 16.0),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 0.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${formatDate(weatherData!['forecast']['forecastday'][4]['date'])}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16.0),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            getWeatherIcon(
                                                weatherData!['forecast']
                                                        ['forecastday'][4]
                                                    ['day']['avgtemp_c'],
                                                weatherData!['forecast']
                                                            ['forecastday'][4]
                                                        ['day']['condition']
                                                    ['text']),
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 70.0),
                                          Text(
                                            '${weatherData!['forecast']['forecastday'][4]['day']['avgtemp_c'].toString()}°',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 16.0),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            'MORE DETAILS',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 18),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0, vertical: 30),
                                  decoration: BoxDecoration(
                                    color: Colors.black45.withOpacity(0.4),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6.0)),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'UV',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white),
                                      ),
                                      SizedBox(height: 20.0),
                                      Text(
                                        '${weatherData!['current']['uv'].toString()}',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0, vertical: 30),
                                  decoration: BoxDecoration(
                                    color: Colors.black45.withOpacity(0.4),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6.0)),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Humidity',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white),
                                      ),
                                      SizedBox(height: 20.0),
                                      Text(
                                        '${weatherData!['current']['humidity'].toString()}%',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 30),
                                  decoration: BoxDecoration(
                                    color: Colors.black45.withOpacity(0.4),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6.0)),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Cloud Cover',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white),
                                      ),
                                      SizedBox(height: 20.0),
                                      Text(
                                        '${weatherData!['current']['cloud'].toString()}%',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0, vertical: 30),
                                  decoration: BoxDecoration(
                                    color: Colors.black45.withOpacity(0.4),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6.0)),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Precipitation',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white),
                                      ),
                                      SizedBox(height: 20.0),
                                      Text(
                                        '${weatherData!['current']['precip_mm'].toString()} mm',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 30),
                                  decoration: BoxDecoration(
                                    color: Colors.black45.withOpacity(0.4),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6.0)),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Pressure (mb)',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white),
                                      ),
                                      SizedBox(height: 20.0),
                                      Text(
                                        '${weatherData!['current']['pressure_mb'].toString()}',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0, vertical: 30),
                                  decoration: BoxDecoration(
                                    color: Colors.black45.withOpacity(0.4),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6.0)),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Wind Speed',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white),
                                      ),
                                      SizedBox(height: 20.0),
                                      Text(
                                        '${weatherData!['current']['wind_mph'].toString()} mph',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Data provided by',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900),
                              ),
                              SizedBox(width: 5.0),
                              Text(
                                'WeatherAPI',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                          SizedBox(height: 20)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
