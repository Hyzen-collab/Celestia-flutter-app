import 'dart:convert'; // Import Dart convert library to decode JSON data
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import HTTP package for API calls

// Import CachedNetworkImage for efficient image loading with caching
import 'package:cached_network_image/cached_network_image.dart';

import 'package:provider/provider.dart'; // Import Provider to access global state
import '../providers/favourites_provider.dart'; // Import FavouritesProvider to manage favourite items

// StatelessWidget is used because data is fetched asynchronously via FutureBuilder
class PictureOfDayScreen extends StatelessWidget {
  const PictureOfDayScreen({super.key});

  /*
    Function to fetch NASA Picture of the Day from API.

    Returns a Map containing:
    - title
    - explanation
    - image URL
  */
  Future<Map<String, dynamic>> fetchPicture() async {
    final res = await http.get(
      Uri.parse(
        "https://api.nasa.gov/planetary/apod?api_key=iSaFWLL0wBOIqbVty9fypcB15dbJeAAgOxrv3OWS",
      ),
    );

    // Decode JSON response into Dart Map
    return jsonDecode(res.body);
  }

  @override
  Widget build(BuildContext context) {
    // Access global favourites provider
    final fav = Provider.of<FavouritesProvider>(context);

    return Scaffold(
      // App bar title
      appBar: AppBar(title: const Text("Picture of the Day")),

      /*
        FutureBuilder is used to handle asynchronous data fetching.

        It automatically rebuilds UI based on:
        - loading state
        - success state
        - data availability
      */
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchPicture(),
        builder: (context, snapshot) {
          // Show loading indicator while waiting for API response
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Extract data from snapshot
          final data = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /*
                  Hero widget enables smooth animation when transitioning
                  between screens that share the same tag.
                */
                Hero(
                  tag: data['url'],

                  // CachedNetworkImage loads and caches the image
                  child: CachedNetworkImage(
                    imageUrl: data['url'],

                    // Placeholder while image is loading
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                  ),
                ),
                const SizedBox(height: 20),

                // Display image title
                Text(
                  data['title'],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Display image explanation text
                Text(data['explanation']),
                const SizedBox(height: 20),

                /*
                  Button to add/remove item from favourites.

                  - Icon changes based on whether item is already saved
                  - Tapping toggles favourite state
                */
                ElevatedButton.icon(
                  // Icon changes dynamically
                  icon: Icon(
                    fav.isFavourite(data)
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  label: const Text("Save to favourites"),
                  onPressed: () {
                    // Toggle favourite state
                    fav.isFavourite(data)
                        ? fav.removeFavourite(data)
                        : fav.addFavourite(data);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
