import '../../core/network/dio_client.dart';
import '../../data/models/product_model.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  // We rely on DioClient to make requests.
  final DioClient dioClient;

  ProductRepositoryImpl({required this.dioClient});

  @override
  Future<List<Product>> fetchProducts({int page = 0, String? category}) async {
    try {
      // 1. Calculate Pagination Logic
      // limit = 10 items per page.
      // page 0 -> skip 0. Page 1 -> skip 10.
      const int limit = 10;
      final int skip = page * limit;

      // 2. Determine Endpoint (Filter vs All)
      String endpoint = '/products';
      if (category != null && category.isNotEmpty) {
        endpoint = '/products/category/$category';
      }

      // 3. Make the Request using Dio
      // We pass query parameters safely using 'queryParameters'
      final response = await dioClient.api.get(
        endpoint,
        queryParameters: {
          'limit': limit,
          'skip': skip,
          // 'select': 'title,price,thumbnail', // Optimization: We could ask only for specific fields
        },
      );

      // 4. Parse Data
      // The API returns: { "products": [ ... ], "total": 100, ... }
      final List<dynamic> data = response.data['products'];
      
      // Map the JSON list to our Product objects
      return data.map((json) => Product.fromJson(json)).toList();

    } catch (e) {
      // In a real app, we would catch DioException and return a custom Failure object.
      // For this showcase, simply rethrowing is fine for now.
      throw Exception('Failed to fetch products: $e');
    }
  }

  @override
  Future<List<String>> fetchCategories() async {
    try {
      final response = await dioClient.api.get('/products/categories');
      
      // The API returns a simple list: ["beauty", "fragrances", ...]
      // We cast it to List<String>.
      // Note: If dummyjson changes this to return objects, this line will need updating.
      final List<dynamic> data = response.data;
      
      // Some versions of DummyJSON return objects {slug: "abc", name: "Abc"}.
      // To be safe, let's check the type of the first item.
      if (data.isNotEmpty && data.first is Map) {
         return data.map((e) => e['slug'].toString()).toList();
      }

      return List<String>.from(data);
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }
}