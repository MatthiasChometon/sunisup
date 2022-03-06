import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sunisup/models/all_weather.dart';
import 'package:sunisup/models/meteo.dart';
import 'package:sunisup/services/MeteoService.dart';
import 'package:sunisup/widgets/WeatherPanel.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<All_weather>>(
          future: getAllMeteoInDatabase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text("Chargement en cours ... "));
            } else if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, i) {
                    return WeatherPanel(
                        meteo: snapshot.data![i].meteo,
                        forecastWeather: snapshot.data![i].forecastWeather);
                  });
            } else {
              return const Text("Une erreur est survenue");
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
