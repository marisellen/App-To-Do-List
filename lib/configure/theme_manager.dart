import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier {
  bool _isDarkTheme = false; // Define o tema inicial como claro

  bool get isDarkTheme => _isDarkTheme; // Getter para verificar o estado do tema

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme; // Alterna o tema
    notifyListeners(); // Notifica os ouvintes sobre a mudança
  }
}

