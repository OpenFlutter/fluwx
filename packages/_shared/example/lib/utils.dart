import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<Uint8List?> fetchImageAsUint8List(String imageUrl) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      debugPrint('Failed to load image: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    debugPrint('Error fetching image: $e');
    return null;
  }
}