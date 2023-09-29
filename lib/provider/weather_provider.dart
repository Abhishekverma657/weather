import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mausam/models/weather_model.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

 

class WeatherProvider with ChangeNotifier {
  Weather? _weather;

  Weather? get weather => _weather;

  Future<void> fetchWeather(String city) async {
    final apiKey = '4c031230dcdb810b310e122437f2a5a0';
    final url = Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final weatherData = json.decode(response.body);
            final forecastData = await _fetch5DayForecast(city, apiKey);
               final hourlyForecastData =
          await _fetch24HourForecast(city, apiKey);
      final weather = Weather(
        city: weatherData['name'],
        temperature: (weatherData['main']['temp'] - 273.15),
        description: weatherData['weather'][0]['description'],
         Air: weatherData['wind']['speed'],
          forecast: forecastData,
          hourlyForecast: hourlyForecastData
      );
       
      _weather = weather;
    
    }
     else{
      _weather=null;
     }
      notifyListeners();
  }

   Future<void> fetchWeatherByLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final apiKey = '4c031230dcdb810b310e122437f2a5a0';
      final lat = position.latitude;
      final lon = position.longitude;
      final url = Uri.parse(
          'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey');
      final response = await http.get(url);

        /// 5 days and 24 hrs forcase

         final fiveDayForecastUrl = Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey');
      final fiveDayForecastResponse = await http.get(fiveDayForecastUrl);

      final hourlyForecastUrl = Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&cnt=9&appid=$apiKey'); // Fetching 24-hour forecast (3-hour intervals)
      final hourlyForecastResponse = await http.get(hourlyForecastUrl);



      



      if (response.statusCode == 200 &&
          fiveDayForecastResponse.statusCode == 200 &&
          hourlyForecastResponse.statusCode == 200) {
        final weatherData = json.decode(response.body);
          final fiveDayForecastData = json.decode(fiveDayForecastResponse.body);
        final hourlyForecastData = json.decode(hourlyForecastResponse.body);
        final weather = Weather(
          city: weatherData['name'],
          temperature: (weatherData['main']['temp'] - 273.15),
          description: weatherData['weather'][0]['description'],
           Air :weatherData['wind']['speed'],
          forecast: _parseFiveDayForecast(fiveDayForecastData),
          hourlyForecast: _parseHourlyForecast(hourlyForecastData),// Initialize with an empty hourly forecast
        );
        _weather = weather;
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching weather by location: $e');
    }
  }

List<WeatherForecast> _parseFiveDayForecast(Map<String, dynamic> data) {
    final List<WeatherForecast> forecastList = [];

    for (final item in data['list']) {
      final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
      final temp = item['main']['temp'] - 273.15;
      final description = item['weather'][0]['description'];

      forecastList.add(WeatherForecast(
        date: date,
        temperature: temp,
        description: description,
      ));
    }

    return forecastList;
  }

  List<WeatherForecastHourly> _parseHourlyForecast(Map<String, dynamic> data) {
    final List<WeatherForecastHourly> forecastList = [];

    for (final item in data['list']) {
      final time = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
      final temp = item['main']['temp'] - 273.15;
      final description = item['weather'][0]['description'];

      forecastList.add(WeatherForecastHourly(
        time: time,
        temperature: temp,
        description: description,
      ));
    }

    return forecastList;
  }
}











    Future<List<WeatherForecast>> _fetch5DayForecast(
      String city, String apiKey) async {
    final forecastUrl = Uri.parse(
        'http://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey');
    final forecastResponse = await http.get(forecastUrl);

    if (forecastResponse.statusCode == 200) {
      final forecastData = json.decode(forecastResponse.body);
      final List<WeatherForecast> forecasts = [];

      for (final forecast in forecastData['list']) {
        final forecastDate = DateTime.fromMillisecondsSinceEpoch(
            forecast['dt'] * 1000, isUtc: false);
        final forecastTemp = forecast['main']['temp'] - 273.15;
        final forecastDescription = forecast['weather'][0]['description'];

        forecasts.add(WeatherForecast(
          date: forecastDate,
          temperature: forecastTemp,
          description: forecastDescription,
        ));
      }

      return forecasts;
    } else {
      return [];
    }
  }
  Future<List<WeatherForecastHourly>> _fetch24HourForecast(
      String city, String apiKey) async {
    final hourlyForecastUrl = Uri.parse(
        'http://api.openweathermap.org/data/2.5/forecast?q=$city&cnt=8&appid=$apiKey');
    final hourlyForecastResponse = await http.get(hourlyForecastUrl);

    if (hourlyForecastResponse.statusCode == 200) {
      final hourlyForecastData = json.decode(hourlyForecastResponse.body);
      final List<WeatherForecastHourly> hourlyForecasts = [];

      for (final forecast in hourlyForecastData['list']) {
        final forecastTime = DateTime.fromMillisecondsSinceEpoch(
            forecast['dt'] * 1000, isUtc: false);
        final forecastTemp = forecast['main']['temp'] - 273.15;
        final forecastDescription = forecast['weather'][0]['description'];

        hourlyForecasts.add(WeatherForecastHourly(
          time: forecastTime,
          temperature: forecastTemp,
          description: forecastDescription,
        ));
      }

      return hourlyForecasts;
    } else {
      return [];
    }
  }


