import 'dart:convert';
import 'package:auction_ui3/views/home.dart';
import 'package:auction_ui3/views/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Listings extends StatefulWidget {
  @override
  _ListingsState createState() => _ListingsState();
}

class _ListingsState extends State<Listings> {
  TextEditingController _searchText = TextEditingController();
  // NECESSARY DUMMY DATA
  List<String> testList = ['DUMMY DATA'];

  List<dynamic> respList = [];
  bool globalStatus = false;

  Future getAssets() async {
    Future.delayed(Duration(seconds: 2), () async {
      var res =
          await http.get(Uri.parse('http://localhost:8000/api/get-assets'));
      var decode = jsonDecode(res.body);
      setState(() {
        respList = decode;
      });
      print(respList);
    });
  }

  Future checkStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var localStatus = prefs.getBool('status');
    print('$localStatus');
    if (localStatus == true) {
      setState(() {
        globalStatus = true;
      });
    }
  }

  bool bidStatusCalculater(String close) {
    var closeParsed = DateTime.parse(close);
    var dateTimeNow = DateTime.now();
    if (dateTimeNow.isAfter(closeParsed)) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    getAssets();
    checkStatus();
    super.initState();
  }

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
            child: GestureDetector(
              onTap: () {
                getAssets();
              },
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
      ),
      body: Column(
        children: <Widget>[
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
                      padding: const EdgeInsets.only(right: 20),
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                            print('pressed home');
                          },
                          child: Text('Home',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20))),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: respList.isEmpty ? testList.length : respList.length,
                itemBuilder: (context, index) {
                  // ASSET CARD
                  return (respList.isEmpty)
                      ? Center(child: CircularProgressIndicator())
                      : GestureDetector(
                          onTap: () {
                            globalStatus
                                ? showAlertDialogBoxUser(
                                    context, respList[index]['status'])
                                : showAlertDialogBoxGuest(context);
                          },
                          child: Card(
                              elevation: 5,
                              child: Column(children: [
                                // ASSET NAME BOX
                                SizedBox(
                                  height: 30,
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                      child: Text('Asset Name: ' +
                                          respList[index]['name'])),
                                ),
                                // BID PRICE BOX
                                SizedBox(
                                  height: 30,
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                      child: Text('Minimum Bid Price: ' +
                                          respList[index]['minimumBid']
                                              .toString())),
                                ),
                                // OPENING AND CLOSING DATE ROW-COLUMN
                                SizedBox(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Center(
                                              child: Column(
                                        children: [
                                          Text('Opening Date'),
                                          Text(respList[index]['openingDate']
                                                  ['day'] +
                                              ' ' +
                                              respList[index]['openingDate']
                                                  ['time'])
                                        ],
                                      ))),
                                      Expanded(
                                          child: Center(
                                              child: Column(
                                        children: [
                                          Text('Closing Date'),
                                          Text(respList[index]['closingDate']
                                                  ['day'] +
                                              ' ' +
                                              respList[index]['closingDate']
                                                  ['time'])
                                        ],
                                      ))),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                  width: MediaQuery.of(context).size.width,
                                  child: respList[index]['status']
                                      ? Center(child: Text('Bidding Open'))
                                      : Center(child: Text('Bidding Closed')),
                                )
                              ])),
                        );
                }),
          ),
          // FOOTER
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
    );
  }
}

showAlertDialogBoxGuest(BuildContext context) {
  Widget submit = ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      },
      child: Text("Go to Login"));

  AlertDialog alert = AlertDialog(
    title: Text('Login Required'),
    content: Text('Please login in order to start bidding'),
    actions: [submit],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}

showAlertDialogBoxUser(BuildContext context, bool status) {
  Widget submit = TextButton(
      onPressed: () {
        if (status) {
          // POST A REQUEST TO PLACE BID
          print('bid placed');
        } else {
          Navigator.pop(context);
        }
      },
      child: status ? Text("Submit") : Text("OK"));

  AlertDialog alert = AlertDialog(
    title: status ? Text('Enter your Bid') : Text('Closed'),
    content:
        status ? TextField() : Text('Bidding for this item is now closed.'),
    actions: [submit],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}
