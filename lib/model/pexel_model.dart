
class Photo {
  final int id;
  final int width;
  final int height;
  final String url;
  final String photographer;
  final String photographerUrl;
  final int photographerId;
  final String avgColor;
  final String alt;
  final Map<String, dynamic> src;

  Photo({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    required this.photographer,
    required this.photographerUrl,
    required this.photographerId,
    required this.avgColor,
    required this.alt,
    required this.src,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] ?? 0,
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      url: json['url'] ?? '',
      photographer: json['photographer'] ?? '',
      photographerUrl: json['photographer_url'] ?? '',
      photographerId: json['photographer_id'] ?? 0,
      avgColor: json['avg_color'] ?? '',
      alt: json['alt'] ?? '',
      src: json['src'] as Map<String, dynamic>,
    );
  }
}
