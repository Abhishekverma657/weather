import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:mausam/provider/weather_provider.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

class WeatherScreen extends StatefulWidget {
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController cityController = TextEditingController();
  bool _isLoadingWeather = false;
  bool _showShimmer = false;
  bool isSearching = false;

  void _startSearch() {
    setState(() {
      isSearching = true;
    });
  }

  void _cancelSearch() {
    setState(() {
      isSearching = false;
      cityController.clear();
    });
  }

  Future<bool> requestLocationPermission() async {
    // Request location permission
    final status = await Permission.location.request();

    if (status.isGranted) {
      // Location permission granted, proceed with fetching location or any other action.
      print("Location is allowed");
      return true;
    } else {
      
      if (status.isPermanentlyDenied) {
      
        openAppSettings(); // Opens the app settings page on the device.
      }
      return false;
    }
  }

  @override
  void initState(){
    // TODO: implement initState
    // requestLocationPermission();
     
       
        
     
    
     

    super.initState();
     _fetchWeatherByLocation();
  }
   

      Future _fetchWeatherByLocation() async {
    requestLocationPermission();

    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);

    // Check location permission and fetch weather data
    final locationPermissionGranted = await requestLocationPermission();
    if (locationPermissionGranted) {
      setState(() {
        _isLoadingWeather = true;
        _showShimmer = true;
      });
      // final city = cityController.text;
      await weatherProvider.fetchWeatherByLocation();
      setState(() {
        _isLoadingWeather = false;
        _showShimmer = false;
      });
      _isLoadingWeather
          ? _buildShimmerEffect(context)
          : await weatherProvider.fetchWeatherByLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    // Fetch weather data based on user's location initially

    return Container(
      decoration: const  BoxDecoration(
        image: DecorationImage(
            opacity: -.6,
            image: AssetImage(
              "assets/background.jpg",
            ),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
           elevation: 2,
           backgroundColor: const Color.fromARGB(255, 184, 76, 76),
          title: isSearching
              ? TextField(
                  controller: cityController,
                   onSubmitted: (_) async{
                      setState(() {
                          _isLoadingWeather = true;
                          _showShimmer = true;
                          
                        });
                        final city = cityController.text;
                        await weatherProvider.fetchWeather(city);
                        setState(() {
                          _isLoadingWeather = false;
                          _showShimmer = false;
                        });

                     
                   },
                  decoration: InputDecoration(
                    hintText: 'Search for a city...',hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                     
                     
                    suffixIcon: IconButton(
                      onPressed: () async {
                        setState(() {
                          _isLoadingWeather = true;
                          _showShimmer = true;
                        });
                        final city = cityController.text;
                        await weatherProvider.fetchWeather(city);
                        setState(() {
                          _isLoadingWeather = false;
                          _showShimmer = false;
                        });
                      },
                      icon: Icon(Icons.search,color: Colors.white,),
                    ),
                  ),
                )
              : Text('Weather App'),
          actions: [
            if (isSearching)
              IconButton(
                onPressed: () {
                  _cancelSearch();
                },
                icon: Icon(Icons.cancel),
              )
            else
              IconButton(
                onPressed: () {
                  _startSearch();
                },
                icon: Icon(Icons.search),
              ),
          ],
          leading: IconButton(
            icon: Icon(Icons.location_on),
            onPressed: () async {
              setState(() {
                _isLoadingWeather = true;
                _showShimmer = true;
              });
              // final city = cityController.text;
              await weatherProvider.fetchWeatherByLocation();
              setState(() {
                _isLoadingWeather = false;
                _showShimmer = false;
              });
              _isLoadingWeather
                  ? _buildShimmerEffect(context)
                  : await weatherProvider.fetchWeatherByLocation();
            },
          ),
        ),
        body:   _isLoadingWeather
                      ? _buildShimmerEffect(context)
                      : weatherProvider.weather != null
                          ?
        
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Align(
                //    alignment: Alignment.topCenter,
                //   child: Container(
                //      decoration: BoxDecoration(
                //        borderRadius: BorderRadius.circular(20),
                //       color: Colors.red),
                //     child: TextField(
                //       controller: cityController,
                //       decoration: InputDecoration(labelText: 'Enter City'),
                //     ),
                //   ),
                // ),
                //           ElevatedButton(
                //             onPressed: () async {
                //               setState(() {
                //   _isLoadingWeather = true;
                //   _showShimmer = true;
                // });
                //               final city = cityController.text;
                //               await weatherProvider.fetchWeather(city);
                //                setState(() {
                //   _isLoadingWeather = false;
                //   _showShimmer = false;
                // });
                //             },
                //             child: Text('Get Weather'),
                //           ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.4,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      //  border: Border.all(color: Colors.white),
          
                      borderRadius: BorderRadius.circular(20)),
                  child:
                  //  _isLoadingWeather
                  //     ? _buildShimmerEffect(context)
                  //     : weatherProvider.weather != null
                  //         ?
                           Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                  Text(
                                    "${weatherProvider.weather!.city}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50,
                                    ),
                                  ),
                                  Container(
                                    height: 200,
                                    width: MediaQuery.of(context).size.width / 2,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: weatherProvider
                                                    .weather!.description
                                                    .toLowerCase()
                                                    .contains("clouds")
                                                ?  const AssetImage("assets/clouds.png")
                                                : weatherProvider
                                                        .weather!.description
                                                        .toLowerCase()
                                                        .contains("rain")
                                                    ?  const AssetImage(
                                                        "assets/lightrain.gif")
                                                    : weatherProvider
                                                            .weather!.description
                                                            .toLowerCase()
                                                            .contains("sunny")
                                                        ? const  AssetImage(
                                                            "assets/sun.png")
                                                        : weatherProvider.weather!
                                                                .description
                                                                .toLowerCase()
                                                                .contains("mist")
                                                            ? const  AssetImage(
                                                                "assets/mist.png")
                                                            :  const AssetImage(
                                                                "assets/clearsky.png"),
                                            fit: BoxFit.contain)),
                                  ),
                                  Spacer(),
                                  Text(
                                    '${weatherProvider.weather!.temperature.toStringAsFixed(1)}°C',
                                    style:  const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 80),
                                  ),
          
                                  // const  Spacer(),
                                  Text(
                                    ' ${weatherProvider.weather!.description}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  const  Spacer()
                                ])
                          // : null,
                ),
                
                  Container(
                     color: Colors.transparent,
                    child:  _isLoadingWeather
                      ? _buildShimmerEffect(context)
                      : weatherProvider.weather != null? Column(
                      children: [
                        
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Container(
                             
                           
                             decoration: BoxDecoration(
                               color: Colors.transparent,
                               borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white,
                               
                              ),
                                                 boxShadow: const  [
                             BoxShadow(
                              color: Colors.grey,
                              blurRadius: 100,
                             
                         
                             )
                                                 ]
                              ),
                             child:  const Padding(
                               padding: EdgeInsets.all(10.0),
                               child: Text(
                                '24-Hour Forecast',
                                style:
                                    TextStyle(
                                      backgroundColor: Colors.transparent,
                                      fontSize: 24, fontWeight: FontWeight.bold),
                                                     ),
                             ),
                           ),
                         ),
                            
                        // Display 24-hour forecast
                        //  GridView.builder(gridDelegate: gridDelegate, itemBuilder: itemBuilder)
                    GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns in the grid
                    ),
                    itemCount: weatherProvider.weather!.hourlyForecast.length,
                    itemBuilder: (context, index) {
                      final forecast = weatherProvider.weather!.hourlyForecast[index];
                      final dateFormat = DateFormat('EEE, MMM d, yyyy - HH:mm a');
                      final formattedTime = dateFormat.format(forecast.time);
                       final timeOnly = DateFormat('HH:mm a').format(forecast.time);
                    
                      return Card(
                        
                        elevation: 1,
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                            timeOnly,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Temp: ${forecast.temperature.toStringAsFixed(2)}°C',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 4),
                              Text(
                                forecast.description,
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    ),
                    
                                   
                            
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                      Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Container(
                             
                           
                             decoration: BoxDecoration(
                               color: Colors.transparent,
                               borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white,
                               
                              ),
                                                 boxShadow: const  [
                             BoxShadow(
                              color: Colors.grey,
                              blurRadius: 100,
                             
                         
                             )
                                                 ]
                              ),
                             child:  const Padding(
                               padding: EdgeInsets.all(10.0),
                               child: Text(
                                '5 -Day Forecast',
                                style:
                                    TextStyle(
                                      backgroundColor: Colors.transparent,
                                      fontSize: 24, fontWeight: FontWeight.bold),
                                                     ),
                             ),
                           ),
                         ),
                        GridView.builder(
                    // ...
                       shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns in the grid
                    ),
                    itemCount: weatherProvider.weather!.forecast.length,
                    itemBuilder: (context, index) {
                      final forecast = weatherProvider.weather!.forecast[index];
                      final dateFormat = DateFormat('EEE, MMM d, yyyy - HH:mm a');
                      final formattedDate = dateFormat.format(forecast.date);
                    
                      return Card(
                        elevation: 3,
                         color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Temp: ${forecast.temperature.toStringAsFixed(2)}°C, ${forecast.description}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    ),
                    
                            
                        
                      ],
                    ):Text("No data"),
                  )
              ],
            ),
          ),
        ):Container(
           height: MediaQuery.of(context).size.height/1.2,
            width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(image: DecorationImage(
             fit:  BoxFit.contain,
              colorFilter: ColorFilter.linearToSrgbGamma(),
            image: AssetImage("assets/error.png",))),child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                   mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("No data Found",style: TextStyle(color: Colors.red,fontSize: 30,fontWeight: FontWeight.bold),),
                     Text("Please try to correct city name",style: TextStyle(color: Colors.white,fontStyle: FontStyle.italic),)
                  ],
                ),
              )),

        ),
      ),
    );
  }

  // Helper function to determine the background GIF based on weather description
  // String _getBackgroundAnimation(String weatherDescription) {
  //   if (weatherDescription.toLowerCase().contains('rain')) {
  //     return 'assets/lightrain.gif'; // Replace with your rainy GIF
  //   } else if (weatherDescription.toLowerCase().contains('sun')) {
  //     return  'assets/lightrain.gif'; // Replace with your sunny GIF
  //   } else {
  //     return  'assets/lightrain.gif'; // Default background
  //   }
  // }
}

