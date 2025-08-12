// lib/bloc/home/home_event.dart
import 'package:equatable/equatable.dart';

/// Abstract base class for all home screen related events.
abstract class HomeEvent extends Equatable {
  /// Creates a [HomeEvent].
  const HomeEvent();

  @override
  List<Object> get props => [];
}

/// Event to trigger fetching images from the API.
class HomeFetchImages extends HomeEvent {}