import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunisup/views/Home.dart';
import '../db/City.dart';
import '../models/City.dart';

class Modal extends StatefulWidget {
  @override
  State<Modal> createState() => _buildPopupDialogState();
}

class _buildPopupDialogState extends State<Modal> {
  late SharedPreferences prefs;
  String libelle = '';

  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 200,
                color: Color.fromARGB(255, 255, 255, 255),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        initialValue: libelle,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Ville',
                        ),
                        validator: (val) =>
                            val = "" 'veuiller saisir un nom de ville',
                        onChanged: (val) => libelle = val,
                        obscureText: false,
                      ),
                      InfoButton(),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  Widget InfoButton() {
    return ElevatedButton(
      onPressed: addCity,
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(Color.fromARGB(255, 0, 0, 0))),
      child: const Text('Enregistrer'),
    );
  }

  Future addCity() async {
    String Libelle = libelle;

    await CityDatabase.instance.CreateCity(libelle);
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const Home(title: "SunIsUp")),
    );
  }
}
