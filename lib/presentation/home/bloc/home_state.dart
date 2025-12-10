import 'package:equatable/equatable.dart';
import '../../../../data/models/product_model.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<Product> products;
  final List<String> categories; 
  final String? selectedCategory;
  final bool hasReachedMax; // If true, stop trying to load more
  final int page;           // Keeps track of which page we are on
  final String errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.products = const [],
    this.categories = const [],
    this.selectedCategory,
    this.hasReachedMax = false,
    this.page = 0,
    this.errorMessage = '',
  });

  // The copyWith method is crucial. It allows us to update ONE field
  // while keeping the others exactly the same.
  HomeState copyWith({
    HomeStatus? status,
    List<Product>? products,
    List<String>? categories,
    String? selectedCategory,
    bool? hasReachedMax,
    int? page,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      // Special logic: If we pass null, we might mean "clear it" or "keep it".
      // Here we assume if 'selectedCategory' is passed (even as null), we overwrite it.
      // But for simplicity in this method, we usually just assign.
      // To clear a category, we might need a specific logic or ensure we pass null explicitly.
      selectedCategory: selectedCategory ?? this.selectedCategory,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  
  // A specific helper to safely clear the category filter
  HomeState copyWithNewCategory(String? newCategory) {
    return HomeState(
      status: status,
      products: [], // Clear products because the list changes
      categories: categories, 
      selectedCategory: newCategory,
      hasReachedMax: false, // Reset pagination
      page: 0, // Reset page
      errorMessage: '',
    );
  }

  @override
  List<Object?> get props => [status, products, categories, selectedCategory, hasReachedMax, page, errorMessage];
}