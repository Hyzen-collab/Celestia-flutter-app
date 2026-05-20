import 'dart:convert'; // Import Dart convert library for JSON encoding/decoding
import 'package:flutter/material.dart'; // Import Flutter material for ChangeNotifier
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences for local storage (persistent data)

// FavouritesProvider manages:
// - List of favourite items
// - Saving/loading favourites locally
// - Notifying UI when data changes
class FavouritesProvider extends ChangeNotifier {
  /*
    Private list storing favourite items.
    Each item is a Map containing data like:
    - title
    - url
    - explanation
  */
  List<Map<String, dynamic>> _favourites = [];

  /*
    Public getter to expose favourites list
  */
  List<Map<String, dynamic>> get favourites => _favourites;
  /*
    Constructor:
    - Automatically loads saved favourites when provider is initialized
  */
  FavouritesProvider() {
    loadFavourites();
  }

  /*
    Add an item to favourites
    - Save to list
    - Persist to local storage
    - Notify UI to update
  */
  void addFavourite(Map<String, dynamic> item) {
    _favourites.add(item);
    saveFavourites();
    notifyListeners();
  }

  /*
    Remove an item from favourites
    - Remove from list
    - Update storage
    - Notify UI
  */
  void removeFavourite(Map<String, dynamic> item) {
    _favourites.remove(item);
    saveFavourites();
    notifyListeners();
  }

  /*
    Check if an item is already in favourites

    - Uses URL as unique identifier
    - Returns true if item exists in list
  */
  bool isFavourite(Map<String, dynamic> item) {
    return _favourites.any((e) => e['url'] == item['url']);
  }

  /*
    Save favourites list to local storage

    - Converts list of maps → JSON string
    - Stores using SharedPreferences
  */
  Future saveFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('fav', jsonEncode(_favourites));
  }

  /*
    Load favourites from local storage

    - Retrieves JSON string
    - Decodes into List<Map<String, dynamic>>
    - Updates internal state
    - Notifies UI
  */
  Future loadFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('fav');

    if (data != null) {
      _favourites = List<Map<String, dynamic>>.from(jsonDecode(data));
      // Update UI after loading stored data
      notifyListeners();
    }
  }
}
