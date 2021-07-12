import 'dart:convert';
import 'package:auction_ui3/views/home.dart';
import 'package:auction_ui3/views/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auction_ui3/utils/api.dart';

class SearchListings extends StatefulWidget {
  final String initString;
  SearchListings({Key? key, required this.initString}) : super(key: key);

  @override
  _SearchListingsState createState() => _SearchListingsState();
}

class _SearchListingsState extends State<SearchListings> {
  TextEditingController _searchText = TextEditingController();
  // NECESSARY DUMMY DATA
  List<String> testList = ['DUMMY DATA'];
  //
  bool globalStatus = false;
  var initList;

  @override
  void initState() {
    initList = jsonDecode(widget.initString);
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
                itemCount: initList.isEmpty ? testList.length : initList.length,
                itemBuilder: (context, index) {
                  // ASSET CARD
                  return (initList.isEmpty)
                      ? Center(child: CircularProgressIndicator())
                      : GestureDetector(
                          onTap: () {
                            globalStatus
                                ? showAlertDialogBoxUser(
                                    context,
                                    initList[index]['status'],
                                    initList[index]['minimumBid'],
                                    initList[index]['name'])
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
                                      initList[index]['name'],
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
                                                initList[index]['minimumBid']
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
                                                initList[index]['openingDate']
                                                        ['day'] +
                                                    ' ' +
                                                    initList[index]
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
                                                initList[index]['closingDate']
                                                        ['day'] +
                                                    ' ' +
                                                    initList[index]
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
                                    child: initList[index]['status']
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
            var res = await http.patch(Uri.parse(APIRoutes.patch),
                headers: <String, String>{'Content-Type': 'application/json'},
                body: jsonEncode(<String, dynamic>{
                  'assetName': assetName,
                  'bidder': user,
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
