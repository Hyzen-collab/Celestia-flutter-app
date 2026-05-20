import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart'; // Import video player package to play local/asset videos
import 'widgets/bottom_nav.dart'; // Import your bottom navigation screen (main app entry after splash)

// SplashScreen is a StatefulWidget because it manages video playback state
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// State class manages lifecycle and video controller
class _SplashScreenState extends State<SplashScreen> {
  // VideoPlayerController is used to control playback of the video
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    /*
      Initialize the video controller with a local asset video.
      The video is stored in assets/videos/logo_intro1.mp4
    */
    _controller = VideoPlayerController.asset('assets/videos/logo_intro1.mp4')
      ..initialize().then((_) {
        setState(() {});
        // Once the video is initialized, rebuild UI
        _controller.play();
      });

    /*
      Add a listener to monitor video state changes:
      - Detect errors
      - Detect when video finishes playing
    */
    _controller.addListener(() {
      // If there is an error in video playback
      if (_controller.value.hasError) {
        // Navigate to the main app screen even if video fails
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BottomNav()),
        );
      }

      // If video playback reaches the end
      if (_controller.value.position >= _controller.value.duration) {
        // Navigate to the main app screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BottomNav()),
        );
      }
    });
  }

  @override
  void dispose() {
    /*
      Dispose the video controller to free resources and prevent memory leaks
    */

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set background color of splash screen
      backgroundColor: Colors.white,
      body: Center(
        // Check if video is initialized before displaying
        child: _controller.value.isInitialized
            // If initialized -> show video
            ? SizedBox(
                // Set width to 80% of screen width
                width: MediaQuery.of(context).size.width * 0.8,
                child: AspectRatio(
                  // Maintain correct video aspect ratio
                  aspectRatio: _controller.value.aspectRatio,
                  // Video player widget renders the video
                  child: VideoPlayer(_controller),
                ),
              )
            // If not initialized -> show loading indicator
            : const CircularProgressIndicator(color: Colors.black),
      ),
    );
  }
}
