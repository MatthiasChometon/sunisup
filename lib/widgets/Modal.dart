import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/City.dart';
import '../models/City.dart';

class buildPopupDialog extends StatefulWidget {
  @override
  State<buildPopupDialog> createState() => _buildPopupDialogState();
}

class _buildPopupDialogState extends State<buildPopupDialog> {
  late SharedPreferences prefs;
  String libelle = '';

  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text("+"),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 200,
                color: Colors.yellow,
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
                        obscureText: true,
                      ),
                      InfoButton(),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget InfoButton() {
    return ElevatedButton(
      onPressed:  addCity,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
      child: const Text('Enregistrer'),
    );
  }

  

  Future addCity() async {
    String Libelle = libelle;

    await CityDatabase.instance.CreateCity(libelle);
  }
}
