import 'dart:convert'; // Import Dart convert library to decode JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http; // Import HTTP package to make API requests
import 'package:cached_network_image/cached_network_image.dart'; // Import CachedNetworkImage for efficient image loading with caching
import 'news_detail_screen.dart'; // Import detail screen for navigation

// LatestImagesScreen displays a grid of NASA images
class LatestImagesScreen extends StatelessWidget {
  const LatestImagesScreen({super.key});

  /*
    Fetch images from NASA Image API

    - Searches for "galaxy" images
    - Parses response into a list of maps
  */
  Future<List<Map<String, dynamic>>> fetchImages() async {
    final res = await http.get(
      Uri.parse("https://images-api.nasa.gov/search?q=galaxy&media_type=image"),
    );

    // Extract items from JSON response
    final items = jsonDecode(res.body)['collection']['items'];

    // Map each item into a structured format
    return List<Map<String, dynamic>>.from(
      items.map((item) {
        final data = item['data'][0];
        final img = item['links'][0];
        return {
          'title': data['title'],
          'explanation': data['description'] ?? '',
          'url': img['href'],
        };
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar title
      appBar: AppBar(title: const Text("Latest Images")),

      //FutureBuilder handles async API call and UI rendering
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchImages(),
        builder: (context, snapshot) {
          // Show loading indicator while fetching data
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final images = snapshot.data!;

          /*
            GridView.builder displays images in a grid layout
            - Efficient for image galleries
          */
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              final data = images[index];
              return GestureDetector(
                //Navigate to detail screen when user taps an image
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NewsDetailScreen(data: data),
                    ),
                  );
                },

                /*
                  Hero animation creates smooth transition between screens
                  using the image URL as the unique tag
                */
                child: Hero(
                  tag: data['url'],
                  child: CachedNetworkImage(
                    imageUrl: data['url'],
                    fit: BoxFit.cover,

                    // Placeholder shown while image loads
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
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
