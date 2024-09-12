import 'package:f1_app/models/driver.dart';
import 'package:f1_app/services/api_service.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

class DriverDetailsController {
  Future<Driver> fetchDriverDetails(String driverId) async {
    final response = await ApiService.fetchDriverDetails(driverId);
    return Driver.fromJson(response);
  }

  Future<String> fetchDriverImage(String name) async {
    final response = await ApiService.fetchDriverImage(name);
    return response;
  }

  Future<String> fetchNationalityFlag(String nationality) async {
    var parser = EmojiParser();
    parser.initServerData();
    String country = await ApiService.getCountryFromNationality(nationality);
    var emo = parser.get(':flag-${country.toLowerCase()}:');
    return emo.code;
  }
}
