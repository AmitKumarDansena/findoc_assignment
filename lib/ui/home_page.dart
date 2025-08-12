// lib/ui/home_page.dart

// --- Make sure you have this import at the top of the file ---
import 'package:flutter/material.dart';
import '../repositories/picsum_repository.dart'; // <-- Import the repository
// --- Also make sure these BLoC imports are present ---
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/home/home_bloc.dart';
import '../blocs/home/home_event.dart';
import '../blocs/home/home_state.dart';
// --- UI helpers ---
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

// --- CORRECTED HomePage Class ---
class HomePage extends StatelessWidget {
  // 1. Add the field to hold the repository instance
  final PicsumRepository picsumRepository;

  // 2. Update the constructor to require the repository
  const HomePage({
    Key? key,
    required this.picsumRepository, // <-- Add this named parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // --- Use the repository here, e.g., in BlocProvider ---
    return BlocProvider(
      create: (context) => HomeBloc(picsumRepository: picsumRepository)
        ..add(HomeFetchImages()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home', style: GoogleFonts.montserrat()),
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == HomeStatus.failure) {
              return Center(child: Text('Error: ${state.error}'));
            }
            if (state.status == HomeStatus.success) {
              final images = state.images;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final image = images[index];
                  return Card(
                    child: GridTile(
                      footer: Container(
                        color: Colors.black54,
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              image.author,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'ID: ${image.id}',
                              style: GoogleFonts.montserrat(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: image.downloadUrl,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            }
            // Default fallback
            return const Center(child: Text('Unexpected state'));
          },
        ),
      ),
    );
  }
}