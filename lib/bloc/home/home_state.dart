// lib/bloc/home/home_state.dart
import 'package:equatable/equatable.dart';
import '../../models/image_model.dart'; // Adjust path if needed

/// Abstract base class for all home screen states.
abstract class HomeState extends Equatable {
  /// Creates a [HomeState].
  const HomeState();

  @override
  List<Object> get props => [];
}

/// Initial state when the home screen is first loaded.
class HomeInitial extends HomeState {}

/// State indicating that images are being loaded.
class HomeLoading extends HomeState {}

/// State indicating that images have been successfully loaded.
class HomeLoaded extends HomeState {
  /// The list of images fetched from the API.
  final List<ImageModel> images;

  /// Creates a [HomeLoaded] state.
  const HomeLoaded({required this.images});

  @override
  List<Object> get props => [images];
}

/// State indicating that an error occurred while loading images.
class HomeError extends HomeState {
  /// The error message.
  final String message;

  /// Creates a [HomeError] state.
  const HomeError({required this.message});

  @override
  List<Object> get props => [message];
}