import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                  decoration: InputDecoration(hintText: 'Username'),
                ),
              ),
            ),
            SizedBox(
              width: 700,
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  decoration: InputDecoration(hintText: 'Password'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: ElevatedButton(
                  onPressed: () {
                    print('Login request sent');
                  },
                  child: Text('Login', style: TextStyle(fontSize: 20))),
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
