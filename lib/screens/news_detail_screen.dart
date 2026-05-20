import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider to access global state

import '../providers/favourites_provider.dart'; // Import FavouritesProvider to manage favourite items

// NewsDetailScreen displays detailed information about a selected news item
// It receives data from the previous screen via constructor
class NewsDetailScreen extends StatelessWidget {
  // Data passed from NewsScreen (contains title, image URL, explanation, etc.)
  final Map<String, dynamic> data;

  const NewsDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Access favourites provider from global state
    final fav = Provider.of<FavouritesProvider>(context);

    return Scaffold(
      // App bar title is dynamically set using the news title
      appBar: AppBar(title: Text(data['title'])),

      /*
        SingleChildScrollView allows the content to scroll
        in case the explanation text is long
      */
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Display the main image from the API
            Image.network(data['url']),

            const SizedBox(height: 20),

            // Display the explanation/details text
            Text(data['explanation']),

            const SizedBox(height: 20),

            /*
              Button to add/remove the item from favourites.

              - Icon changes dynamically depending on favourite status
              - Tapping toggles between add and remove actions
            */
            ElevatedButton.icon(
              // Icon reflects favourite state
              icon: Icon(
                fav.isFavourite(data) ? Icons.favorite : Icons.favorite_border,
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
      ),
    );
  }
}
