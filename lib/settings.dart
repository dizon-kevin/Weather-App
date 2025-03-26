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

