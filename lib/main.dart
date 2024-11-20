import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:piton_books/providers/api_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  setupDependencies();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('tr')],
      path: 'assets/translations', // Dil dosyalarının yolu
      fallbackLocale: Locale('en'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Catalog',
      home: MainScreen(), // Ana ekran olarak yeni bir widget tanımlandı
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Catalog".tr()), // Çoklu dil desteği
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              // Dil değiştirme işlemi
              if (context.locale == Locale('en')) {
                context.setLocale(Locale('tr'));
              } else {
                context.setLocale(Locale('en'));
              }
            },
          ),
        ],
      ),
      body: SplashScreen(), // SplashScreen burada çağrılıyor
    );
  }
}
