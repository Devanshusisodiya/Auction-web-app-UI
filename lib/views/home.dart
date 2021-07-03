import 'package:auction_ui3/views/login.dart';
import 'package:auction_ui3/views/register.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchText = TextEditingController();

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
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //
              ///
              // THIS IS THE COMPLETE NAVBAR
              Container(
                height: 60,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // THIS IS THE LEFT SIDE OF THE NAVBAR
                    Container(
                        width: 500,
                        margin: EdgeInsets.only(left: 30),
                        child: Row(children: [
                          Expanded(
                              child: TextField(
                            controller: _searchText,
                            decoration: InputDecoration(hintText: 'Search...'),
                          )),
                          IconButton(
                              onPressed: () {
                                print(_searchText.text);
                                _searchText.clear();
                              },
                              icon: Icon(
                                Icons.search,
                                color: Colors.black,
                              ))
                        ])),
                    // THIS IS THE RIGHT SIDE OF NAVBAR
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Register()));
                                print('pressed register');
                              },
                              child: Text('Register',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
                                print('pressed login');
                              },
                              child: Text('Login',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20))),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              // THIS IS THE END OF NAVBAR AND START OF THE BODY
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text('Just one word,\nto describe us.\nSigma',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 80)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
