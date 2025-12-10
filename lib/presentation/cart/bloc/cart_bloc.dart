import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../../../../domain/repositories/cart_repository.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc({required this.cartRepository}) : super(const CartState()) {
    on<CartStarted>(_onStarted);
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
  }

  Future<void> _onStarted(CartStarted event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    try {
      final items = await cartRepository.getCartItems();
      emit(state.copyWith(status: CartStatus.success, items: items));
    } catch (e) {
      emit(state.copyWith(status: CartStatus.failure));
    }
  }

  Future<void> _onItemAdded(CartItemAdded event, Emitter<CartState> emit) async {
    // Optional: emit loading if you want a spinner on the button
    emit(state.copyWith(status: CartStatus.loading));
    
    try {
      await cartRepository.addToCart(event.product);
      // Re-fetch the updated list
      final items = await cartRepository.getCartItems();
      emit(state.copyWith(status: CartStatus.success, items: items));
    } catch (e) {
      emit(state.copyWith(status: CartStatus.failure));
    }
  }

  Future<void> _onItemRemoved(CartItemRemoved event, Emitter<CartState> emit) async {
    try {
      await cartRepository.removeFromCart(event.productId);
      final items = await cartRepository.getCartItems();
      emit(state.copyWith(status: CartStatus.success, items: items));
    } catch (e) {
      emit(state.copyWith(status: CartStatus.failure));
    }
  }
}