Widget _buildShimmerEffect(BuildContext context) {
  return Shimmer.fromColors(
    
    direction: ShimmerDirection.ltr,
    baseColor: Colors.transparent,
    period: Duration(milliseconds: 800),
     
    // baseColor: Color.fromARGB(255, 115, 35, 29),
    highlightColor: Color.fromARGB(255, 128, 126, 126),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            //  backgroundBlendMode: BlendMode.hardLight,
          ),
          height: 30 ,
          width: MediaQuery.of(context).size.width,
        ),
         SizedBox(height: 5),
          Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            //  backgroundBlendMode: BlendMode.hardLight,
          ),
          height: 30 ,
          width: MediaQuery.of(context).size.width,
        ),
         SizedBox(height: 5),
          Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            //  backgroundBlendMode: BlendMode.hardLight,
          ),
          height: 30 ,
          width: MediaQuery.of(context).size.width,
        ),
         SizedBox(height: 5),
         Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            //  backgroundBlendMode: BlendMode.hardLight,
          ),
          height: MediaQuery.of(context).size.height / 5,
          width: MediaQuery.of(context).size.width,
        ),
        SizedBox(height: 5),
         Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            //  backgroundBlendMode: BlendMode.hardLight,
          ),
          height: MediaQuery.of(context).size.height / 5,
          width: MediaQuery.of(context).size.width,
        ),
        SizedBox(height: 5),
         Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            //  backgroundBlendMode: BlendMode.hardLight,
          ),
          height: MediaQuery.of(context).size.height / 5,
          width: MediaQuery.of(context).size.width,
        ),
         Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            //  backgroundBlendMode: BlendMode.hardLight,
          ),
          height: 30 ,
          width: MediaQuery.of(context).size.width,
        ),
         SizedBox(height: 5),
          Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            //  backgroundBlendMode: BlendMode.hardLight,
          ),
          height: 30 ,
          width: MediaQuery.of(context).size.width,
        ),
         SizedBox(height: 5),
       
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            // borderRadius: BorderRadius.circular(20)
          ),
          height: MediaQuery.of(context).size.height / 8,
          width: MediaQuery.of(context).size.width,
        ),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            // borderRadius: BorderRadius.circular(20)
          ),
          height: MediaQuery.of(context).size.height / 9,
          width: MediaQuery.of(context).size.width,
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            // borderRadius: BorderRadius.circular(20)
          ),
          height: 50,
          width: MediaQuery.of(context).size.width,
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey,

            // borderRadius: BorderRadius.circular(20)
          ),
          height: MediaQuery.of(context).size.height / 10,
          width: MediaQuery.of(context).size.width,
        ),
         SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey,

            // borderRadius: BorderRadius.circular(20)
          ),
          height: MediaQuery.of(context).size.height / 10,
          width: MediaQuery.of(context).size.width,
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey,

            // borderRadius: BorderRadius.circular(20)
          ),
          height: MediaQuery.of(context).size.height / 10,
          width: MediaQuery.of(context).size.width,
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey,

            // borderRadius: BorderRadius.circular(20)
          ),
          height: MediaQuery.of(context).size.height / 10,
          width: MediaQuery.of(context).size.width,
        ),
        SizedBox(height: 10),
      ],
    ),
  );
}
