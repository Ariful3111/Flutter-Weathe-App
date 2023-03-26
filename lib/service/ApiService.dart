import 'dart:convert';

import 'package:http/http.dart';
import 'package:weather_app/constent/constant.dart';
import 'package:weather_app/model/Model.dart';

class ApiService{

Future<WeatherModel> getWeatherData(String searchtext)async{
String url="$base_url&q=$searchtext&days=7";
try{
  Response response = await get(Uri.parse(url));
  if(response.statusCode==200){
    Map<String, dynamic> json=jsonDecode(response.body);
    WeatherModel weatherModel = WeatherModel.fromJson(json);
    return weatherModel;
  }else{
    throw('No Data Found');
  }
}catch(e){
  print('${e.toString()}');
  throw e.toString();
}
}

}
