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
  bool loggedIn = true;
  TextEditingController _searchText = TextEditingController();
  //
  /// DUMMY DATA FOR TESTING
  //
  List<Map<dynamic, dynamic>> testList = [
    {
      'name': 'Asset 1',
      'minBid': '1200',
      'opening': <dynamic, dynamic>{'details': 'opening details'},
      'closing': <dynamic, dynamic>{'details': 'closing details'},
    },
  ];

  // List<dynamic> respList = [];

  // Future getAssets() async {
  //   var res = await http.get(Uri.parse('http://localhost:8000/api/get-assets'));
  //   var decode = jsonDecode(res.body);
  //   print(decode);
  // }

  bool globalStatus = false;

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

  @override
  void initState() {
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
                itemCount: testList.length,
                itemBuilder: (context, index) {
                  // ASSET CARD
                  return GestureDetector(
                    onTap: () {
                      globalStatus
                          ? showAlertDialogBoxUser(context)
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
                                child: Text(
                                    'Asset Name' + testList[index]['name'])),
                          ),
                          // BID PRICE BOX
                          SizedBox(
                            height: 30,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                                child: Text('Minimum Bid Price: ' +
                                    testList[index]['minBid'])),
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
                                    Text(testList[index]['opening']['details'])
                                  ],
                                ))),
                                Expanded(
                                    child: Center(
                                        child: Column(
                                  children: [
                                    Text('Closing Date'),
                                    Text(testList[index]['closing']['details'])
                                  ],
                                ))),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            width: MediaQuery.of(context).size.width,
                            child: Center(child: Text('Bidding Status')),
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

showAlertDialogBoxUser(BuildContext context) {
  Widget submit = ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        print(DateTime.now().toUtc());
      },
      child: Text("Submit"));

  AlertDialog alert = AlertDialog(
    title: Text('Enter your Bid'),
    content: TextField(),
    actions: [submit],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}
