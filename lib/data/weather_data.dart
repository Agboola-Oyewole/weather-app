import 'dart:convert'; // For converting the API response to JSON format

import 'package:http/http.dart' as http;

class WeatherService {
  // Base URL of OpenWeatherMap API
  final String _apiKey = '2a5ac0b909004d63a5f174036242110';
  final String _apiUrl = 'https://api.weatherapi.com/v1/forecast.json';

  Future<Map<String, dynamic>> fetchWeatherData(String cityName) async {
    try {
      // Constructing the API URL with the city name and your API key
      final url = Uri.parse(
          '$_apiUrl?key=$_apiKey&q=$cityName&days=5&aqi=no&alerts=no');

      // Sending the GET request to the weather API
      final response = await http.get(url);

      // Checking if the status code is OK
      if (response.statusCode == 200) {
        // Parsing the JSON response into a Map
        final Map<String, dynamic> weatherData = json.decode(response.body);
        return weatherData;
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }
}
