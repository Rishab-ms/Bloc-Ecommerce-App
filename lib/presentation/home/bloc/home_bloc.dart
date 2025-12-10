import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../../../../domain/repositories/product_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProductRepository productRepository;

  HomeBloc({required this.productRepository}) : super(const HomeState()) {
    // Register the event handlers
    on<HomeStarted>(_onStarted);
    on<HomeLoadMore>(_onLoadMore);
    on<HomeCategoryChanged>(_onCategoryChanged);
  }

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      // Fetch both categories and initial products in parallel
      // This is faster than awaiting them one by one.
      final results = await Future.wait([
        productRepository.fetchCategories(),
        productRepository.fetchProducts(page: 0),
      ]);

      final categories = results[0] as List<String>;
      final products = results[1] as List<dynamic>; // Cast safely later

      emit(state.copyWith(
        status: HomeStatus.success,
        categories: categories,
        products: products.cast(), // helper to ensure types
        page: 1, // Next page will be 1
        hasReachedMax: products.length < 10, // If we got less than 10, we are done
      ));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onCategoryChanged(HomeCategoryChanged event, Emitter<HomeState> emit) async {
    // 1. Clear the current list and set loading, but keep the categories list!
    emit(state.copyWithNewCategory(event.category).copyWith(status: HomeStatus.loading));

    try {
      final products = await productRepository.fetchProducts(
        page: 0,
        category: event.category,
      );

      emit(state.copyWith(
        status: HomeStatus.success,
        products: products,
        page: 1,
        hasReachedMax: products.length < 10,
        selectedCategory: event.category, // Ensure the UI knows what is selected
      ));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadMore(HomeLoadMore event, Emitter<HomeState> emit) async {
    // If we are already loading or have reached the end, do nothing.
    if (state.hasReachedMax || state.status == HomeStatus.loading) return;

    try {
      final nextProducts = await productRepository.fetchProducts(
        page: state.page,
        category: state.selectedCategory,
      );

      if (nextProducts.isEmpty) {
        emit(state.copyWith(hasReachedMax: true));
      } else {
        emit(state.copyWith(
          status: HomeStatus.success,
          // Add new items to the existing list
          products: List.of(state.products)..addAll(nextProducts),
          page: state.page + 1,
          hasReachedMax: false,
        ));
      }
    } catch (e) {
      // If pagination fails, we usually just show a snackbar in UI, 
      // but for now, we won't break the whole page state.
    }
  }
}