import 'package:sunisup/models/forecast_weather.dart';
import 'package:sunisup/models/meteo.dart';
import './City.dart';

class All_weather {
  final Meteo meteo;
  final ForecastWeather forecastWeather;
  final City city;
  All_weather(this.city, this.meteo, this.forecastWeather);
}
