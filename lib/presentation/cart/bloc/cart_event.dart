import 'package:equatable/equatable.dart';
import '../../../../data/models/product_model.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CartStarted extends CartEvent {}

class CartItemAdded extends CartEvent {
  final Product product;
  CartItemAdded(this.product);
}

class CartItemRemoved extends CartEvent {
  final int productId;
  CartItemRemoved(this.productId);
}