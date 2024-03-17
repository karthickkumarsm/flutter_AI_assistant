import 'package:flutter/material.dart';
import 'package:marc/home_page.dart';
import 'package:marc/pallete.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Enola AI',
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor:Pallete.whiteColor,
        appBarTheme: AppBarTheme(
          backgroundColor: Pallete.whiteColor,
        )
      ),
      home: const HomePage(),
    );
  }
}

