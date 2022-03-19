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
              return SizedBox(
                  height: 600,
                  child: ReorderableListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    children: <Widget>[
                      for (int index = 0;
                          index < snapshot.data!.length;
                          index += 1)
                        WeatherPanel(
                            key: Key('$index'),
                            meteo: snapshot.data![index].meteo,
                            forecastWeather:
                                snapshot.data![index].forecastWeather)
                    ],
                    onReorder: (int oldIndex, int newIndex) {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      setState(() {
                        final All_weather item =
                            snapshot.data!.removeAt(oldIndex);
                        snapshot.data!.insert(newIndex, item);
                      });
                    },
                  ));
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
