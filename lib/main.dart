import 'package:flutter/material.dart';
import 'authlogin_screen.dart';

void main() {
  // Kalau belum setup Firebase, jangan tambahkan Firebase.initializeApp() dulu biar gak error
  runApp(const MelajuApp());
}

class MelajuApp extends StatelessWidget {
  const MelajuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Melaju Car Shop',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFDF8F5),
        primaryColor: const Color(0xFFEF3F43),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginEmailScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Image.asset('assets/images/logo_melaju.png', width: 250),
        ),
      ),
    );
  }
}
