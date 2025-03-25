import 'package:flutter/cupertino.dart';
import 'package:/http/http.dart' as http;

void main()=> runApp(CupertinoApp(home: MyApp(),));

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String url = "";

  Future<void> getData() async {
    final response = await http.get(
      Uri.parse(url),
    );

    print(response.body);
  }
  @override

  @override
  void initState() {
    getData();
    super.initState();
  }
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(child: SafeArea(child: Column(
      children: [
        Text('Test')
      ],
    )));
  }
}
