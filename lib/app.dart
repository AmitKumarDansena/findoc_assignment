import 'package:flutter/material.dart';
import 'routes/app_routes.dart'; // Import the AppRoutes class

/// The main application widget.
///
/// Configures the global app theme and routing.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp].
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Findoc Assignment',
      theme: ThemeData(
        // Set the default font family for the entire app.
        fontFamily: 'Montserrat',
        // Define the primary color scheme.
        primarySwatch: Colors.blue,
        // You can add more global theme customizations here if needed.
      ),
      
      // --- Named Routing Setup ---
      
      // Define the named routes using the map from AppRoutes.
      routes: AppRoutes.routes,

      // Set the initial route. This should correspond to a key in the `routes` map.
      // Using the constant ensures consistency.
      initialRoute: AppRoutes.login,

      // --- Optional: Global Transition Control ---
      // Uncomment the `onGenerateRoute` section below if you want ALL named
      // route navigations (e.g., Navigator.pushNamed) to automatically use
      // the fade transition defined in AppRoutes.
      //
      // If you prefer to control transitions individually (like in login_screen.dart),
      // you can leave this commented out or remove it.
      //
      /*
      onGenerateRoute: (settings) {
        // Attempt to find a builder for the requested route name.
        final WidgetBuilder? pageBuilder = AppRoutes.routes[settings.name];
        if (pageBuilder != null) {
          // If a builder exists, use the custom fade transition.
          return AppRoutes.fadeTransitionRouteBuilder(settings, pageBuilder);
        }
        // If no route is found, return null to let MaterialApp handle it,
        // potentially falling back to the 'home' property (if set) or showing an error.
        // In this setup, 'routes' map should cover all defined named routes.
        return null;
      },
      */

      // Optional: Remove the debug banner in release mode or always.
      debugShowCheckedModeBanner: false,
    );
  }
}