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
                          Expanded(child: TextField(controller: _searchText)),
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
                        TextButton(
                            onPressed: () {
                              print('pressed register');
                            },
                            child: Text('Register',
                                style: TextStyle(color: Colors.black))),
                        TextButton(
                            onPressed: () {
                              print('pressed login');
                            },
                            child: Text('Login',
                                style: TextStyle(color: Colors.black))),
                      ],
                    )
                  ],
                ),
              ),
              // THIS IS THE END OF NAVBAR AND START OF THE BODY
              Container(
                  margin: EdgeInsets.only(top: 20),
                  width: 700,
                  height: 400,
                  color: Colors.white,
                  child: Text('Just one word to describe us.\nSigma',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 80))),
            ],
          ),
        ),
      ),
    );
  }
}
