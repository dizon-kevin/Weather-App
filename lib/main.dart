import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // For formatting time
import 'settings.dart';
import 'package:flutter/material.dart';

import 'settings.dart';

void main() => runApp(
      CupertinoApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
        theme: CupertinoThemeData(brightness: Brightness.dark),
      ),
    );

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String city = "Arayat"; // Default city
  String country = "---"; // Default country
  double temp = 0.0;
  String humidity = "---";
  String feelsLike = "---";
  String description = "---";
  double windSpeed = 0.0;
  int pressure = 0;
  int visibility = 0;
  String sunriseTime = "---";
  String sunsetTime = "---";
  IconData? weatherIcon;
  bool isMetric = true;
  Color iconColor = Colors.blue;
  bool isLightMode = false;



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
          country = weatherData["sys"]["country"]; // Get country code
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

          // Fetch additional weather details
          description = weatherData["weather"][0]["description"];
          windSpeed = weatherData["wind"]["speed"];
          pressure = weatherData["main"]["pressure"];
          visibility = weatherData["visibility"] ~/ 1000; // Convert to km

          // Format sunrise & sunset times
          sunriseTime = formatUnixTime(weatherData["sys"]["sunrise"]);
          sunsetTime = formatUnixTime(weatherData["sys"]["sunset"]);

          // Set weather icon
          String weatherCondition = weatherData["weather"][0]["main"];
          if (weatherCondition == "Clear") {
            weatherIcon = CupertinoIcons.sun_max;
          } else if (weatherCondition == "Clouds") {
            weatherIcon = CupertinoIcons.cloud;
          } else if (weatherCondition == "Rain") {
            weatherIcon = CupertinoIcons.cloud_rain;
          } else if (weatherCondition == "Snow") {
            weatherIcon = CupertinoIcons.snow;
          } else {
            weatherIcon = CupertinoIcons.cloud_bolt;
          }
        });
      } else {
        showErrorDialog(newCity);
      }
    } catch (e) {
      showErrorDialog(newCity);
    }
  }

  // Function to format Unix timestamp into a readable time
  String formatUnixTime(int timestamp) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat.jm().format(dateTime); // Formats as "hh:mm AM/PM"
  }

  void showErrorDialog(String invalidCity) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text("Invalid Location"),
        content: Text("The location '$invalidCity' is not valid. Please try again."),
        actions: [
          CupertinoDialogAction(
            child: Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void openSettings() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => SettingsPage(
          currentCity: city,
          isMetric: isMetric,
          iconColor: iconColor,
          isLightMode: isLightMode,
          onSettingsChanged: (newCity, newMetric, newColor, newTheme) {
            setState(() {
              isMetric = newMetric;
              iconColor = newColor;
              isLightMode = newTheme;
            });
            getData(newCity); // Only fetch data if city is valid
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
       debugShowCheckedModeBanner: false,
        theme: CupertinoThemeData(
        brightness: isLightMode ? Brightness.light : Brightness.dark,
    ),

      home : CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.black,
        middle: Text(
          "iWeather",
          style: TextStyle(color: CupertinoColors.white, fontSize: 18),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            CupertinoIcons.settings,
            size: 19,
            color: iconColor,
          ),
          onPressed: openSettings,
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 100),
              Text(
                "$city, $country", // Displays city and country
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100),
              ),
              Text(
                temp.toStringAsFixed(1) + (isMetric ? "°C" : "°F"),
                style: TextStyle(fontSize: 50),
              ),
              Icon(weatherIcon, color: iconColor, size: 90),
              SizedBox(height: 10),
              Text(
                description, // Displays weather condition
                style: TextStyle(
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                    color: CupertinoColors.systemGrey),
              ),
              SizedBox(height: 40),

              // Additional weather details
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Humidity: $humidity%"),
                      SizedBox(width: 20),
                      Text('Feels Like: $feelsLike')
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Wind Speed: ${windSpeed.toStringAsFixed(1)} m/s"),
                      SizedBox(width: 20),
                      Text("Pressure: $pressure hPa"),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("Visibility: $visibility km"),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sunrise: $sunriseTime"),
                      SizedBox(width: 20),
                      Text("Sunset: $sunsetTime"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
