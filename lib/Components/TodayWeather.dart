import 'package:flutter/material.dart';
import 'package:weather_app/model/Model.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';

class TodayWeather extends StatefulWidget {
  final WeatherModel ? weatherModel;
  const TodayWeather({Key? key, this.weatherModel}) : super(key: key);

  @override
  State<TodayWeather> createState() => _TodayWeatherState();
}

class _TodayWeatherState extends State<TodayWeather> {
  WeatherModel ? weatherModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WeatherBg(weatherType: WeatherType.sunnyNight,
            width: 600,
           height: 300,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(weatherModel?.location?.name.toString()??'NO Data Found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w700
              ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
