import 'package:f1_app/models/season.dart';
import 'package:f1_app/services/api_service.dart';

class SeasonsController {
  int currentPage = 0;

  Future<List<Season>> fetchSeasons() async {
    final response = await ApiService.fetchSeasons(currentPage);
    return response.map<Season>((json) => Season.fromJson(json)).toList();
  }

  void nextPage() {
    currentPage++;
  }
}
