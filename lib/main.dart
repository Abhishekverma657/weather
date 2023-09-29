 import 'package:flutter/material.dart';
import 'package:mausam/provider/weather_provider.dart';
import 'package:mausam/screens/splashScreen.dart';
 
import 'package:mausam/screens/weather_screen.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
         textTheme:Theme.of(context).textTheme.apply(
  bodyColor: Colors.white,
  displayColor: Colors.white54,
),
        primarySwatch: Colors.blue,
      ),
      home:   SplashScreen(),
    );
  }
}
