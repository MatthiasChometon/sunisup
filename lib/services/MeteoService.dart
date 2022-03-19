import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sunisup/models/all_weather.dart';
import 'package:sunisup/models/forecast_weather.dart';
import 'dart:convert';

import 'package:sunisup/models/meteo.dart';
import 'package:sunisup/models/position.dart';

Future<Meteo> getMeteo(String lat, String lon) async {
  var url = Uri.https("api.openweathermap.org", '/data/2.5/weather', {
    'lat': lat,
    'lon': lon,
    'units': 'Metric',
    'appid': 'b143d2194191d634a1323e5080049938'
  });

  var response = await http.get(url);

  Map map = json.decode(response.body);
  Meteo meteo = Meteo.fromJson(map);
  meteo.icon = await getWeatherIcon(meteo.weather![0].icon);

  return meteo;
}

Future<ForecastWeather> getForecastWeather(String lat, String lon) async {
  var url = Uri.https("api.openweathermap.org", '/data/2.5/forecast', {
    'lat': lat,
    'lon': lon,
    'units': 'Metric',
    'appid': 'b143d2194191d634a1323e5080049938'
  });

  var response = await http.get(url);

  Map<String, dynamic> map = json.decode(response.body);
  ForecastWeather forecastWeather = ForecastWeather.fromJson(map);

  List<ListHours> newWeatherList = [];
  for (var weather in forecastWeather.list!) {
    var now = DateTime.now();
    var weatherToTest = DateTime.parse(weather.dtTxt ?? '');

    if (weatherToTest.hour == 12 && weatherToTest.compareTo(now) > 0) {
      weather.icon = await getWeatherIcon(weather.weather![0].icon);
      newWeatherList.add(weather);
    }
  }

  forecastWeather.list = newWeatherList;

  return forecastWeather;
}

Future<String> getWeatherIcon(String? iconPath) async {
  var url = Uri.https("api.openweathermap.org", "/img/w/$iconPath.png",
      {'appid': 'b143d2194191d634a1323e5080049938'});

  return url.toString();
}

Future<List<All_weather>> getAllMeteoInDatabase() async {
  List<Position> dbMeteo = [
    Position('12.17', '12.25'),
    Position('24.17', '24.42'),
    Position('12.17', '12.25'),
    Position('24.17', '24.42'),
  ];

  var meteo = await Future.wait(dbMeteo.map((item) async {
    var meteo = await getMeteo(item.lat, item.lon);
    var forecastWeather = await getForecastWeather(item.lat, item.lon);

    return All_weather(meteo, forecastWeather);
  }).toList());

  return meteo;
}
