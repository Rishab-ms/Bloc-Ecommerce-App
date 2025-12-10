import '../../data/models/product_model.dart';
import '../../domain/repositories/cart_repository.dart';

// This class simulates a Server. 
// It keeps the data in memory (RAM) as long as the app is running.
class MockCartRepository implements CartRepository {
  // This list acts as our "Database"
  final List<Product> _cartItems = [];

  @override
  Future<List<Product>> getCartItems() async {
    // Simulate network delay (latency)
    await Future.delayed(const Duration(milliseconds: 500));
    return _cartItems;
  }

  @override
  Future<void> addToCart(Product product) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Logic: Add to our memory list
    _cartItems.add(product);
  }

  @override
  Future<void> removeFromCart(int productId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _cartItems.removeWhere((item) => item.id == productId);
  }
}