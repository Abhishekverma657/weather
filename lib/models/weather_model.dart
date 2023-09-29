class Weather {
  final String city;
  final double temperature;
  final String description;
   final double Air;
   final List<WeatherForecast> forecast;
   final List<WeatherForecastHourly> hourlyForecast;

  Weather({
    required this.city,
    required this.temperature,
    required this.description,
     required this.Air,
     required this.forecast,
     required this.hourlyForecast

  });
}
class WeatherForecast {
  final DateTime date;
  final double temperature;
  final String description;

  WeatherForecast({
    required this.date,
    required this.temperature,
    required this.description,
  });
  
}
class WeatherForecastHourly {
  final DateTime time;
  final double temperature;
  final String description;

  WeatherForecastHourly({
    required this.time,
    required this.temperature,
    required this.description,
  });
}
