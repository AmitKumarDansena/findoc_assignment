import 'package:flutter/material.dart';
import '../screens/login_screen.dart'; // Adjust import path if needed
import '../screens/home_screen.dart';  // Adjust import path if needed

/// A class to manage application route names.
///
/// Using constants helps avoid typos when referencing routes.
abstract class AppRoutes {
  /// Route name for the Login screen.
  static const String login = '/';

  /// Route name for the Home screen.
  static const String home = '/home';

  /// Generates the map of routes for the MaterialApp.
  ///
  /// This map associates route names with their corresponding widget builders.
  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginScreen(),
      home: (context) => const HomeScreen(),
      // Add more routes here as your app grows
      // '/profile': (context) => const ProfileScreen(),
    };
  }

  /// Performs a fade transition when navigating between pages.
  ///
  /// This static method can be used with [Navigator.push] or [Navigator.pushNamed]
  /// to apply a consistent fade transition.
  static Route<void> fadeTransitionRouteBuilder(
    RouteSettings settings,
    WidgetBuilder builder,
  ) {
    return PageRouteBuilder<void>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Fade transition
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 500), // Duration of the fade
    );
  }
}