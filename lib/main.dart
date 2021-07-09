import 'package:auction_ui3/views/home.dart';
import 'package:auction_ui3/views/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var status = prefs.getBool('status');
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'KeiBai',
    theme: ThemeData(
      primarySwatch: Colors.teal,
    ),
    home: (status == null || status == false) ? Login() : HomePage(),
  ));
}
