import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Adjust import path if needed
import '../models/image_model.dart'; // Adjust import path if needed

/// A widget that displays a dynamic, animated slideshow of images as a background.
///
/// Fetches images from the Picsum API and cycles through them automatically.
/// Applies a darkening filter and optional blur/grayscale for better text contrast.
class DynamicBackground extends StatefulWidget {
  /// The number of images to fetch and cycle through.
  ///
  /// Defaults to 5.
  final int imageCount;

  /// The interval duration between image transitions.
  ///
  /// Defaults to 8 seconds.
  final Duration interval;

  /// Creates a [DynamicBackground].
  const DynamicBackground({
    Key? key,
    this.imageCount = 5,
    this.interval = const Duration(seconds: 8),
  }) : super(key: key);

  @override
  State<DynamicBackground> createState() => _DynamicBackgroundState();
}

class _DynamicBackgroundState extends State<DynamicBackground> {
  late PageController _pageController;
  List<ImageModel> _backgroundImages = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  Timer? _timer; // Timer for auto-sliding

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
    _loadBackgroundImages();
  }

  /// Fetches images from the API and initializes the slideshow.
  Future<void> _loadBackgroundImages() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final ApiService apiService = ApiService();
      // Fetch images, requesting a couple extra to mitigate potential issues
      final List<ImageModel> images =
          await apiService.fetchImages(limit: widget.imageCount + 2);

      if (!mounted) return; // Check if widget is still active

      setState(() {
        // Take only the requested number of images
        _backgroundImages = images.take(widget.imageCount).toList();
        _isLoading = false;
      });

      // Start the automatic sliding only if images were loaded successfully
      if (_backgroundImages.isNotEmpty) {
        _startAutoSlide();
      }
    } catch (e, s) {
      // Improved error handling with stack trace
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
        // Consider logging the stack trace 's' for debugging
      });
      // Optionally, retry loading after a delay or show a static fallback
    }
  }

  /// Starts the automatic slideshow using a periodic timer.
  void _startAutoSlide() {
    // Cancel any existing timer to prevent duplicates
    _timer?.cancel();

    _timer = Timer.periodic(widget.interval, (timer) {
      // Check if the widget is still mounted and the controller is attached
      if (mounted && _pageController.hasClients && _backgroundImages.isNotEmpty) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _backgroundImages.length;
        });

        // Animate to the next page
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 1200), // Animation duration
          curve: Curves.easeInOut, // Smooth animation curve
        );
        // Timer reschedules automatically due to Timer.periodic
      }
      // If not mounted or controller detached, the timer continues but does nothing
      // until the next tick. It's cancelled in dispose().
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to prevent memory leaks
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const ColoredBox(
        color: Colors.grey,
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.white70,
          ),
        ),
      );
    }

    if (_hasError) {
      // Fallback background if loading images fails
      return ColoredBox(
        color: Colors.black54, // Darker fallback
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Background Load Error\n$_errorMessage',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    if (_backgroundImages.isEmpty) {
      // Fallback if somehow list is empty after loading
      return const ColoredBox(color: Colors.black26);
    }

    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(), // Disable manual swiping
      itemCount: _backgroundImages.length,
      itemBuilder: (context, index) {
        final String originalUrl = _backgroundImages[index].downloadUrl;

        // --- Apply image modifications for background effect ---
        // 1. Use a smaller size to potentially load faster (optional, adjust width as needed)
        //    The API adjusts height automatically. Let's use 80% of screen width as an example.
        //    You might need to get screen width via MediaQuery if not available here.
        //    For simplicity, we'll modify the URL directly.
        //    Example modification (uncomment and adjust if desired):
        //    final screenSize = MediaQuery.of(context).size;
        //    final modifiedWidth = (screenSize.width * 0.8).toInt();
        //    final modifiedHeight = (screenSize.height * 0.8).toInt();
        //    final baseModifiedUrl = '$originalUrl/$modifiedWidth/$modifiedHeight';

        // 2. Add blur and grayscale query parameters for a softer background look
        //    Combine them with the original URL or the size-modified URL
        final String modifiedUrl =
            '$originalUrl?blur=4&grayscale'; // Adjust blur level (1-10) as needed

        return ImageFiltered(
          imageFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.55), // Darken overlay for better contrast
            BlendMode.darken,
          ),
          child: Image.network(
            modifiedUrl, // Use the modified URL with blur/grayscale
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              // Show a subtle placeholder while the specific image loads
              return const ColoredBox(
                color: Colors.grey,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white30,
                    strokeWidth: 2.0,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              // If the modified image fails (e.g., blur not supported), try the original
              // This provides a fallback chain: modified -> original -> broken icon
              return Image.network(
                originalUrl, // Try original URL
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const ColoredBox(
                    color: Colors.grey,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white30,
                        strokeWidth: 2.0,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error2, stackTrace2) {
                  // If original also fails, show a clear error placeholder
                  return const ColoredBox(
                    color: Colors.deepOrangeAccent,
                    child: Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: Colors.white70,
                        size: 40,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}