import 'package:flutter/cupertino.dart';

class SettingsPage extends StatefulWidget {
  final String currentCity;
  final bool isMetric;
  final Function(String, bool) onSettingsChanged;

  SettingsPage({
    required this.currentCity,
    required this.isMetric,
    required this.onSettingsChanged,
  });

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String city;
  late bool isMetric;

   @override
  void initState() {
    super.initState();
    city = widget.currentCity;
    isMetric = widget.isMetric;
  }

  void updateSettings(String newCity, bool newMetric) {
    widget.onSettingsChanged(newCity, newMetric);
    setState(() {
      city = newCity;
      isMetric = newMetric;
    });
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.black,
        middle: Text("Settings", style: TextStyle(color: CupertinoColors.white)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            CupertinoListTile(
              title: Text("Location"),
              leading: Icon(CupertinoIcons.location),
              trailing: CupertinoButton(
                child: Text(city),
                onPressed: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) {
                      TextEditingController controller = TextEditingController(text: city);
                      return CupertinoAlertDialog(
                        title: Text("Enter Location"),
                        content: CupertinoTextField(
                          controller: controller,
                          onChanged: (value) {
                            city = value;
                          },
                        ),
                        actions: [
                          CupertinoDialogAction(
                            child: Text("Cancel"),
                            isDestructiveAction: true,
                            onPressed: () => Navigator.pop(context),
                          ),
                          CupertinoDialogAction(
                            child: Text("OK"),
                            onPressed: () {
                              updateSettings(city, isMetric);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            CupertinoListTile(
              title: Text("Temperature Unit"),
              leading: Icon(CupertinoIcons.thermometer),
              trailing: CupertinoSwitch(
                value: isMetric,
                onChanged: (value) {
                  updateSettings(city, value);
                },
              ),
              additionalInfo: Text(isMetric ? "Celsius" : "Fahrenheit"),
            ),
          ],
        ),
      ),
    );
  }
}



