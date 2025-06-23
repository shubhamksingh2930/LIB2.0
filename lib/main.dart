import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Import your newly created splash screen
import 'package:firebase_core/firebase_core.dart'; // <<< 1. IMPORT FIREBASE CORE
import 'firebase_options.dart'; // <<< 2. IMPORT GENERATED OPTIONS FILE

void main() async { // <<< 3. MAKE main FUNCTION ASYNC
  WidgetsFlutterBinding.ensureInitialized(); // <<< 4. ENSURE WIDGETS ARE INITIALIZED
  await Firebase.initializeApp( // <<< 5. INITIALIZE FIREBASE (AWAIT IT)
    options: DefaultFirebaseOptions.currentPlatform, // Uses the generated firebase_options.dart
  );
  runApp(const MyApp()); // Your existing MyApp widget
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seat Booking App', // App title
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // Updated theme color
        useMaterial3: true,
         appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple, // Consistent AppBar color
          foregroundColor: Colors.white, // Text/icon color on AppBar
          elevation: 2.0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple, // Button color
            foregroundColor: Colors.white, // Text color on button
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            )
          ),
        ),
        inputDecorationTheme: InputDecorationTheme( // Consistent text field style
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.deepPurple.shade300, width: 2.0),
          ),
          floatingLabelStyle: TextStyle(color: Colors.deepPurple.shade700),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // Start with SplashScreen
    );
  }
}