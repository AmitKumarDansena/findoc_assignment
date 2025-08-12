import '../bloc/home/home_bloc.dart'; // Should now find the file
import '../bloc/home/home_event.dart'; // Add this
import '../bloc/home/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home/home_bloc.dart';
import '../services/api_service.dart';
import '../models/image_model.dart';
import '../widgets/animated_moving_object.dart';
import '../widgets/dynamic_background.dart'; // Ensure this path is correct

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Dynamic Background Slideshow (different settings from login)
          const DynamicBackground(
            imageCount: 8,
            interval: Duration(seconds: 12),
          ),
          // Animated Moving Objects
          const AnimatedMovingObject(index: 1),
          const AnimatedMovingObject(index: 2),
          const AnimatedMovingObject(index: 3), // Add more for effect
          // Main Content - Scrollable Image List
          const SafeArea(
            child: HomeContent(),
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeBloc(apiService: ApiService())..add(HomeFetchImages()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          }
          if (state is HomeError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white70, size: 50),
                    const SizedBox(height: 15),
                    const Text(
                      'Oops! Something went wrong.',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<HomeBloc>().add(HomeFetchImages());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is HomeLoaded) {
            return _ImageListView(images: state.images);
          }
          return const Center(
              child: Text('Initializing...',
                  style: TextStyle(color: Colors.white)));
        },
      ),
    );
  }
}

class _ImageListView extends StatelessWidget {
  final List<ImageModel> images;
  const _ImageListView({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeBloc>().add(HomeFetchImages());
        // Wait a bit to show the refresh indicator
        await Future.delayed(const Duration(milliseconds: 800));
      },
      child: ListView.builder(
        itemCount: images.length,
        padding: const EdgeInsets.all(10.0), // Outer padding for the list
        itemBuilder: (context, index) {
          final image = images[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            color: Colors.white.withOpacity(0.93),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image from Picsum
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
                  child: Image.network(
                    image.downloadUrl, // Use the direct download URL
                    width: screenWidth - 20, // Account for card margin/padding
                    // height will adjust automatically based on aspect ratio with BoxFit.fitWidth
                    fit: BoxFit.fitWidth, // Maintains image aspect ratio
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200, // Placeholder height while loading
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, color: Colors.grey),
                            Text("Image Load Failed",
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Image Details (Author, Dimensions)
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Photo by ${image.author}",
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600, // SemiBold
                          fontSize: 17.0,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        'Dimensions: ${image.width} x ${image.height} px',
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.normal, // Regular
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      // Optional: Display Image ID
                      Text(
                        'ID: ${image.id}',
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.normal,
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}