import 'package:flutter/material.dart';
import 'services/api_service.dart';

class DriversPage extends StatefulWidget {
  final String season;

  DriversPage({required this.season});

  @override
  _DriversPageState createState() => _DriversPageState();
}

class _DriversPageState extends State<DriversPage> {
  final ApiService apiService = ApiService();
  late Future<List<String>> drivers;

  @override
  void initState() {
    super.initState();
    drivers = apiService.fetchDriversBySeason(widget.season);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.season} versenyzők'),
      ),
      body: FutureBuilder<List<String>>(
        future: drivers,
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
              );
            },
          );
        },
      ),
    );
  }
}
