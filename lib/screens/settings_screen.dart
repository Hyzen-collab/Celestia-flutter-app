import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider package for state management
import '../providers/theme_provider.dart'; // Import ThemeProvider to manage theme and font scaling

// SettingsScreen is StatelessWidget because it relies on Provider
// instead of managing its own internal state
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /*
      Access ThemeProvider using Provider.of

      This allows the UI to react to:
      - Theme changes (dark/light mode)
      - Font size scaling
    */
    final theme = Provider.of<ThemeProvider>(context);

    /*
      Convert the numeric textScale value into a readable label
      for displaying in the dropdown UI. (Determine selected font size from provider)
    */
    String currentFontSize;
    if (theme.textScale == 0.8) {
      currentFontSize = "Small";
    } else if (theme.textScale == 1.3) {
      currentFontSize = "Large";
    } else {
      currentFontSize = "Medium";
    }

    return Scaffold(
      // App bar title
      appBar: AppBar(title: const Text("Settings")),

      // Scrollable list of settings options
      body: ListView(
        children: [
          // APPEARENCE
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Appearance",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          /*
            Switch to toggle dark mode.

            - value checks if current theme is dark
            - onChanged calls provider method to update theme
          */
          SwitchListTile(
            title: const Text("Dark Mode"),
            subtitle: const Text("Enable dark theme"),
            value: theme.themeMode == ThemeMode.dark,
            onChanged: (value) {
              theme.toggleTheme(value);
            },
          ),

          /*
            Dropdown to select font size.

            - Displays current font size
            - Updates provider when user selects a new value
          */
          ListTile(
            title: const Text("Font Size"),
            subtitle: Text(currentFontSize),
            trailing: DropdownButton<String>(
              value: currentFontSize,
              items: const [
                DropdownMenuItem(value: "Small", child: Text("Small")),
                DropdownMenuItem(value: "Medium", child: Text("Medium")),
                DropdownMenuItem(value: "Large", child: Text("Large")),
              ],
              onChanged: (value) {
                if (value != null) {
                  // Update font size globally using provider
                  theme.changeFontSize(value);
                }
              },
            ),
          ),

          const Divider(),

          // ABOUT
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text("About", style: TextStyle(fontWeight: FontWeight.bold)),
          ),

          /*
            About dialog popup
            Displays app description when user taps the tile
          */
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About App"),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const AlertDialog(
                  title: Text("NASA Explorer"),
                  content: Text(
                    "NASA Explorer is a student Flutter application that "
                    "uses NASA public APIs to show space news, images, "
                    "missions, and asteroid information.",
                  ),
                ),
              );
            },
          ),

          //Static information about myself
          const ListTile(
            leading: Icon(Icons.code),
            title: Text("Developer"),
            subtitle: Text("Idusha Piumika"),
          ),

          //App version information
          const ListTile(
            leading: Icon(Icons.update),
            title: Text("App Version"),
            subtitle: Text("v1.0.0"),
          ),
        ],
      ),
    );
  }
}
