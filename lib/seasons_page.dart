import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'services/api_service.dart';
import 'drivers_page.dart';

class SeasonsPage extends StatefulWidget {
  @override
  _SeasonsPageState createState() => _SeasonsPageState();
}

class _SeasonsPageState extends State<SeasonsPage> {
  final ApiService apiService = ApiService();
  late Future<List<String>> seasons;

  @override
  void initState() {
    super.initState();
    seasons = apiService.fetchSeasons();
  }

  void _launchURL(String year) async {
    final url = 'https://en.wikipedia.org/wiki/${year}_Formula_One_World_Championship';
    if (await canLaunch(url)) {
      await launch(url); // Böngésző megnyitása
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('F1 Szezonok'),
      ),
      body: FutureBuilder<List<String>>(
        future: seasons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final season = snapshot.data![index];
              return ListTile(
                title: Text(season), 
                trailing: IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () => _launchURL(season),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DriversPage(season: season), 
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
