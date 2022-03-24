import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:sunisup/models/all_weather.dart';
import 'package:sunisup/widgets/WeatherPanel.dart';

class MeteoPanelList extends StatefulWidget {
  const MeteoPanelList({Key? key, required this.weathers}) : super(key: key);

  final List<All_weather> weathers;

  @override
  _DatePanelState createState() {
    return _DatePanelState();
  }
}

class _DatePanelState extends State<MeteoPanelList> {
  @override
  Widget build(BuildContext context) {
    String meteoWallpaper =
        "assets/wallpapers/${widget.weathers[0].meteo.weather![0].main}.jpg";

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(meteoWallpaper),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ReorderableListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              children: <Widget>[
                for (int index = 0; index < widget.weathers.length; index += 1)
                  WeatherPanel(
                      key: Key('$index'),
                      meteo: widget.weathers[index].meteo,
                      forecastWeather: widget.weathers[index].forecastWeather,
                      city: widget.weathers[index].city)
              ],
              onReorder: (int oldIndex, int newIndex) {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                String? newMeteo = widget.weathers[0].meteo.weather![0].main;
                setState(() {
                  meteoWallpaper = "assets/wallpapers/$newMeteo.jpg";
                  final All_weather item = widget.weathers.removeAt(oldIndex);
                  widget.weathers.insert(newIndex, item);
                });
              },
            )),
      ),
    );
  }
}
