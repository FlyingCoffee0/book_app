import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Sayfa Geçişi için Navigation Provider'ı
final navigationProvider = StateNotifierProvider<NavigationNotifier, GlobalKey<NavigatorState>>(
  (ref) => NavigationNotifier(),
);

class NavigationNotifier extends StateNotifier<GlobalKey<NavigatorState>> {
  NavigationNotifier() : super(GlobalKey<NavigatorState>());

  // Sayfaya gitmek için metot
  void pushReplacement(BuildContext context, Widget screen) {
    state.currentState?.pushReplacement(
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void push(BuildContext context, Widget screen) {
    state.currentState?.push(
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // Sayfadan çıkmak için metot
  void pop(BuildContext context) {
    state.currentState?.pop();
  }
}
