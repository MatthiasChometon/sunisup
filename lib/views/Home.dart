import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sunisup/models/all_weather.dart';
import 'package:sunisup/models/meteo.dart';
import 'package:sunisup/services/MeteoService.dart';
import 'package:sunisup/widgets/MeteoPanelList.dart';
import 'package:sunisup/widgets/WeatherPanel.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
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
              return MeteoPanelList(weathers: snapshot.data!);
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
