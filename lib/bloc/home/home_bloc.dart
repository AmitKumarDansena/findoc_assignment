// lib/bloc/home/home_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/image_model.dart'; // Adjust path if needed
import '../../services/api_service.dart'; // Adjust path if needed
import 'home_event.dart';
import 'home_state.dart';

/// Business Logic Component for handling home screen operations (fetching images).
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  /// The service used to fetch images from the API.
  final ApiService apiService;

  /// Creates a [HomeBloc] instance.
  ///
  /// Requires an [ApiService] instance for making API calls.
  HomeBloc({required this.apiService}) : super(HomeInitial()) {
    on<HomeFetchImages>((event, emit) async {
      // Emit loading state while fetching data.
      emit(HomeLoading());
      try {
        // Attempt to fetch images from the API.
        final List<ImageModel> images = await apiService.fetchImages(limit: 10);
        // Emit loaded state with the fetched images.
        emit(HomeLoaded(images: images));
      } catch (e) {
        // Emit error state if fetching fails.
        emit(HomeError(message: e.toString()));
      }
    });
  }
}