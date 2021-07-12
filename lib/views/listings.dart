import 'dart:convert';
import 'package:auction_ui3/views/home.dart';
import 'package:auction_ui3/views/login.dart';
import 'package:auction_ui3/views/search_results.dart';
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
  //
  List<dynamic> respList = [];
  bool globalStatus = false;

  void getAssets() {
    Future.delayed(Duration(seconds: 2), () async {
      var res = await http.get(
          Uri.parse('https://auction-server2.herokuapp.com/api/get-assets'));
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

  Future bidStatusCalculaterAndUpdater() async {
    var res = await http
        .get(Uri.parse('https://auction-server2.herokuapp.com/api/get-assets'));
    var decode = jsonDecode(res.body);

    // PARSING AND UPDATING DATES
    var dateTimeNow = DateTime.now();
    for (var i = 0; i < decode.length; i++) {
      var assetOpeningValidity = DateTime.parse(decode[i]['openingDate']
              ['day'] +
          ' ' +
          decode[i]['openingDate']['time']);
      var assetClosingValidity = DateTime.parse(decode[i]['closingDate']
              ['day'] +
          ' ' +
          decode[i]['closingDate']['time']);
      if (assetOpeningValidity.isBefore(dateTimeNow) &&
          assetClosingValidity.isAfter(dateTimeNow)) {
        if (decode[i]['status'] == false) {
          var statusRes = await http.patch(
              Uri.parse(
                  'https://auction-server2.herokuapp.com/api/patch-status'),
              headers: <String, String>{'Content-Type': 'application/json'},
              body: jsonEncode(<String, dynamic>{
                'assetName': decode[i]['name'],
                'status': true,
              }));
          print(statusRes.statusCode);
        }
      }
    }
  }

  @override
  void initState() {
    bidStatusCalculaterAndUpdater();
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
                          onPressed: () async {
                            var res = await http.get(Uri.parse(
                                'https://auction-server2.herokuapp.com/api/search/${_searchText.text}'));
                            if (res.statusCode == 223) {
                              print(res.body);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchListings(
                                          initString: res.body)));
                              _searchText.clear();
                            } else {
                              showAlertDialogBoxSearch(context, _searchText);
                            }
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
                                    context,
                                    respList[index]['status'],
                                    respList[index]['minimumBid'],
                                    respList[index]['name'])
                                : showAlertDialogBoxGuest(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Card(
                                elevation: 10,
                                child: Column(children: [
                                  // ASSET NAME BOX
                                  SizedBox(
                                    height: 30,
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                        child: Text(
                                      respList[index]['name'],
                                      style: TextStyle(fontSize: 25),
                                    )),
                                  ),
                                  // BID PRICE BOX
                                  SizedBox(
                                    height: 30,
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                        child: Text(
                                            'Minimum Bid Price - ' +
                                                respList[index]['minimumBid']
                                                    .toString(),
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold))),
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
                                            Text('Opening Date',
                                                style: TextStyle(fontSize: 20)),
                                            Text(
                                                respList[index]['openingDate']
                                                        ['day'] +
                                                    ' ' +
                                                    respList[index]
                                                        ['openingDate']['time'],
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ))),
                                        Expanded(
                                            child: Center(
                                                child: Column(
                                          children: [
                                            Text('Closing Date',
                                                style: TextStyle(fontSize: 20)),
                                            Text(
                                                respList[index]['closingDate']
                                                        ['day'] +
                                                    ' ' +
                                                    respList[index]
                                                        ['closingDate']['time'],
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ))),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    width: MediaQuery.of(context).size.width,
                                    child: respList[index]['status']
                                        ? Center(
                                            child: Text('Bidding Open',
                                                style: TextStyle(fontSize: 20)))
                                        : Center(
                                            child: Text('Bidding Closed',
                                                style:
                                                    TextStyle(fontSize: 20))),
                                  )
                                ])),
                          ),
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

showAlertDialogBoxPrice(BuildContext context) {
  Widget submit = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text("OK"));

  AlertDialog alert = AlertDialog(
    title: Text('Invalid Price'),
    content: Text('Please enter a price atleast equal to minimum price'),
    actions: [submit],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}

showAlertDialogBoxUser(
    BuildContext context, bool status, var minPrice, String assetName) {
  TextEditingController _bidController = TextEditingController();
  Widget submit = TextButton(
      onPressed: () async {
        if (status) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String user = prefs.getString('user').toString();
          // PATCHING A REQUEST TO PLACE BID
          if (int.parse(_bidController.text) >= minPrice) {
            var res = await http.patch(
                Uri.parse('https://auction-server2.herokuapp.com/api/patch'),
                headers: <String, String>{'Content-Type': 'application/json'},
                body: jsonEncode(<String, dynamic>{
                  'assetName': assetName,
                  'name': user,
                  'price': int.parse(_bidController.text)
                }));
            print(res.statusCode);
            Navigator.pop(context);
            print('bid placed');
          } else {
            print('bid not placed');
            showAlertDialogBoxPrice(context);
          }
        } else {
          Navigator.pop(context);
        }
      },
      child: status ? Text("Submit") : Text("OK"));

  AlertDialog alert = AlertDialog(
    title: status ? Text('Enter your Bid') : Text('Closed'),
    content: status
        ? TextField(
            controller: _bidController,
          )
        : Text('Bidding for this item is now closed.'),
    actions: [submit],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}

showAlertDialogBoxSearch(
    BuildContext context, TextEditingController controller) {
  Widget submit = ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        controller.clear();
      },
      child: Text("OK"));

  AlertDialog alert = AlertDialog(
    title: Text('Not Found'),
    content: Text('Sorry, there are no such assets.'),
    actions: [submit],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}
