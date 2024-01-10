import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:government_services/home/home_provider.dart';
import 'package:government_services/home/home_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NetProvider(),
        )
      ],
      builder: (context, child) => MaterialApp(
        title: "Hello",
        home: HomePage(),
      ),
    );
  }
}
