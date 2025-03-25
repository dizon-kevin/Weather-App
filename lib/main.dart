import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;



void main()=> runApp(CupertinoApp(home: MyApp(),));

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> weatherData = {};

  String city = "";
  String temp = "";
  String url = "https://api.openweathermap.org/data/2.5/weather?q=Baguio&appid=b2aa11fa10d2583b6a1651a3d1f6d391";

  Future<void> getData() async {
    final response = await http.get(
      Uri.parse(url),
    );

    setState(() {
      weatherData = jsonDecode(response.body);
      city = weatherData["name"];
      temp = (weatherData["main"]["temp"] - 273.15).toStringAsFixed(1) + "°";

    });
    print(weatherData["main"]["temp"]);
  }
  @override

  @override
  void initState() {
    getData();
    super.initState();
  }
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(child: SafeArea(child: Center(
      child: Column(
        children: [
            SizedBox(height: 100,),
          Text('$city', style: TextStyle(fontSize: 50, fontWeight: FontWeight.w100),),
          Text(' $temp', style: TextStyle(fontSize: 20),),
          Icon(CupertinoIcons.sun_max, color: CupertinoColors.systemPurple, size: 90,),
          SizedBox(height: 50,),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Humidity: 86%"),
              SizedBox(width: 100,),
              Text('Feels Like: 40°')
            ],
          )
        ],
      ),
    )));
  }
}
