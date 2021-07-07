import 'dart:convert';
import 'package:auction_ui3/views/home.dart';
import 'package:auction_ui3/views/listings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  String userch = 'user';
  String passch = 'pass';

  // List<dynamic> users = [];

  // Future loginRequest(String username, String password) async {
  //   var res = await http.post(Uri.parse('http://localhost:8000/api/login'),
  //       headers: <String, String>{'Content-Type': 'application/json'},
  //       body: jsonEncode(
  //           <String, String>{'username': username, 'password': password}));

  //   if (res.statusCode == 203) {
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => Listings()));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // THIS IS THE APPBAR
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.teal[900],
          shadowColor: Colors.white,
          flexibleSpace: Center(
            child: Text(
              "KeiBai",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 50),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Login',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 80)),
            SizedBox(
              width: 700,
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _username,
                  decoration: InputDecoration(hintText: 'Username'),
                ),
              ),
            ),
            SizedBox(
              width: 700,
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _password,
                  decoration: InputDecoration(hintText: 'Password'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: ElevatedButton(
                  onPressed: () async {
                    print('Login request sent');
                    if (_username.text == userch && _password.text == passch) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool('status', true);
                      prefs.setString('user', _username.text);

                      //  REROUTING TO HOMEPAGE
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    }
                    // loginRequest(_username.text, _password.text);
                  },
                  child: Text('Login', style: TextStyle(fontSize: 20))),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: ElevatedButton(
                  onPressed: () {
                    print('guest logged in');
                    //  REROUTING TO HOMEPAGE
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  }
                  // loginRequest(_username.text, _password.text);
                  ,
                  child:
                      Text('Login as Guest', style: TextStyle(fontSize: 20))),
            ),
            // FOOTER
            Expanded(child: Text('')),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.teal[300],
              child: Center(
                child: Text(
                  'KeiBai Inc.',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
