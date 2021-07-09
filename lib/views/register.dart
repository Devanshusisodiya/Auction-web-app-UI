import 'dart:convert';
import 'package:auction_ui3/views/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

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
            Text('Register',
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
                  obscureText: true,
                  controller: _password,
                  decoration: InputDecoration(hintText: 'Password'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: ElevatedButton(
                  onPressed: () async {
                    var res = await http.post(
                        Uri.parse('http://localhost:8000/api/reg/user'),
                        headers: <String, String>{
                          'Content-Type': 'application/json'
                        },
                        body: jsonEncode(<String, dynamic>{
                          'username': _username.text,
                          'password': _password.text
                        }));
                    if (res.statusCode == 201) {
                      _username.clear();
                      _password.clear();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                      print('register request sent');
                    } else {
                      _username.clear();
                      _password.clear();
                      print(res.body);
                    }
                  },
                  child: Text('Register', style: TextStyle(fontSize: 20))),
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
