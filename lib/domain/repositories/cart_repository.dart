import '../../data/models/product_model.dart';

// Since we don't have a backend for Cart, we define what operations
// our "Fake Server" needs to support.
abstract class CartRepository {
  
  // Get all items currently in the cart
  Future<List<Product>> getCartItems();
  
  // Add an item to the cart (returns void, or throws error if failed)
  Future<void> addToCart(Product product);
  
  // Remove an item
  Future<void> removeFromCart(int productId);
}