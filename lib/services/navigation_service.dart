import 'package:flutter/material.dart';
import 'package:grammatika/screens/settings/settings_page.dart';
import 'package:grammatika/screens/statistics/statistics_page.dart';

class NavigationService {
  Future<T?> pushSettingsPage<T>(BuildContext context) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const SettingsPage();
        },
      ),
    );
  }

  Future<T?> pushStatisticsPage<T>(BuildContext context) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const StatisticsPage();
        },
      ),
    );
  }
}
