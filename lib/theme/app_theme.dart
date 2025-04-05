import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
      surface: Colors.white,
      onSurface: Colors.black87,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardColor: Colors.white,
    shadowColor: Colors.grey.withOpacity(0.1),
    dividerColor: Colors.grey.withOpacity(0.2),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      titleMedium:
          TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
      labelLarge: TextStyle(color: Colors.blue),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: const ColorScheme.dark(
      primary: Colors.blue,
      secondary: Colors.lightBlue,
      surface: Color(0xFF1E1E1E),
      onSurface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardColor: const Color(0xFF1E1E1E),
    shadowColor: Colors.black.withOpacity(0.3),
    dividerColor: Colors.grey.withOpacity(0.2),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      labelLarge: TextStyle(color: Colors.lightBlue),
    ),
  );

  // Helper methods to access theme colors
  static Color backgroundColor(bool isDarkMode) {
    return isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
  }

  static Color cardColor(bool isDarkMode) {
    return isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
  }

  static Color textColor(bool isDarkMode) {
    return isDarkMode ? Colors.white : Colors.black87;
  }

  static Color subTextColor(bool isDarkMode) {
    return isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
  }

  static Color shadowColor(bool isDarkMode) {
    return isDarkMode
        ? Colors.black.withOpacity(0.3)
        : Colors.grey.withOpacity(0.1);
  }

  static Color inputBackgroundColor(bool isDarkMode) {
    return isDarkMode ? const Color(0xFF2C2C2C) : const Color(0xFFF5F5F5);
  }

  static Color priorityColor(int priority) {
    if (priority >= 4) return Colors.red;
    if (priority >= 2) return Colors.orange;
    return Colors.green;
  }

  static Color borderColor(bool isDarkMode) {
    return isDarkMode ? Colors.black : Colors.white;
  }
}
