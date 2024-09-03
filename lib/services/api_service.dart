import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://ergast.com/api/f1';
  var headers = {"Content-type": "application/json"};

 
  Future<List<dynamic>> fetchSeasons(int currentPage) async {
    final response = await http.get(Uri.parse('$baseUrl/seasons.json?offset=${currentPage * 30}&limit=30'),headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['MRData']['SeasonTable']['Seasons'].reversed.toList();
    } else {
      throw Exception('Failed to load seasons');
    }
  }

 
  Future<Map<String, dynamic>> fetchDriverDetails(String driverId) async {
    final response = await http.get(Uri.parse('$baseUrl/drivers/$driverId.json'),headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['MRData']['DriverTable']['Drivers'][0];
    } else {
      throw Exception('Failed to load driver details');
    }
  }

Future<List<Map<String, dynamic>>> fetchDriversDetailsBySeason(String season) async {
  final response = await http.get(Uri.parse('$baseUrl/$season/drivers.json'),headers: headers);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return (data['MRData']['DriverTable']['Drivers'] as List).map((driver) {
      return {
        'name': '${driver['givenName']} ${driver['familyName']}',
        'driverId': driver['driverId'],
        'nationality': driver['nationality'],
        'birthDate': driver['dateOfBirth'],
        'number': driver['permanentNumber'] ?? 'N/A' 
      };
    }).toList();
  } else {
    throw Exception('Failed to load drivers');
  }
}

Future<List<String>> fetchDriversBySeason(String season) async {
  final response = await http.get(Uri.parse('$baseUrl/$season/drivers.json'),headers: headers);
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

