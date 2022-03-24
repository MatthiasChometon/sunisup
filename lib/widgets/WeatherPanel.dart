import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:sunisup/models/forecast_weather.dart';
import 'package:sunisup/models/meteo.dart';
import 'package:sunisup/widgets/DatePanel.dart';
import 'package:sunisup/widgets/MeteoPanel.dart';

class WeatherPanel extends StatefulWidget {
  const WeatherPanel(
      {Key? key, required this.meteo, required this.forecastWeather})
      : super(key: key);

  final Meteo meteo;
  final ForecastWeather forecastWeather;

  @override
  _WeatherPanelState createState() {
    return _WeatherPanelState();
  }
}

class _WeatherPanelState extends State<WeatherPanel> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: ExpansionPanelList(
            animationDuration: const Duration(milliseconds: 200),
            children: [
              ExpansionPanel(
                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    title: Row(
                      children: [
                        Column(children: [
                          Row(children: [
                            const Text('Paris', style: TextStyle(fontSize: 30)),
                            Image.network(widget.meteo.icon),
                          ]),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DatePanel(date: DateTime.now()),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MeteoPanel(
                                temp: "${widget.meteo.main!.temp}",
                                humidity: "${widget.meteo.main!.humidity}%",
                                deg: "${widget.meteo.wind!.deg}%"),
                          ),
                        ])
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  );
                },
                body: ListTile(
                    title: Column(children: [
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: widget.forecastWeather.list!.length,
                      itemBuilder: (context, i) {
                        return Row(
                          children: [
                            DatePanel(
                                date: DateTime.parse(
                                    widget.forecastWeather.list![i].dtTxt ??
                                        '')),
                            Image.network(widget.forecastWeather.list![i].icon),
                            Text(
                              "${widget.forecastWeather.list![i].main!.temp}°",
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.center,
                        );
                      })
                ])),
                isExpanded: _expanded,
                canTapOnHeader: true,
              ),
            ],
            expansionCallback: (panelIndex, isExpanded) {
              _expanded = !_expanded;
              setState(() {});
            },
          ),
        ));
  }
}
