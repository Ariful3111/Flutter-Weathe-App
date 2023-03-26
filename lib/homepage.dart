import 'dart:convert';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/Components/TodayWeather.dart';
import 'package:weather_app/model/Model.dart';
import 'package:weather_app/service/ApiService.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    position = await Geolocator.getCurrentPosition();
    getWeatherData();
  }

  ApiService apiService = ApiService();

  Position? position;
  Map<String, dynamic>? weathermap;
  Map<String, dynamic>? forecastmap;

  getWeatherData() async {
    var weather = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=23.8103&lon=90.4125&appid=9febddf4d1d42813a04883638c044bf8&units=metric"));
    var forecast = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?lat=23.8103&lon=90.4125&appid=9febddf4d1d42813a04883638c044bf8&units=metric"));

    var weatherData = jsonDecode(weather.body);
    var forecastData = jsonDecode(forecast.body);

    setState(() {
      weathermap = Map<String, dynamic>.from(weatherData);
      forecastmap = Map<String, dynamic>.from(forecastData);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: weathermap != null && forecastmap != null
          ? Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  height: 870,
                  width: double.infinity,
                  color: Color(0xFF949AE4),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.menu)),
                            myFont(
                                '${Jiffy(DateTime.now()).format('MMM do yyy')}\n${Jiffy(DateTime.now()).format('hh:mm a')}',
                                FontWeight.w700,
                                18),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            myFont('${weathermap!['main']['temp']}°',
                                FontWeight.w700, 50),
                            Image.network(
                              'https://openweathermap.org/img/wn/${weathermap!['weather'][0]['icon']}@2x.png',
                              color: Colors.white,
                              fit: BoxFit.cover,
                              width: 150,
                              height: 100,
                            ),
                          ],
                        ),
                        myFont('${weathermap!['weather'][0]["description"]}',
                            FontWeight.w500, 30),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            myFont(
                                "${weathermap!["name"]}", FontWeight.w700, 25),
                            Icon(
                              Icons.location_on,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            myFont(
                                'Feels like ${weathermap!['main']["feels_like"]}°',
                                null,
                                18,
                                Colors.white.withOpacity(0.8)),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xFF7275D4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                myFont(
                                    'Generally clear. High ${forecastmap!['list'][0]['main']['temp_max']} to ${forecastmap!['list'][39]['main']['temp_max']}°C and lows ${forecastmap!['list'][0]['main']['temp_min']}\nto ${forecastmap!['list'][39]['main']['temp_min']}°C',
                                    FontWeight.w700),
                                SizedBox(
                                  height: 10,
                                ),
                                Divider(
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 140,
                                  child: ListView.builder(
                                      itemCount: forecastmap!['list'].length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: EdgeInsets.only(right: 20),
                                          child: Column(
                                            children: [
                                              myFont(
                                                '${Jiffy('${forecastmap!['list'][index]['dt_txt']}').format('EEE hh:mm a')}',
                                                FontWeight.w500,
                                              ),
                                              Image.network(
                                                  'https://openweathermap.org/img/wn/${forecastmap!['list'][index]['weather'][0]['icon']}@2x.png'),
                                              myFont(
                                                  '${forecastmap!['list'][index]['main']['temp']}',
                                                  FontWeight.w500),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 100,
                              width: 175,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xFF7275D4),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(2, 2),
                                      blurStyle: BlurStyle.outer,
                                      blurRadius: 5,
                                      color: Colors.white.withOpacity(0.5)),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'asset/icons/uv.png',
                                    height: 50,
                                    width: 50,
                                  ),
                                  myFont('UV index', FontWeight.w500, 22),
                                  myFont('Low', FontWeight.w500, 16,
                                      Colors.white.withOpacity(0.7)),
                                ],
                              ),
                            ),
                            Spacer(),
                            Container(
                              height: 100,
                              width: 175,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xFF7275D4),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(2, 2),
                                      blurStyle: BlurStyle.outer,
                                      blurRadius: 5,
                                      color: Colors.white.withOpacity(0.5)),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'asset/icons/humidity.png',
                                    height: 50,
                                    width: 50,
                                    color: Colors.lightBlueAccent,
                                  ),
                                  myFont('Humidity', FontWeight.w500, 22),
                                  myFont('${weathermap!['main']['humidity']}%')
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 100,
                              width: 175,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xFF7275D4),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(2, 2),
                                      blurStyle: BlurStyle.outer,
                                      blurRadius: 5,
                                      color: Colors.white.withOpacity(0.5)),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'asset/icons/wind.png',
                                    height: 50,
                                    width: 50,
                                    color: Colors.grey,
                                  ),
                                  myFont('Wind', FontWeight.w500, 22),
                                  myFont('${weathermap!['wind']['speed']}km/h')
                                ],
                              ),
                            ),
                            Spacer(),
                            Container(
                              height: 100,
                              width: 175,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xFF7275D4),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(2, 2),
                                      blurStyle: BlurStyle.outer,
                                      blurRadius: 5,
                                      color: Colors.white.withOpacity(0.5)),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        myFont(
                                            'Sunrise\n${Jiffy('${DateTime.fromMillisecondsSinceEpoch(weathermap!['sys']['sunrise'] * 1000)}').format('hh:mm a')}',
                                            FontWeight.w500),
                                        Spacer(),
                                        myFont(
                                            'Sunset\n${Jiffy('${DateTime.fromMillisecondsSinceEpoch(weathermap!['sys']['sunset'] * 1000)}').format('hh:mm a')}',
                                            FontWeight.w500),
                                      ],
                                    ),
                                    Image.asset(
                                      'asset/icons/sun.png',
                                      height: 48,
                                      width: 100,
                                      color: Colors.yellow,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

myFont(String data, [FontWeight? fontWeight, double? size, Color? color]) {
  return Text(
    data,
    style: TextStyle(
        color: color == null ? Colors.white : color,
        fontWeight: fontWeight,
        fontSize: size),
  );
}
