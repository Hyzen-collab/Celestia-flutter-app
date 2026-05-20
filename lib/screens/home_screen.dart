// Import Flutter UI framework
import 'dart:ui';
import 'package:flutter/material.dart';

// Import destination screens for navigation
import 'picture_of_day_screen.dart';
import 'missions_screen.dart';
import 'latest_images_screen.dart';
import 'asteroid_screen.dart';

// HomeScreen is a StatefulWidget because it uses animation
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Add SingleTickerProviderStateMixin to support animation controller
class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    /*
      AnimationController controls the glow animation timing
      - duration: 2 seconds
      - repeats continuously in forward and reverse
    */
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    /*
      Tween defines the range of glow (blur radius)
      - begins at 6 and animates to 14
    */
    _glowAnimation = Tween<double>(begin: 6, end: 14).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    // Dispose animation controller to free resources
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Extend body behind app bar for glass effect
      extendBodyBehindAppBar: true,

      // Glass style AppBar using BackdropFilter blur
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: AppBar(
              backgroundColor: Colors.black.withOpacity(0.25),
              elevation: 0,
              titleSpacing: 16,

              //Custom title layout with animated logo + app name
              title: Row(
                children: [
                  //Animated glowing circular logo
                  AnimatedBuilder(
                    animation: _glowAnimation,
                    builder: (context, child) {
                      return Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFB388FF), Color(0xFF7C4DFF)],
                          ),

                          //Glow effect using animated blur radius
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purpleAccent.withOpacity(0.8),
                              blurRadius: _glowAnimation.value,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'C',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Celestia",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // Main background with image
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/5430284.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 40,
              left: 16,
              right: 16,
              bottom: 24,
            ),
            child: Center(
              //Grid menu of features
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  buildTile(
                    context,
                    "Picture of the Day",
                    Icons.photo_camera,
                    const PictureOfDayScreen(),
                  ),
                  buildTile(
                    context,
                    "Missions & News",
                    Icons.rocket_launch,
                    const MissionsScreen(),
                  ),
                  buildTile(
                    context,
                    "Latest Images",
                    Icons.image,
                    const LatestImagesScreen(),
                  ),
                  buildTile(
                    context,
                    "Asteroid Tracker",
                    Icons.public,
                    const AsteroidScreen(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /*
    Reusable tile widget for navigation

    - Each tile navigates to a different screen
    - Improves code reusability and cleanliness
  */
  Widget buildTile(
    BuildContext context,
    String title,
    IconData icon,
    Widget screen,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        color: Colors.black.withOpacity(0.6),
        shadowColor: Colors.deepPurpleAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.purpleAccent),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
