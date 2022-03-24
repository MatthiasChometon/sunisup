import 'package:flutter/material.dart';
import 'package:sunisup/views/Home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sun Is Up',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: 0.8,
              fontSizeDelta: 2.0,
            ),
      ),
      home: const Home(title: 'Sun Is Up'),
    );
  }
}
