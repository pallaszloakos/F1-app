import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static late String apiBaseUrl;
  static late String googleEngineKey;
  static late String googleApiKey;

  static Future<void> loadConfig() async {
    try {

      final configFile = File('assets/config.json');
      if (await configFile.exists()) {
        final contents = await configFile.readAsString();
        final json = jsonDecode(contents);

        apiBaseUrl = json['API_BASE_URL'] ?? '';
        googleApiKey = json['GOOGLE_API_KEY'] ?? '';
        googleEngineKey = json['GOOGLE_ENGINE_KEY'] ?? '';
      } else {

        await dotenv.load(fileName: ".env");

        apiBaseUrl = dotenv.env['API_BASE_URL'] ?? '';
        googleApiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
        googleEngineKey = dotenv.env['GOOGLE_ENGINE_KEY'] ?? '';
      }
    } catch (e) {
      print('Error loading configuration: $e');
    }
  }
}





