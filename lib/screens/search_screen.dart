import 'dart:convert'; // Import Dart convert library to decode JSON responses
import 'package:flutter/material.dart';

// Import HTTP package to make API requests
import 'package:http/http.dart' as http;

// SearchScreen is Stateful because it handles:
// - User input
// - API calls
// - Loading state
// - Dynamic UI updates
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Controller to read user input from the TextField
  final TextEditingController _controller = TextEditingController();

  // Stores list of search results (each image with title + URL)
  List<Map<String, String>> _images = [];

  // Tracks whether API request is in progress
  bool _isLoading = false;

  /*
    Function to search NASA images using NASA API

    Steps:
    1. Validate input
    2. Show loading indicator
    3. Call API
    4. Parse JSON response
    5. Update UI with results
  */
  Future<void> _searchImages(String query) async {
    // If user input is empty, clear results and exit
    if (query.isEmpty) {
      setState(() => _images = []);
      return;
    }

    // Show loading spinner
    setState(() => _isLoading = true);

    // Construct API URL with user query
    final url = Uri.parse(
      'https://images-api.nasa.gov/search?q=$query&media_type=image',
    );

    // Make HTTP GET request
    final response = await http.get(url);

    // If request is successful
    if (response.statusCode == 200) {
      // Decode JSON response
      final data = json.decode(response.body);

      // Extract items list from response
      final items = data['collection']['items'] as List;

      /*
        Convert API response into a simplified list of maps:
        Each map contains:
        - title of image
        - image URL
      */
      final results = items.take(20).map<Map<String, String>>((item) {
        final info = item['data'][0];
        final link = item['links'][0];

        return {"title": info['title'] ?? 'NASA Image', "image": link['href']};
      }).toList();

      // Update UI with results
      setState(() {
        _images = results;
        _isLoading = false;
      });
    } else {
      // If API fails, stop loading
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar title
      appBar: AppBar(title: const Text("Search NASA Images")),
      body: Column(
        children: [
          //Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,

              // Trigger search when user submits input (press enter)
              onSubmitted: _searchImages,
              decoration: InputDecoration(
                hintText: "Search space images (e.g. Mars)",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          //Results Section
          Expanded(
            child: _isLoading
                // Show loading spinner while fetching data
                ? const Center(child: CircularProgressIndicator())
                : _images.isEmpty
                ? const Center(
                    child: Text(
                      "Search to see NASA images",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                // If results exist, display them in a grid
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 items per row
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      final image = _images[index];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Display image from network
                            Image.network(image["image"]!, fit: BoxFit.cover),

                            // Overlay gradient for better text visibility
                            Container(
                              alignment: Alignment.bottomCenter,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                ),
                              ),

                              // Image title text
                              child: Text(
                                image["title"]!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
