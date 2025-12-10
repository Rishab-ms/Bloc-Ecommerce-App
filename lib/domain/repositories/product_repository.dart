import '../../data/models/product_model.dart';

// Abstract classes act as "Contracts". 
// The Bloc will only talk to this class, not the implementation.
abstract class ProductRepository {
  
  // Fetches a list of products. 
  // We pass 'page' (0, 1, 2) and the Repo calculates the 'skip' logic.
  // 'category' is optional (nullable); if provided, we filter.
  Future<List<Product>> fetchProducts({int page = 0, String? category});

  // Fetches the list of category names (e.g., "smartphones", "laptops")
  Future<List<String>> fetchCategories();
}