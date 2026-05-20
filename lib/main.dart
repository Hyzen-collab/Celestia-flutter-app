import 'package:flutter/material.dart'; // Import Flutter material design package
import 'package:provider/provider.dart'; // Import Flutter material design package

// Import custom providers
import 'providers/theme_provider.dart';
import 'providers/favourites_provider.dart';

// Import initial screen (Splash Screen)
import 'splash_screen.dart';

void main() {
  /*
    Entry point of the Flutter application.

    MultiProvider is used to provide multiple state management objects
    across the entire app.

    This ensures that ThemeProvider and FavouritesProvider
    are accessible from any widget in the widget tree.
  */
  runApp(
    MultiProvider(
      providers: [
        // Provides theme related state (light/dark mode, text scale)
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        // Provides favourites list state management
        ChangeNotifierProvider(create: (_) => FavouritesProvider()),
      ],

      // Root widget of the application
      child: const CelestiaApp(),
    ),
  );
}

// Root widget of the application
class CelestiaApp extends StatelessWidget {
  const CelestiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    /*
      Access ThemeProvider using Provider.of

      This allows the app to dynamically respond to:
      - Theme changes (light/dark mode)
      - Text scaling adjustments
    */
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      // Disable debug banner in top-right corner
      debugShowCheckedModeBanner: false,

      // Application title
      title: "Celestia",

      /*
        themeMode controls which theme is active:
        - ThemeMode.light
        - ThemeMode.dark
        - ThemeMode.system
      */
      themeMode: themeProvider.themeMode,

      // Define light theme
      theme: ThemeData.light(),

      // Define light theme
      darkTheme: ThemeData.dark(),

      /*
        builder allows modification of the entire app UI.

        Here it is used to apply a global text scaling factor,
        so font sizes adjust consistently across the app.
      */
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith
          // Apply custom text scaling from ThemeProvider
          (
            textScaleFactor: themeProvider.textScale,
          ),

          // Render the rest of the app
          child: child!,
        );
      },

      // Render the rest of the app
      home: const SplashScreen(),
    );
  }
}
