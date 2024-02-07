import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/theme_provider.dart';
import 'package:weather_app/weather_screen.dart'; // Import your ThemeProvider class

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: themeProvider.themeMode, // Use the theme mode from ThemeProvider
      home: WeatherScreen(),
    );
  }
}
