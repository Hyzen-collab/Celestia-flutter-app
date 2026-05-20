import 'dart:convert'; // Import Dart convert library to decode JSON responses
import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http; // Import HTTP package to make API requests

// AsteroidScreen displays near-Earth asteroid data from NASA API
class AsteroidScreen extends StatelessWidget {
  const AsteroidScreen({super.key});

  /*
    Fetch asteroid data from NASA NeoWs (Near Earth Object Web Service)

    - Uses today's feed endpoint
    - Returns a list of asteroids for the current date
  */
  Future<List<Map<String, dynamic>>> fetchAsteroids() async {
    final res = await http.get(
      Uri.parse(
        "https://api.nasa.gov/neo/rest/v1/feed/today?detailed=true&api_key=DEMO KEY", //API key goes here
      ),
    );
    // Decode JSON response
    final data = jsonDecode(res.body);

    /*
      Extract asteroid list:
      - near_earth_objects is a map with date as key
      - We take the first (and only) date key
    */
    final asteroids =
        data['near_earth_objects'][data['near_earth_objects'].keys.first];
    // Convert to list of maps
    return List<Map<String, dynamic>>.from(asteroids);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar title
      appBar: AppBar(title: const Text("Asteroid Tracker")),

      //FutureBuilder handles async API call and UI rendering
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAsteroids(),
        builder: (context, snapshot) {
          // Show loading indicator while data is being fetched
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final asteroids = snapshot.data!;

          //ListView.builder efficiently displays asteroid list
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: asteroids.length,
            itemBuilder: (context, index) {
              final asteroid = asteroids[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: ListTile(
                  // Asteroid name
                  title: Text(asteroid['name']),

                  /*
                    Display additional asteroid details:
                    - Estimated diameter
                    - Close approach date
                  */
                  subtitle: Text(
                    "Size: ${asteroid['estimated_diameter']['meters']['estimated_diameter_max'].toStringAsFixed(2)} m\n"
                    "Close Approach: ${asteroid['close_approach_data'][0]['close_approach_date']}",
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
