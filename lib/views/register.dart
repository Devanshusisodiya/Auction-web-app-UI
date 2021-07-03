import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // THIS IS THE APPBAR
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.teal[100],
          shadowColor: Colors.white,
          flexibleSpace: Center(
            child: Text(
              "KeiBai",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
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
                    print('register request sent');
                  },
                  child: Text('Register', style: TextStyle(fontSize: 20))),
            )
          ],
        ),
      ),
    );
  }
}
