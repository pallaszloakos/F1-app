import 'package:flutter/material.dart';
import 'services/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F1 App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: SeasonsPage(),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('F1 Seasons'),
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
              return ListTile(
                title: Text(snapshot.data![index]),
                onTap: () {
                },
              );
            },
          );
        },
      ),
    );
  }
}
