import 'package:flutter/material.dart';
import 'package:f1_app/controllers/seasons_controller.dart';
import 'package:f1_app/models/season.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:f1_app/views/drivers_page.dart';

class SeasonsPage extends StatefulWidget {
  @override
  _SeasonsPageState createState() => _SeasonsPageState();
}

class _SeasonsPageState extends State<SeasonsPage> {
  final SeasonsController _controller = SeasonsController();
  List<Season> seasons = [];
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchSeasons();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading) {
        _fetchSeasons();
      }
    });
  }

  Future<void> _fetchSeasons() async {
    setState(() {
      isLoading = true;
    });

    try {
      final newSeasons = await _controller.fetchSeasons();
      setState(() {
        seasons.addAll(newSeasons);
        _controller.nextPage();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('F1 Szezonok'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: seasons.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == seasons.length) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final season = seasons[index];
          return ListTile(
            title: Text(season.season),
            trailing: IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                launch(season.url);
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DriversPage(season: season.season),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
