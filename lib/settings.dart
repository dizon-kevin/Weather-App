import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final String currentCity;
  final bool isMetric;
  final Color iconColor;
  final bool isLightMode;
  final Function(String, bool, Color, bool) onSettingsChanged;

  const SettingsPage({
    required this.currentCity,
    required this.isMetric,
    required this.iconColor,
    required this.isLightMode,
    required this.onSettingsChanged,
    Key? key,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Color selectedColor;
  late String city;
  late bool isMetric;
  late bool isLightMode;

  @override
  void initState() {
    super.initState();
    city = widget.currentCity;
    isMetric = widget.isMetric;
    selectedColor = widget.iconColor;
    isLightMode = widget.isLightMode;
  }

  void updateSettings(String newCity, bool newMetric) {
    widget.onSettingsChanged(newCity, newMetric, selectedColor, isLightMode);
    setState(() {
      city = newCity;
      isMetric = newMetric;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: isLightMode ? Brightness.light : Brightness.dark,
      ),
      home: CupertinoPageScaffold(
        backgroundColor: isLightMode ? CupertinoColors.white : CupertinoColors.black, // ✅ Background change
        navigationBar: CupertinoNavigationBar(
          backgroundColor: isLightMode ? CupertinoColors.systemGrey6 : CupertinoColors.black,
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(
              CupertinoIcons.chevron_back,
              color: isLightMode ? CupertinoColors.black : CupertinoColors.white, // ✅ Adjusts color dynamically
            ),
            onPressed: () => Navigator.pop(context), // ✅ Navigates back when pressed
          ),
          middle: Text(
            "Settings",
            style: TextStyle(
              color: isLightMode ? CupertinoColors.black : CupertinoColors.white,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CupertinoListSection.insetGrouped(
              backgroundColor: isLightMode ? CupertinoColors.systemGrey5 : CupertinoColors.black, // ✅ Dynamic change
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
                        style: TextStyle(
                          color: isLightMode ? CupertinoColors.activeBlue : CupertinoColors.white,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(CupertinoIcons.chevron_forward, color: CupertinoColors.systemGrey, size: 18),
                    ],
                  ),
                  onTap: _showLocationDialog,
                ),
                _buildTile(
                  title: "Metric System",
                  icon: CupertinoIcons.thermometer,
                  color: selectedColor,
                  trailing: CupertinoSwitch(
                    value: isMetric,
                    onChanged: (value) => updateSettings(city, value),
                  ),
                  additionalInfo: Text(
                    isMetric ? "Celsius" : "Fahrenheit",
                    style: TextStyle(
                      color: isLightMode ? CupertinoColors.black : CupertinoColors.white,
                    ),
                  ),
                ),
                _buildTile(
                  title: "Icon Color",
                  icon: CupertinoIcons.paintbrush,
                  color: selectedColor,
                  trailing: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: selectedColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isLightMode ? CupertinoColors.black : CupertinoColors.white,
                        width: 1,
                      ),
                    ),
                  ),
                  onTap: _showColorPickerDialog,
                ),
                _buildTile(
                  title: "Light Mode",
                  icon: CupertinoIcons.sun_max_fill,
                  color: isLightMode ? Colors.yellow : Colors.grey,
                  trailing: CupertinoSwitch(
                    value: isLightMode,
                    onChanged: (value) {
                      setState(() {
                        isLightMode = value;
                      });
                      widget.onSettingsChanged(city, isMetric, selectedColor, isLightMode);
                    },
                  ),
                ),
                _buildTile(
                  title: "Developers",
                  icon: CupertinoIcons.person_2_fill,
                  color: Colors.blue,
                  trailing: const Icon(CupertinoIcons.chevron_forward, color: CupertinoColors.systemGrey, size: 18),
                  onTap: _showDevelopersDialog,
                ),
              ],
            ),
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
      title: Text(
        title,
        style: TextStyle(
          color: isLightMode ? CupertinoColors.black : CupertinoColors.white, // ✅ Dynamic text color
        ),
      ),
      leading: Container(
        width: 36,
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
        widget.onSettingsChanged(city, isMetric, selectedColor, isLightMode);
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
  void _showDevelopersDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Developers"),
          content: Column(
            children: const [
              Text("• Cruz, John Eric"),
              Text("• Dizon, Kevin"),
              Text("• Juantas, Cris Gabriel"),
              Text("• Luriz, Jenzelle"),
              Text("• Macapagal, Marc Lawrence"),
              Text("• Venasquez, Charles Harold"),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
