/// Model yang mewakili ulasan atau review produk.
/// Menyimpan penilaian, komentar, identitas reviewer, dan tanggal pembuatan ulasan.
class ReviewModel {
  final String id;
  final int rating;
  final String comment;
  final String reviewerName;
  final String reviewerAvatar;
  final String createdAt;

  ReviewModel({
    required this.id,
    required this.rating,
    required this.comment,
    required this.reviewerName,
    required this.reviewerAvatar,
    required this.createdAt,
  });

  /// Membuat objek ReviewModel dari data JSON yang diterima dari API.
  factory ReviewModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ReviewModel(
      id: json['id'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      reviewerName:
          json['reviewer']?['full_name'] ??
          'Anonymous',
      reviewerAvatar:
          json['reviewer']?['avatar_url'] ??
          '',
      createdAt:
          json['created_at'] ?? '',
    );
  }
}