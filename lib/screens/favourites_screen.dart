import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider to access global state
import '../providers/favourites_provider.dart'; // Import FavouritesProvider to read saved items
import 'news_detail_screen.dart'; // Import detail screen to view full item details

// FavouritesScreen displays all saved favourite items
class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access favourites provider
    final fav = Provider.of<FavouritesProvider>(context);

    return Scaffold(
      // App bar title
      appBar: AppBar(title: const Text("Favourites")),

      /*
        Conditional UI:
        - If no favourites exist → show empty state message
        - Otherwise → show list of favourites
      */
      body: fav.favourites.isEmpty
          ? const Center(
              child: Text("No favourites yet", style: TextStyle(fontSize: 18)),
            )
          //ListView.builder efficiently renders saved items
          : ListView.builder(
              itemCount: fav.favourites.length,
              itemBuilder: (context, i) {
                final item = fav.favourites[i];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    //Display thumbnail image
                    leading: Image.network(
                      item['url'],
                      width: 70,
                      fit: BoxFit.cover,
                    ),

                    // Title of the favourite item
                    title: Text(item['title']),

                    /*
                      Optional explanation preview (if available)
                      - Limited to 2 lines with ellipsis overflow
                    */
                    subtitle: item['explanation'] != null
                        ? Text(
                            item['explanation'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        : null,

                    /*
                      Navigate to detail screen when tapped
                      Reuses NewsDetailScreen for consistency
                    */
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NewsDetailScreen(data: item),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
