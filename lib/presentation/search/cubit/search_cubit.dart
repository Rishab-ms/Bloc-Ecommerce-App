import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../data/models/product_model.dart';
import '../../../../domain/repositories/product_repository.dart';

// --- STATE ---
abstract class SearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}
class SearchSuccess extends SearchState {
  final List<Product> products;
  SearchSuccess(this.products);
  @override
  List<Object> get props => [products];
}
class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
  @override
  List<Object> get props => [message];
}

// --- CUBIT ---
class SearchCubit extends Cubit<SearchState> {
  final ProductRepository productRepository;

  SearchCubit({required this.productRepository}) : super(SearchInitial());

  Future<void> search(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    try {
      final results = await productRepository.searchProducts(query);
      emit(SearchSuccess(results));
    } catch (e) {
      emit(SearchError("Search failed. Please try again."));
    }
  }
}