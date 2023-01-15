import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'coinCard.dart';
import 'coinModel.dart';
import 'first_layer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Coin>> fetchCoin() async {
    coinList = [];
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false'));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = json.decode(response.body);
      if (values.length > 0) {
        for (int i = 0; i < 10; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            coinList.add(Coin.fromJson(map));
          }
        }
        setState(() {
          coinList;
        });
      }

      return coinList;
    } else {
      throw Exception('Failed to load coins');
    }
  }

  firstClass? _firstClass;

  Future<void> _incrementCounter() async {
    String adres = "https://api.btcturk.com/api/v2/ticker";

    final response = await http.get(Uri.parse(adres));
    setState(() {});
    if (response.statusCode == 200) {
      Map gelenJson = jsonDecode(response.body);
      _firstClass = firstClass.fromJson(gelenJson);
      // _gelenCevap = gelenJson[""]
    } else {
      // _gelenCevap = [];
    }
  }

  @override
  void initState() {
    fetchCoin();
    _incrementCounter();
    Timer.periodic(Duration(seconds: 10), (timer) => fetchCoin());
    Timer.periodic(Duration(seconds: 10), (timer) => _incrementCounter());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.amber,
          centerTitle: true,
          title: Text(
            'İzzet Baba Sen Çok Yaşa!',
            style: TextStyle(
              color: Colors.grey[900],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: coinList.length,
          itemBuilder: (context, index) {
            return CoinCard(
              name: coinList[index].name,
              symbol: coinList[index].symbol,
              imageUrl: coinList[index].imageUrl,
              price: coinList[index].price.toDouble() *
                  _firstClass!.data[5].average,
              change: coinList[index].change.toDouble(),
              changePercentage: coinList[index].changePercentage.toDouble(),
            );
          },
        ));
  }
}
