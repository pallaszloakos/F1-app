import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:f1_app/services/api_service.dart';

class Driver {
  final String driverId;
  final String firstName;
  final String lastName;
  final String nationality;
  final String dateOfBirth;
  final String url;
  final String? permanentNumber;
  final String code;

  Driver({
    required this.driverId,
    required this.firstName,
    required this.lastName,
    required this.nationality,
    required this.dateOfBirth,
    required this.url,
    required this.permanentNumber,
    required this.code,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      driverId: json['driverId'],
      firstName: json['givenName'],
      lastName: json['familyName'],
      nationality: json['nationality'],
      dateOfBirth: json['dateOfBirth'],
      url: json['url'],
      permanentNumber: json['permanentNumber'],
      code: json['code'] ?? '',

    );
  }

  String get fullName => '$firstName $lastName';



}
        