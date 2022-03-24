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
  String meteoWallpaper = "assets/wallpapers/Clear.jpg";

  @override
  Widget build(BuildContext context) {
    void getWeatherWallpaper(meteo) {
      setState(() {
        meteoWallpaper = "assets/wallpapers/$meteo.jpg";
      });
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromRGBO(63, 193, 201, 1),
          centerTitle: true,
          title: Text(widget.title),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/icons/sunIsUp_white.png',
                fit: BoxFit.cover),
          )),
      body: FutureBuilder<List<All_weather>>(
          future: getAllMeteoInDatabase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text("Chargement en cours ... "));
            } else if (snapshot.connectionState == ConnectionState.done) {
              meteoWallpaper =
                  "assets/wallpapers/${snapshot.data![0].meteo.weather![0].main}.jpg";
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(meteoWallpaper),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height,
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
                          getWeatherWallpaper(
                              snapshot.data![0].meteo.weather![0].main);
                          final All_weather item =
                              snapshot.data!.removeAt(oldIndex);
                          snapshot.data!.insert(newIndex, item);
                        });
                      },
                    )),
              );
            } else {
              return const Text("Une erreur est survenue");
            }
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(63, 193, 201, 1),
        onPressed: () => {},
        tooltip: 'add city',
        child: const Icon(Icons.add),
      ),
    );
  }
}
