import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:f1_app/config.dart';

class ApiService {
  static String baseUrl = Config.apiBaseUrl;
  static const Map<String, String> headers = {
    "content-type": "application/json"
  };

  static Future<List<dynamic>> fetchDrivers(String season) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$season/drivers.json'),headers: headers
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['MRData']['DriverTable']['Drivers'];
    } else {
      throw Exception('Failed to load drivers');
    }
  }

  static Future<Map<String, dynamic>> fetchDriverDetails(
      String driverId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/drivers/$driverId.json'),headers: headers
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['MRData']['DriverTable']['Drivers'][0];
    } else {
      throw Exception('Failed to load driver details');
    }
  }


  static Future<List<dynamic>> fetchSeasons(int currentPage) async {
    final response = await http.get(
      Uri.parse('$baseUrl/seasons.json?offset=${currentPage * 30}&limit=30'),headers: headers
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['MRData']['SeasonTable']['Seasons'];
    } else {
      throw Exception('Failed to load seasons');
    }
  }

  static Future fetchDriverImage(name) async {
    final apiKey = Config.googleApiKey ?? '';
    final engineKey = Config.googleEngineKey ?? '';
    final searchQuery = name;

    final url = Uri.encodeFull(
        'https://www.googleapis.com/customsearch/v1?key=$apiKey&cx=$engineKey&q=$searchQuery');

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['items'] != null &&
          data['items'][0]['pagemap']['cse_image'] != null) {

        return data['items'][0]['pagemap']['cse_image'][0]['src'] ?? '';
      }

    }
  }

  static Future<String> getCountryFromNationality(String nationality) async {

    final response = await http.get(Uri.parse('https://restcountries.com/v3.1/all'));

    if (response.statusCode == 200) {
      List countries = json.decode(response.body);


      var country = countries.firstWhere(
              (c) => c['demonyms'] != null && c['demonyms']['eng']['m'].toLowerCase() == nationality.toLowerCase(),
          orElse: () => null);

      if (country != null) {
        return country['cca2'];
      } else {
        return 'Ország nem található';
      }
    } else {
      throw Exception('Failed to load country data');
    }
  }
}
