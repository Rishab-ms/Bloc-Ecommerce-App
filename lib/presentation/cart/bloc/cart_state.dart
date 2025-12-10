import 'package:equatable/equatable.dart';
import '../../../../data/models/product_model.dart';

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  final CartStatus status;
  final List<Product> items;
  final String errorMessage;

  const CartState({
    this.status = CartStatus.initial,
    this.items = const [],
    this.errorMessage = '',
  });
  
  // Calculate total price dynamically
  double get totalPrice => items.fold(0, (sum, item) => sum + item.price);

  CartState copyWith({
    CartStatus? status,
    List<Product>? items,
    String? errorMessage,
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, items, errorMessage];
}