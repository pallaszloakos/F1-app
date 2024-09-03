import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://ergast.com/api/f1';
 
  Future<List<String>> fetchSeasons() async {
    final response = await http.get(Uri.parse('$baseUrl/seasons.json'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['MRData']['SeasonTable']['Seasons'] as List)
          .map((season) => season['season'].toString())
          .toList();
    } else {
      throw Exception('Failed to load seasons');
    }
  }

 
  Future<List<String>> fetch2019Drivers() async {
    final response = await http.get(Uri.parse('$baseUrl/2019/drivers.json'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['MRData']['DriverTable']['Drivers'] as List)
          .map((driver) => driver['familyName'].toString())
          .toList();
    } else {
      throw Exception('Failed to load drivers');
    }
  }

 
  Future<Map<String, dynamic>> fetchDriverDetails(String driverId) async {
    final response = await http.get(Uri.parse('$baseUrl/drivers/$driverId.json'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['MRData']['DriverTable']['Drivers'][0];
    } else {
      throw Exception('Failed to load driver details');
    }
  }

 Future<List<String>> fetchDriversBySeason(String season) async {
   final response = await http.get(Uri.parse('$baseUrl/$season/drivers.json'));
   if (response.statusCode == 200) {
     final data = jsonDecode(response.body);
     return (data['MRData']['DriverTable']['Drivers'] as List)
         .map((driver) => driver['familyName'].toString())
         .toList();
   } else {
     throw Exception('Failed to load drivers');
   }
}


}