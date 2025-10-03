import 'package:shared_preferences/shared_preferences.dart';

import '../db/daos.dart';

class SettingsRepository {
  SettingsRepository({required this.dao});

  final SettingsDao dao;

  Future<bool> happyHour() => dao.happyHour();

  Future<void> toggleHappyHour(bool enabled) async {
    await dao.setHappyHour(enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('happyHour', enabled);
  }

  Future<String> city() => dao.city();

  Future<void> setCity(String value) => dao.setCity(value);

  Future<void> seedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('role')) {
      await prefs.setString('role', 'user');
    }
  }

  Future<String> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role') ?? 'user';
  }

  Future<void> setRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role);
  }
}
