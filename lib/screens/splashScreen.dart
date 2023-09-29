import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mausam/screens/weather_screen.dart';
 import 'package:lottie/lottie.dart';

 



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 3 seconds and then navigate to the main app screen
    Timer(
      Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => WeatherScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: const Color.fromARGB(255, 184, 76, 76),
      body: Center(
         
        
        child:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            
             height: MediaQuery.of(context).size.height/2,

              width: MediaQuery.of(context).size.width,

            child: Lottie.asset("assets/lottie/www.json",fit: BoxFit.cover)),

        ), 

      ),
    );
  }
}

 
