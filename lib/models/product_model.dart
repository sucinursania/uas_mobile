/// Model yang mewakili data produk yang ditampilkan di aplikasi.
/// Menyimpan informasi dasar produk, stok, kategori, dan penilaian pengguna.
class ProductModel {
  final String id;
  final String name;
  final String description;
  final int price;
  final int stock;
  final String imageUrl;
  final String category;
  final double averageRating;
  final int totalReviews;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.category,
    required this.averageRating,
    required this.totalReviews,
  });

  /// Membuat objek ProductModel dari data JSON yang diterima dari API.
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      stock: json['stock'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      category:
          json['categories']?['name'] ??
          'Tanpa Kategori',
      averageRating: 
          json['average_rating']?.toDouble() ?? 0.0,
      totalReviews: json['total_reviews'] ?? 0,
      
    );
  }
}