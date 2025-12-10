import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Fired when the screen first opens
class HomeStarted extends HomeEvent {}

// Fired when the user scrolls to the bottom
class HomeLoadMore extends HomeEvent {}

// Fired when the user selects a category from the bottom sheet
class HomeCategoryChanged extends HomeEvent {
  final String? category; // null means "All"
  
  HomeCategoryChanged(this.category);

  @override
  List<Object?> get props => [category];
}