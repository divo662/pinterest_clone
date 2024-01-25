import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../model/pexel_model.dart';

class PexelsApi {
  final String apiKey;
  final String baseUrl = 'https://api.pexels.com/v1';

  PexelsApi({required this.apiKey});

  Future<List<Photo>> searchPhotos(String query,
      {String? orientation,
      String? size,
      String? color,
      String? locale,
      int page = 1,
      int perPage = 15}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search?query=$query'
          '&orientation=$orientation'
          '&size=$size'
          '&color=$color'
          '&locale=$locale'
          '&page=$page'
          '&per_page=$perPage'),
      headers: {'Authorization': apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> photosJson = json.decode(response.body)['photos'];
      return photosJson.map((photoJson) => Photo.fromJson(photoJson)).toList();
    } else {
      throw Exception('Failed to load photos');
    }
  }

  Future<List<Photo>> getCuratedPhotos({int page = 1, int perPage = 15}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/curated?page=$page&per_page=$perPage'),
      headers: {'Authorization': apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> photosJson = json.decode(response.body)['photos'];
      return photosJson.map((photoJson) => Photo.fromJson(photoJson)).toList();
    } else {
      throw Exception('Failed to load curated photos');
    }
  }
  Future<List<Photo>> getRelatedPhotos(Photo currentPhoto, {int page = 1, int perPage = 15}) async {
    // Extract the photographer's name from the current photo
    String photographerName = currentPhoto.photographer;

    // Use the Pexels API search endpoint to fetch photos based on the photographer's name
    final response = await http.get(
      Uri.parse('$baseUrl/search?query=$photographerName&page=$page&per_page=$perPage'),
      headers: {'Authorization': apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> photosJson = json.decode(response.body)['photos'];
      return photosJson.map((photoJson) => Photo.fromJson(photoJson)).toList();
    } else {
      if (kDebugMode) {
        print('Failed to load related photos. Status code: ${response.statusCode}');
      }
      throw Exception('Failed to load related photos');
    }
  }


}
