import 'dart:ui'; // Import dart UI library for visual effects like blur
import 'package:flutter/material.dart'; // Import Flutter material components

// Import Flutter material components
import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/favourites_screen.dart';
import '../screens/settings_screen.dart';

// BottomNav is a StatefulWidget because it needs to manage
// the currently selected tab index dynamically
class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  // Stores the index of the currently selected tab
  int index = 0;

  /*
    List of screens corresponding to each bottom navigation tab.

    The index of this list matches the BottomNavigationBar index:
    0 -> Home
    1 -> Search
    2 -> Favourites
    3 -> Settings
  */
  final screens = const [
    HomeScreen(),
    SearchScreen(),
    FavouritesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
        The body dynamically changes depending on the selected index.
        When a user taps a tab, the corresponding screen is displayed.
      */
      body: screens[index],

      /*
        Bottom navigation bar wrapped in ClipRect + BackdropFilter
        to create a blur (glassmorphism) effect.
      */
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          // Applies a blur effect to the background
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: BottomNavigationBar(
            // Semi-transparent background for glass effect
            backgroundColor: Colors.black.withOpacity(0.3),

            // Color of the selected icon/text
            selectedItemColor: Colors.purpleAccent,

            // Color of unselected icons/text
            unselectedItemColor: Colors.white70,

            // Current active tab index
            currentIndex: index,

            /*
              When a tab is tapped:
              - Update the index
              - Rebuild UI to show the selected screen
            */
            onTap: (i) => setState(() => index = i),

            // Ensures all labels are visible
            type: BottomNavigationBarType.fixed,

            // Navigation items displayed in the bar
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Search",
              ),
              BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Fav"),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Settings",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
