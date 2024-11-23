import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'screens/splash_screen.dart';
import 'providers/navigation_provider.dart';  

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  
  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: [Locale('en'), Locale('tr')],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Navigator'ı yönetmek için global navigatorKey kullanma
    final navigatorKey = ref.watch(navigationProvider); 
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Catalog',
      navigatorKey: navigatorKey, 
      home: SplashScreen(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
