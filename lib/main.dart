import 'package:flutter/material.dart';
import 'package:qr_reader_app/src/pages/about_page.dart';
import 'package:qr_reader_app/src/pages/home_page.dart';
import 'package:qr_reader_app/src/pages/map_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Escaner QR',
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => HomePage(),
        'map': (BuildContext context) => MapPage(),
        'about': (BuildContext context) => AboutPage(),
      },
      theme: ThemeData(primaryColor: Color.fromRGBO(0, 92, 167, 1.0)),
    );
  }
}
