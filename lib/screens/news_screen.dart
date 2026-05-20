import 'dart:convert'; // Import Dart convert library to decode JSON responses
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import HTTP package for API calls

import 'news_detail_screen.dart'; // Import the detail screen to navigate to when an item is tapped

// NewsScreen is StatelessWidget because it uses FutureBuilder
// to handle asynchronous data fetching
class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  /*
    Function to fetch NASA news data from API.

    NOTE: In this implementation, the APOD API is reused
    as a simplified "news" source.
  */
  Future<Map<String, dynamic>> fetchNews() async {
    final res = await http.get(
      Uri.parse(
        "https://api.nasa.gov/planetary/apod?api_key=DEMO KEY", //API key goes here
      ),
    );

    // Decode JSON response into a Dart Map
    return jsonDecode(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar title
      appBar: AppBar(title: const Text("NASA News")),

      /*
        FutureBuilder handles asynchronous API calls.

        It rebuilds UI based on:
        - loading state
        - data availability
      */
      body: FutureBuilder(
        future: fetchNews(),
        builder: (context, snapshot) {
          // Show loading indicator while waiting for API response
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Extract data from snapshot
          final data = snapshot.data!;

          /*
            Display a single ListTile containing:
            - Image thumbnail
            - Title
            - Subtitle
          */
          return ListTile(
            // Display image from API
            leading: Image.network(data['url'], width: 80, fit: BoxFit.cover),

            // Title of the news/article
            title: Text(data['title']),

            // Subtitle hint
            subtitle: const Text("Tap to read"),

            /*
              Navigate to detail screen when tapped.

              Navigator.push is used to move to a new screen
              while keeping the current screen in the stack.
            */
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NewsDetailScreen(data: data)),
              );
            },
          );
        },
      ),
    );
  }
}
