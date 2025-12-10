import 'package:equatable/equatable.dart';

/// The Product entity represents a single product item in the app.
/// 
/// It extends [Equatable] to enable **value equality** instead of
/// default Dart object equality.  
/// 
/// Why Equatable?
/// - By default, Dart objects are compared by reference (memory location).
/// - With Equatable, objects with the same property values are considered equal.
/// - This is extremely useful when:
///   - Using Bloc / Cubit state management (prevents unnecessary rebuilds)
///   - Comparing entities in lists
///   - Writing cleaner tests
/// 
/// Example:
/// Product(id: 1, title: "A", ...) == Product(id: 1, title: "A", ...) → true
///
/// Without Equatable, this would be false because they are different instances.
class Product extends Equatable {
  final int id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final String thumbnail;
  final String category;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.thumbnail,
    required this.category,
  });

  /// Creates a Product instance from a JSON map.
  ///
  /// Includes defensive defaults so the UI never crashes when
  /// fields are missing or null.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'No Title',
      description: json['description'] as String? ?? '',
      // Convert both int and double to double safely
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      thumbnail: json['thumbnail'] as String? ?? '',
      category: json['category'] as String? ?? 'general',
    );
  }

  /// UI helper: Formats the price neatly for display.
  String get formattedPrice => 'INR ${price.toStringAsFixed(0)}';

  /// Equatable uses this list to determine if two Product instances
  /// are equal.  
  ///
  /// Only include properties that define the identity of the product.
  @override
  List<Object?> get props => [id, title, price, category];
}
