/// Represents an image fetched from the Picsum API.
class ImageModel {
  /// Unique identifier for the image.
  final String id;

  /// Author of the image.
  final String author;

  /// Width of the original image in pixels.
  final int width;

  /// Height of the original image in pixels.
  final int height;

  /// URL to the author's page on Unsplash.
  final String url;

  /// Base URL to download the image.
  final String downloadUrl;

  /// Constructs an ImageModel instance.
  ImageModel({
    required this.id,
    required this.author,
    required this.width,
    required this.height,
    required this.url,
    required this.downloadUrl,
  });

  /// Creates an ImageModel instance from a JSON map.
  ///
  /// This factory constructor is used to parse the JSON response
  /// from the Picsum API.
  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] as String,
      author: json['author'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
      url: json['url'] as String,
      downloadUrl: json['download_url'] as String,
    );
  }
}