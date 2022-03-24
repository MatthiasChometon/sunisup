import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sunisup/models/City.dart';
import 'package:sunisup/models/all_weather.dart';
import 'package:sunisup/models/forecast_weather.dart';
import 'dart:convert';
import '../db/City.dart';
import 'package:sunisup/models/meteo.dart';
import 'package:sunisup/models/position.dart';
import '../models/City.dart';

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

Future<List<Location>> getpositon(String name) async {
  List<Location> coordoner = await locationFromAddress(name);
  return coordoner;
}

Future<List<All_weather>> getAllMeteoInDatabase() async {
/* List<Position> dbMeteo = [
    Position('12.17', '12.25'),
    Position('24.17', '24.42'),
    Position('12.17', '12.25'),
    Position('24.17', '24.42'),
  ];*/
  var citys = await CityDatabase.instance.FetchallCitiy();
  var Data = await Future.wait(citys.map((item) async {
    //List<Location> coordoner = await locationFromAddress(item.Libelle.toString());
    List<Location> position = await getpositon(item.Libelle.toString());

    var meteo = await getMeteo(
        position[0].latitude.toString(), position[0].longitude.toString());
    var forecastWeather = await getForecastWeather(
        position[0].latitude.toString(), position[0].longitude.toString());
final city = City(Id_city: item.Id_city,Libelle: item.Libelle);
    //var ville = await CityDatabase.instance.getCity(item.Id_city.toInt());
    return All_weather(city, meteo, forecastWeather);
  }).toList());

  /*var meteo = await Future.wait(dbMeteo.map((item) async {
    var meteo = await getMeteo(item.lat, item.lon);
    var forecastWeather = await getForecastWeather(item.lat, item.lon);

    return All_weather(item,meteo, forecastWeather);
  }).toList());*/
  return Data;
}
