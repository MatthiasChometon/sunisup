import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MeteoPanel extends StatefulWidget {

  const MeteoPanel(
      {Key? key, required this.temp, required this.humidity, required this.deg})
      : super(key: key);

  final String temp;
  final String humidity;
  final String deg;

  @override
  _MeteoPanelState createState() {
    return _MeteoPanelState();
  }
}


class _MeteoPanelState extends State<MeteoPanel> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        const Icon(
          Icons.thermostat,
          color: Colors.black,
          size: 24.0,
        ),
        Text(
          "${widget.temp}°",
          style: const TextStyle(color: Colors.black),
        ),
      ]),
      Row(children: [
        const Icon(
          Icons.water_outlined,
          color: Colors.black,
          size: 24.0,
        ),
        Text(
          "${widget.humidity}%",
          style: const TextStyle(color: Colors.black),
        ),
      ]),
      Row(children: [
        const Icon(
          CupertinoIcons.wind,
          color: Colors.black,
          size: 24.0,
        ),
        Text(
          "${widget.deg}km/h",
          style: const TextStyle(color: Colors.black),
        ),
      ])
    ], crossAxisAlignment: CrossAxisAlignment.start);
  }
}
