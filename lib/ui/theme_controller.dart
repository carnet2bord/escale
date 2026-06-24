import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Gère le mode de thème (clair / sombre / système) et le mémorise.
class ThemeController extends ChangeNotifier {
  static const _cle = 'mode_theme';
  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;
  bool get estSombre => _mode == ThemeMode.dark;

  Future<void> charger() async {
    final prefs = await SharedPreferences.getInstance();
    _mode = switch (prefs.getString(_cle)) {
      'clair' => ThemeMode.light,
      'sombre' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    notifyListeners();
  }

  Future<void> definir(ThemeMode mode) async {
    _mode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cle, switch (mode) {
      ThemeMode.light => 'clair',
      ThemeMode.dark => 'sombre',
      ThemeMode.system => 'systeme',
    });
  }

  Future<void> basculer() =>
      definir(estSombre ? ThemeMode.light : ThemeMode.dark);
}
