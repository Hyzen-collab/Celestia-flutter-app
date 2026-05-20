// Import Flutter test framework
import 'package:flutter_test/flutter_test.dart';

// Import SharedPreferences to mock local storage
import 'package:shared_preferences/shared_preferences.dart';

// Import the provider being tested
import 'package:celestia_app/providers/favourites_provider.dart';

void main() {
  // This ensures Flutter bindings are initialized before running tests
  // Required because SharedPreferences depends on platform channels
  TestWidgetsFlutterBinding.ensureInitialized();

  // setUp runs before each test case
  // Here we mock SharedPreferences to avoid plugin errors
  setUp(() {
    // We initialize an empty fake storage
    // This prevents the need for real device storage
    SharedPreferences.setMockInitialValues({});
  });

  // UNIT TEST 1
  test('Add favourite increases list', () {
    // Create instance of provider
    final provider = FavouritesProvider();

    // Sample test data
    final item = {'title': 'Test', 'url': 'url1'};

    // Act: Add item to favourites
    provider.addFavourite(item);

    // Assert: List should contain 1 item
    expect(provider.favourites.length, 1);
  });

  // UNIT TEST 2
  test('Remove favourite decreases list', () {
    final provider = FavouritesProvider();

    final item = {'title': 'Test', 'url': 'url2'};

    // Add then remove the item
    provider.addFavourite(item);
    provider.removeFavourite(item);

    // Assert: List should be empty
    expect(provider.favourites.isEmpty, true);
  });

  // UNIT TEST 3
  test('isFavourite returns true when item exists', () {
    final provider = FavouritesProvider();

    final item = {'title': 'Test', 'url': 'url3'};

    provider.addFavourite(item);

    // Assert: Item should be recognized as favourite
    expect(provider.isFavourite(item), true);
  });

  // UNIT TEST 4
  test('isFavourite returns false when item does not exist', () {
    final provider = FavouritesProvider();

    final item = {'title': 'Test', 'url': 'url4'};

    // Item is NOT added

    // Assert: Should return false
    expect(provider.isFavourite(item), false);
  });

  // UNIT TEST 5
  test('Adding duplicate items increases list size', () {
    final provider = FavouritesProvider();

    final item = {'title': 'Test', 'url': 'url5'};

    // Add same item twice
    provider.addFavourite(item);
    provider.addFavourite(item);

    // Assert: List should contain both entries (duplicates allowed)
    expect(provider.favourites.length, 2);
  });
}
