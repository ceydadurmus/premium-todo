import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Premium Todo',
      debugShowCheckedModeBanner: false,
      
      // Premium Koyu Temamız
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8B5CF6), // Neon Mor
          secondary: Color(0xFF3B82F6), // Neon Mavi
          surface: Color(0xFF1E293B), // Slate 800
          background: Color(0xFF0F172A),
        ),
        
        // Font stili
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Roboto'),
          bodyMedium: TextStyle(fontFamily: 'Roboto'),
        ),
      ),
      
      home: const HomeScreen(),
    );
  }
}
