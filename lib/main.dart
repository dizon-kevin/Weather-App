import 'dart:convert';
import 'settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

void main() => runApp(
  CupertinoApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ),
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String city = "Arayat"; // Default city
  double temp = 0.0;
  String humidity = "---";
  String feelsLike = "---";
  IconData? weatherIcon;
  bool isMetric = true; // Default to Celsius

  @override
  void initState() {
    super.initState();
    getData(city);
  }

  Future<void> getData(String newCity) async {
    final apiKey = "b2aa11fa10d2583b6a1651a3d1f6d391";
    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=$newCity&appid=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final weatherData = jsonDecode(response.body);
        setState(() {
          city = weatherData["name"];
          double kelvinTemp = weatherData["main"]["temp"];
          double kelvinFeelsLike = weatherData["main"]["feels_like"];
          temp = isMetric
              ? kelvinTemp - 273.15 // Celsius
              : (kelvinTemp - 273.15) * 9 / 5 + 32; // Fahrenheit

          humidity = weatherData["main"]["humidity"].toString();
          feelsLike = isMetric
              ? (kelvinFeelsLike - 273.15).toStringAsFixed(1) + "°C"
              : ((kelvinFeelsLike - 273.15) * 9 / 5 + 32).toStringAsFixed(1) +
              "°F";

          // Set weather icon
          String weatherCondition = weatherData["weather"][0]["main"];
          if (weatherCondition == "Clear") {
            weatherIcon = CupertinoIcons.sun_max;
          } else if (weatherCondition == "Clouds") {
            weatherIcon = CupertinoIcons.cloud;
          } else {
            weatherIcon = CupertinoIcons.cloud_rain;
          }
        });
      } else {
        showErrorDialog(newCity);
      }
    } catch (e) {
      showErrorDialog(newCity);
    }
  }
