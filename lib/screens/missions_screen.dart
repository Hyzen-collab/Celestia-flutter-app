import 'dart:convert'; // Import Dart convert library to decode JSON responses
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import HTTP package for API requests

// Import CachedNetworkImage for efficient image loading with caching
import 'package:cached_network_image/cached_network_image.dart';

import 'package:provider/provider.dart'; // Import Provider to access global state
import '../providers/favourites_provider.dart'; // Import FavouritesProvider to manage favourites
import 'news_detail_screen.dart'; // Import detail screen for navigation

// MissionsScreen is StatelessWidget because it relies on FutureBuilder
// for asynchronous data handling
class MissionsScreen extends StatelessWidget {
  const MissionsScreen({super.key});

  /*
    Function to fetch mission/news data from NASA API.

    Note:
    - The APOD API is used with the 'count' parameter to retrieve multiple items.
    - This acts as demo data for missions/news.
  */
  Future<List<Map<String, dynamic>>> fetchMissions() async {
    // Using NASA APOD API for demo news/mission data
    final res = await http.get(
      Uri.parse(
        "https://api.nasa.gov/planetary/apod?api_key=DEMO KEY", //API key goes here
      ),
    );

    // Convert JSON response into a List of Maps
    return List<Map<String, dynamic>>.from(jsonDecode(res.body));
  }

  @override
  Widget build(BuildContext context) {
    // Access global favourites provider
    final fav = Provider.of<FavouritesProvider>(context);

    return Scaffold(
      // App bar title
      appBar: AppBar(title: const Text("Missions & News")),

      /*
        FutureBuilder handles asynchronous data fetching.

        It updates UI based on:
        - loading state
        - data availability
      */
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchMissions(),
        builder: (context, snapshot) {
          // Show loading indicator while waiting for API response
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Extract list of mission/news items
          final dataList = snapshot.data!;

          /*
            ListView.builder efficiently renders a scrollable list
            by building items only when they are visible on screen
          */
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              final data = dataList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: ListTile(
                  /*
                    CachedNetworkImage improves performance by caching images
                    instead of downloading them repeatedly
                  */
                  leading: CachedNetworkImage(
                    imageUrl: data['url'],
                    width: 80,
                    fit: BoxFit.cover,
                  ),

                  // Title of the mission/news item
                  title: Text(data['title']),
                  subtitle: const Text("Tap to read"),

                  //Navigate to detailed view when user taps the item
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NewsDetailScreen(data: data),
                      ),
                    );
                  },

                  /*
                    Favourite toggle button

                    - Icon changes depending on whether item is saved
                    - Pressing it adds/removes from favourites provider
                  */
                  trailing: IconButton(
                    icon: Icon(
                      fav.isFavourite(data)
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                    onPressed: () {
                      fav.isFavourite(data)
                          ? fav.removeFavourite(data)
                          : fav.addFavourite(data);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
