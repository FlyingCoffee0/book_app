import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'login_screen.dart';
import '../providers/navigation_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        ref.read(navigationProvider.notifier).pushReplacement(
          context,
          LoginScreen(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 3, 3, 63),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Uygulama logosu
          Center(
            child: Image.asset(
              'assets/logo.png',
              width: 120,
              height: 120,
            ),
          ),
          SizedBox(height: 250),
          // Login düğmesi
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: ElevatedButton(
              onPressed: () {
                // Ensure the widget is still mounted before navigating
                if (mounted) {
                  ref.read(navigationProvider.notifier).pushReplacement(
                    context,
                    LoginScreen(),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF6F61),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 80),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Skip butonu
          TextButton(
            onPressed: () {
              // Ensure the widget is still mounted before navigating
              if (mounted) {
                ref.read(navigationProvider.notifier).pushReplacement(
                  context,
                  LoginScreen(),
                );
              }
            },
            child: Text(
              "Skip",
              style: TextStyle(
                color: Color(0xFF6251DD),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
