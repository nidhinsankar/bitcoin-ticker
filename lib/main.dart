import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'coin_dart.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bitcoin ticker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.lightBlue,
        accentColor: Colors.purple[900],
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String dropdownValue = 'USD';
  var bitcoinRate;
  @override
  void initState() {
    super.initState();
    getData(dropdownValue);
  }



  void getData(newValue) async {
    Response response = await get(Uri.parse(
        'https://rest.coinapi.io/v1/exchangerate/ETH/$newValue?apikey=A884BEA8-35EE-433B-9CB5-9615CF35B7CA'));

    if (response.statusCode == 200) {
      String data = response.body;

      var decodedData = jsonDecode(data);

      bitcoinRate = decodedData['rate'];
      print("Ethirium in $dropdownValue$newValue");
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    // getData();
    return Scaffold(
      appBar: AppBar(
        title: Text('bitcoin ticker'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  bitcoinRate.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey[900],
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            padding: EdgeInsets.only(bottom: 30.0),
            alignment: Alignment.center,
            color: Colors.lightBlue,
            child: DropdownButton<String>(
              value: dropdownValue,
              items:
                  currienciesList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              elevation: 10,
              onChanged: (newValue) {
                setState(() {
                  dropdownValue = newValue!;
                  getData(newValue);
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
