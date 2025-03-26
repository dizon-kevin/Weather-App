import 'package:flutter/cupertino.dart';
import 'main.dart';

class SettingsPage extends StatefulWidget{
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<Map<String, dynamic>> settings = [
    {
      "title" : "Location",
      "leading" : CupertinoIcons.location,
      "trailing" : Icon(CupertinoIcons.chevron_forward),
      "additionalInfo" : "Rome",

    },
    {
      "title" : "Location",
      "leading" : CupertinoIcons.location,
    }
  ];
  bool isMetric = true; // Toggle for Celsius/Fahrenheit
  bool isDarkMode = false; // Toggle for Dark Mode
  String location = "Rome";

  void showLocationDialog() {

  }


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.black,
        middle: Text("Settings", style: TextStyle(color: CupertinoColors.white)),
      ),
        child: SafeArea(child: Padding(padding: EdgeInsets.all(20),
    child: Column(
      children: [
          Expanded(child: ListView.builder(
              itemCount: settings.length,
              itemBuilder: (context, int index){
                final item = settings[index];
                return CupertinoListTile(
                    title: Text(item['title']),
                    leading: Container(
                      decoration:
                        child: Icon(item['leading'])),
                    trailing: item['trailing'],
                    additionalInfo: item.containsKey('additionalInfo') ? Text(item['additionalInfo']) : null,

                );

          }))
      ],
    ),


    )));


  }
}