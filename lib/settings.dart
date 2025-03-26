import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final String currentCity;
  final bool isMetric;
  final Color iconColor;
  final Function(String, bool, Color) onSettingsChanged;

  const SettingsPage({
    required this.currentCity,
    required this.isMetric,
    required this.iconColor,
    required this.onSettingsChanged,
    Key? key,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Color selectedColor; // Holds selected color
  late String city;
  late bool isMetric;

  @override
  void initState() {
    super.initState();
    city = widget.currentCity;
    isMetric = widget.isMetric;
    selectedColor = widget.iconColor;
  }

  void updateSettings(String newCity, bool newMetric) {
    widget.onSettingsChanged(newCity, newMetric, selectedColor);
    setState(() {
      city = newCity;
      isMetric = newMetric;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: CupertinoColors.black,
        middle: Text("Settings", style: TextStyle(color: CupertinoColors.white)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CupertinoListSection.insetGrouped(
            backgroundColor: CupertinoColors.black,
            children: [
              _buildTile(
                title: "Location",
                icon: CupertinoIcons.location,
                color: selectedColor,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      city,
                      style: const TextStyle(color: CupertinoColors.activeBlue),
                    ),
                    SizedBox(width: 5), // Adds spacing between text and icon
                    Icon(
                      CupertinoIcons.chevron_forward,
                      color: CupertinoColors.systemGrey,
                      size: 18, // Adjust the size if needed
                    ),
                  ],
                ),
                onTap: () => _showLocationDialog(),
              ),
              _buildTile(
                title: "Metric System",
                icon: CupertinoIcons.thermometer,
                color: selectedColor,
                trailing: CupertinoSwitch(
                  value: isMetric,
                  onChanged: (value) => updateSettings(city, value),
                ),
                additionalInfo: Text(isMetric ? "Celsius" : "Fahrenheit"),
              ),
              _buildTile(
                title: "Icon Color",
                icon: CupertinoIcons.paintbrush,
                color: selectedColor, // Display selected color
                trailing: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: selectedColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: CupertinoColors.white, width: 1),
                  ),
                ),
                onTap: _showColorPickerDialog, // Open color picker dialog
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile({
    required String title,
    required IconData icon,
    required Color color,
    Widget? trailing,
    Widget? additionalInfo,
    VoidCallback? onTap,
  }) {
    return CupertinoListTile(
      title: Text(title, style: const TextStyle(color: CupertinoColors.white)),
      leading: Container(
        width: 36, // Adjusted size
        height: 36,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: CupertinoColors.white, size: 22),
      ),
      trailing: trailing ?? const SizedBox.shrink(),
      subtitle: additionalInfo,
      onTap: onTap,
    );
  }
  void _showColorPickerDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text("Select Icon Color"),
        actions: [
          _colorOption(Colors.blue),
          _colorOption(Colors.red),
          _colorOption(Colors.green),
          _colorOption(Colors.purple),
          _colorOption(Colors.orange),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  CupertinoActionSheetAction _colorOption(Color color) {
    return CupertinoActionSheetAction(
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      onPressed: () {
        setState(() {
          selectedColor = color;
        });
        widget.onSettingsChanged(city, isMetric, selectedColor); // Update main.dart
        Navigator.pop(context);
      },
    );
  }

  void _showLocationDialog() {
    TextEditingController controller = TextEditingController(text: city);
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Enter Location"),
          content: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: CupertinoTextField(
              controller: controller,
              placeholder: "City name",
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text("Cancel"),
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              child: const Text("OK"),
              onPressed: () {
                updateSettings(controller.text, isMetric);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
