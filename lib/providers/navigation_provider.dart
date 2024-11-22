import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Sayfa Geçişi için Navigation Provider'ı
final navigationProvider = StateNotifierProvider<NavigationNotifier, NavigatorState>((ref) {
  return NavigationNotifier();
});

class NavigationNotifier extends StateNotifier<NavigatorState> {
  NavigationNotifier() : super(NavigatorState());

  // Sayfaya gitmek için metot
  void pushReplacement(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
