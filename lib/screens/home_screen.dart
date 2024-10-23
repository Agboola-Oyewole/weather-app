import 'package:clima_weather/screens/search_cities.dart';
import 'package:clima_weather/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/location_data.dart';
import '../data/units_data.dart';
import '../data/weather_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.weatherData});

  final Map<String, dynamic>? weatherData;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? weatherData;

  IconData getWeatherIcon(double tempCelsius, String condition) {
    if (tempCelsius >= 30) {
      // Hot weather - sunny
      return Icons.wb_sunny;
    } else if (tempCelsius >= 20 && tempCelsius < 30) {
      // Warm weather - sunny with some clouds
      if (condition.contains('cloud')) {
        return Icons.wb_cloudy; // Cloudy icon
      } else {
        return Icons.wb_sunny; // Sunny icon
      }
    } else if (tempCelsius >= 10 && tempCelsius < 20) {
      // Cool weather - partly cloudy or rainy
      if (condition.contains('rain')) {
        return Icons.cloudy_snowing; // Rain icon
      } else if (condition.contains('cloud')) {
        return Icons.cloud; // Partly cloudy
      } else {
        return Icons.wb_sunny; // Still sunny, but cooler
      }
    } else if (tempCelsius < 10) {
      // Cold weather - cloudy or rainy
      if (condition.contains('rain')) {
        return Icons.cloudy_snowing; // Rain icon
      } else if (condition.contains('snow')) {
        return Icons.ac_unit; // Snow icon
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
    return '${DateFormat('EEE').format(parsedDate)} ${parsedDate
        .day}$daySuffix ${DateFormat('MMM').format(parsedDate)}';
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

  Future<String> getLocation() async {
    Location location = Location();
    await location.determinePosition(context);
    String longLat = '${location.latitude},${location.longitude}';
    return longLat;
  }

  void _getWeatherData() async {
    try {
      final coordinates = await getLocation();
      print(coordinates);
      final data = await _weatherService.fetchWeatherData(coordinates);
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
      body: SafeArea(
        child: Stack(
          children: [
            // Background image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(isWeatherClear(
                      widget.weatherData!['current']['condition']['text'])
                      ? 'images/pexels-elia-clerici-282848-912110.jpg'
                      : 'images/pexels-pixabay-414659.jpg'),
                  fit: BoxFit.cover,
                  // Fills the entire Scaffold but keeps the image centered
                  alignment: Alignment.center, // Ensures the image is centered
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Icon(
                          Icons.my_location_outlined,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        onTap: () {
                          _getWeatherData();
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const SearchCities()));
                            },
                          ),
                          SizedBox(width: 20.0),
                          GestureDetector(
                            child: Icon(
                              Icons.settings_sharp,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const SettingsScreen()));
                            },
                          ),
                        ],
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
                            widget.weatherData?['location']['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 23,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                Provider
                                    .of<UnitData>(context)
                                    .selectedTempUnit ==
                                    '°C'
                                    ? '${widget
                                    .weatherData!['current']['temp_c']
                                    .toString()}°'
                                    : '${widget
                                    .weatherData!['current']['temp_f']
                                    .toString()}°',
                                style: TextStyle(
                                    fontSize: 90,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 25.0),
                                child: Text(
                                  Provider
                                      .of<UnitData>(context)
                                      .selectedTempUnit,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            Provider
                                .of<UnitData>(context)
                                .selectedTempUnit ==
                                '°C'
                                ? "High: ${widget
                                .weatherData!['forecast']['forecastday'][0]['day']['maxtemp_c']}° / Low: ${widget
                                .weatherData!['forecast']['forecastday'][0]['day']['mintemp_c']}°"
                                : "High: ${widget
                                .weatherData!['forecast']['forecastday'][0]['day']['maxtemp_f']}° / Low: ${widget
                                .weatherData!['forecast']['forecastday'][0]['day']['mintemp_f']}°",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 18),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            '${widget
                                .weatherData!['current']['condition']['text']}',
                            style: TextStyle(
                                fontSize: 23,
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 15.0),
                          Text(
                            'Last Updated: ${formatDate(
                                widget.weatherData!['current']['last_updated']
                                    .toString())} ${widget
                                .weatherData!['current']['last_updated']
                                .toString()
                                .split(' ')[1]}',
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
                                                Provider
                                                    .of<UnitData>(context)
                                                    .selectedTempUnit ==
                                                    '°C'
                                                    ? widget.weatherData![
                                                'current']['temp_c']
                                                    : widget.weatherData![
                                                'current']['temp_f'],
                                                widget.weatherData!['current']
                                                ['condition']['text']),
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 50.0),
                                          Text(
                                            Provider
                                                .of<UnitData>(context)
                                                .selectedTempUnit ==
                                                '°C'
                                                ? '${widget
                                                .weatherData!['forecast']['forecastday'][0]['day']['maxtemp_c']}° / ${widget
                                                .weatherData!['forecast']['forecastday'][0]['day']['mintemp_c']}°'
                                                : '${widget
                                                .weatherData!['forecast']['forecastday'][0]['day']['maxtemp_f']}° / ${widget
                                                .weatherData!['forecast']['forecastday'][0]['day']['mintemp_f']}°',
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
                                                Provider
                                                    .of<UnitData>(context)
                                                    .selectedTempUnit ==
                                                    '°C' ?
                                                widget.weatherData!['forecast']
                                                ['forecastday'][1]
                                                ['day']['avgtemp_c'] : widget
                                                    .weatherData!['forecast']
                                                ['forecastday'][1]
                                                ['day']['avgtemp_f'],
                                                widget.weatherData!['forecast']
                                                ['forecastday'][1]
                                                ['day']['condition']
                                                ['text']),
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 50.0),
                                          Text(
                                            Provider
                                                .of<UnitData>(context)
                                                .selectedTempUnit ==
                                                '°C'
                                                ? '${widget
                                                .weatherData!['forecast']['forecastday'][1]['day']['maxtemp_c']}° / ${widget
                                                .weatherData!['forecast']['forecastday'][1]['day']['mintemp_c']}°'
                                                : '${widget
                                                .weatherData!['forecast']['forecastday'][1]['day']['maxtemp_f']}° / ${widget
                                                .weatherData!['forecast']['forecastday'][1]['day']['mintemp_f']}°',
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
                                        '${formatDate(widget
                                            .weatherData!['forecast']['forecastday'][2]['date'])}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16.0),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            getWeatherIcon(
                                                Provider
                                                    .of<UnitData>(context)
                                                    .selectedTempUnit ==
                                                    '°C' ?
                                                widget.weatherData!['forecast']
                                                ['forecastday'][2]
                                                ['day']['avgtemp_c'] : widget
                                                    .weatherData!['forecast']
                                                ['forecastday'][2]
                                                ['day']['avgtemp_f'],
                                                widget.weatherData!['forecast']
                                                ['forecastday'][2]
                                                ['day']['condition']
                                                ['text']),
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 50.0),
                                          Text(
                                            Provider
                                                .of<UnitData>(context)
                                                .selectedTempUnit ==
                                                '°C'
                                                ?
                                            '${widget
                                                .weatherData!['forecast']['forecastday'][2]['day']['maxtemp_c']}° / ${widget
                                                .weatherData!['forecast']['forecastday'][2]['day']['mintemp_c']}°'
                                                : '${widget
                                                .weatherData!['forecast']['forecastday'][2]['day']['maxtemp_f']}° / ${widget
                                                .weatherData!['forecast']['forecastday'][2]['day']['mintemp_f']}°',
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
                                        '${formatDate(widget
                                            .weatherData!['forecast']['forecastday'][3]['date'])}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16.0),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            getWeatherIcon(
                                                Provider
                                                    .of<UnitData>(context)
                                                    .selectedTempUnit ==
                                                    '°C' ?
                                                widget.weatherData!['forecast']
                                                ['forecastday'][3]
                                                ['day']['avgtemp_c'] : widget
                                                    .weatherData!['forecast']
                                                ['forecastday'][3]
                                                ['day']['avgtemp_f'],
                                                widget.weatherData!['forecast']
                                                ['forecastday'][3]
                                                ['day']['condition']
                                                ['text']),
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 50.0),
                                          Text(Provider
                                              .of<UnitData>(context)
                                              .selectedTempUnit ==
                                              '°C'
                                              ?
                                          '${widget
                                              .weatherData!['forecast']['forecastday'][3]['day']['maxtemp_c']}° / ${widget
                                              .weatherData!['forecast']['forecastday'][3]['day']['mintemp_c']}°'
                                              : '${widget
                                              .weatherData!['forecast']['forecastday'][3]['day']['maxtemp_f']}° / ${widget
                                              .weatherData!['forecast']['forecastday'][3]['day']['mintemp_f']}°',
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
                                        '${formatDate(widget
                                            .weatherData!['forecast']['forecastday'][4]['date'])}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16.0),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            getWeatherIcon(
                                                Provider
                                                    .of<UnitData>(context)
                                                    .selectedTempUnit ==
                                                    '°C' ?
                                                widget.weatherData!['forecast']
                                                ['forecastday'][4]
                                                ['day']['avgtemp_c'] : widget
                                                    .weatherData!['forecast']
                                                ['forecastday'][4]
                                                ['day']['avgtemp_f'],
                                                widget.weatherData!['forecast']
                                                ['forecastday'][4]
                                                ['day']['condition']
                                                ['text']),
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 50.0),
                                          Text(
                                            Provider
                                                .of<UnitData>(context)
                                                .selectedTempUnit ==
                                                '°C'
                                                ?
                                            '${widget
                                                .weatherData!['forecast']['forecastday'][4]['day']['maxtemp_c']}° / ${widget
                                                .weatherData!['forecast']['forecastday'][4]['day']['mintemp_c']}°'
                                                : '${widget
                                                .weatherData!['forecast']['forecastday'][4]['day']['maxtemp_f']}° / ${widget
                                                .weatherData!['forecast']['forecastday'][4]['day']['mintemp_f']}°',
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
                                        '${widget.weatherData!['current']['uv']
                                            .toString()}',
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
                                        '${widget
                                            .weatherData!['current']['humidity']
                                            .toString()}%',
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
                                        '${widget
                                            .weatherData!['current']['cloud']
                                            .toString()}%',
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
                                        '${widget
                                            .weatherData!['current']['precip_mm']
                                            .toString()} mm',
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
                                        'Pressure',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white),
                                      ),
                                      SizedBox(height: 20.0),
                                      Text(Provider
                                          .of<UnitData>(context)
                                          .selectedPressureUnit ==
                                          'mb' ?
                                      '${widget
                                          .weatherData!['current']['pressure_mb']
                                          .toString()} ${Provider
                                          .of<UnitData>(context)
                                          .selectedPressureUnit}' : '${widget
                                          .weatherData!['current']['pressure_in']
                                          .toString()} ${Provider
                                          .of<UnitData>(context)
                                          .selectedPressureUnit}',
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
                                      Text(Provider
                                          .of<UnitData>(context)
                                          .selectedWindUnit ==
                                          'mph' ?
                                      '${widget
                                          .weatherData!['current']['wind_mph']
                                          .toString()} ${Provider
                                          .of<UnitData>(context)
                                          .selectedWindUnit}' : '${widget
                                          .weatherData!['current']['wind_kph']
                                          .toString()} ${Provider
                                          .of<UnitData>(context)
                                          .selectedWindUnit}',
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
