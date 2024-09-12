
import 'package:f1_app/models/driver.dart';
import 'package:f1_app/services/api_service.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

class DriversController {
  Future<List<Driver>> fetchDrivers(String season) async {
    final response = await ApiService.fetchDrivers(season);
    return response.map<Driver>((json) => Driver.fromJson(json)).toList();
  }

  Future<String> fetchNationalityFlag(String nationality) async {
    var parser = EmojiParser();
    parser.initServerData();
    String country = await ApiService.getCountryFromNationality(nationality);
    var emo = parser.get(':flag-${country.toLowerCase()}:');
    return emo.code;
  }



}
        