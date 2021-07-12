import 'dart:convert';
import 'package:auction_ui3/utils/api.dart';
import 'package:auction_ui3/views/home.dart';
import 'package:auction_ui3/views/listings.dart';
import 'package:auction_ui3/views/search_results.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BidPage extends StatefulWidget {
  const BidPage({Key? key}) : super(key: key);

  @override
  _BidPageState createState() => _BidPageState();
}

class _BidPageState extends State<BidPage> {
  List<dynamic> placed = [];
  List<dynamic> won = [];
  List<dynamic> subList = [];
  String userGlobal = '';

  getBidResults() {
    Future.delayed(Duration(seconds: 1), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = prefs.getString('user').toString();
      userGlobal = user;
      var res1 = await http.get(Uri.parse(APIRoutes.getBids + '$user'));
      var res2 = await http.get(Uri.parse(APIRoutes.results));
      var decode1 = jsonDecode(res1.body);
      var decode2 = jsonDecode(res2.body);

      for (var i in decode2) {
        if (i['winner'] == user) {
          subList.add(i);
        }
        setState(() {
          placed = decode1['result'];
          won = subList;
        });
      }
    });
  }

  getPrice(List<dynamic> list, String user) {
    var price;
    for (var i = 0; i < list.length; i++) {
      if (list[i]['name'] == user) {
        price = list[i]['price'];
      }
    }
    return price;
  }

  @override
  void initState() {
    getBidResults();
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Navbar(),
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Bids Placed',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 50),
                      ),
                      Text('Bids Won',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 50)),
                    ],
                  )),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: placed.isEmpty
                                ? LinearProgressIndicator()
                                : ListView.builder(
                                    itemCount: placed.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Card(
                                            elevation: 10,
                                            child: Column(
                                              children: [
                                                Center(
                                                    child: Text(
                                                  placed[index]['assetName'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 30),
                                                )),
                                                Center(
                                                    child: Text(
                                                        'your bid : ${getPrice(placed[index]['bidders'], userGlobal)}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20))),
                                              ],
                                            )),
                                      );
                                    }),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: won.isEmpty
                                ? LinearProgressIndicator()
                                : ListView.builder(
                                    itemCount: won.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                          child: Column(
                                        children: [
                                          Text(won[index]['name'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 30)),
                                          Text(
                                              'to pay : ${won[index]['price']}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20)),
                                        ],
                                      ));
                                    }),
                          ),
                        ])),
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
        ),
      ),
    );
  }
}

// NAVBAR CLASS
class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  TextEditingController _searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      var res = await http.get(
                          Uri.parse(APIRoutes.search + '${_searchText.text}'));
                      if (res.statusCode == 223) {
                        print(res.body);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SearchListings(initString: res.body)));
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
                padding: const EdgeInsets.only(right: 10),
                child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Listings()));
                      print('pressed listings');
                    },
                    child: Text('Listings',
                        style: TextStyle(color: Colors.black, fontSize: 20))),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: TextButton(
                    onPressed: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                      print('pressed logout');
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool('status', false);
                    },
                    child: Text("Logout",
                        style: TextStyle(color: Colors.black, fontSize: 20))),
              ),
            ],
          )
        ],
      ),
    );
  }
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
