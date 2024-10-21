import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'configure/settings-page.dart';
import 'configure/theme_manager.dart'; // Altere para importar ThemeManager
import 'login/login_page.dart';
import 'login/register_page.dart';
import 'menu/home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeManager()), // Use ThemeManager aqui
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context); // Use ThemeManager

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        brightness: themeManager.isDarkTheme ? Brightness.dark : Brightness.light, // Alterna o tema
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: LoginPage.tag,
      routes: {
        LoginPage.tag: (context) => const LoginPage(),
        RegisterPage.tag: (context) => const RegisterPage(),
        SettingsPage.tag: (context) => const SettingsPage(),
        HomePage.tag: (context) => const HomePage(),
      },
    );
  }
}
