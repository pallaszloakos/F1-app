import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_emoji/flutter_emoji.dart';


class DriverDetailPage extends StatefulWidget {
  final String driverId;
  final String name;
  final String nationality;
  final String birthDate;
  final String number;
  final String code;

  DriverDetailPage({
    required this.driverId,
    required this.name,
    required this.nationality,
    required this.birthDate,
    required this.number,
    required this.code,
  });

  @override
  _DriverDetailPageState createState() => _DriverDetailPageState();
}

class _DriverDetailPageState extends State<DriverDetailPage> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchDriverImage();
  }

  String getNationalityEmoji(String nationality) {
	var parser = EmojiParser();
	return parser.get(nationality.toLowerCase())
  }

  void _launchURL(String driverId) async {
    final url = 'https://en.wikipedia.org/wiki/$driverId';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _fetchDriverImage() async {
    final apiKey = 'AIzaSyADx9HTfg1vEtKt2KllxBhwpjB5qUvO52k';
    final engineKey = '000213537299717655806:fsqehiydnxg';
    final searchQuery = widget.name;

    final url = Uri.parse(
        'https://www.googleapis.com/customsearch/v1?key=$apiKey&cx=$engineKey&q=$searchQuery');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['items'] != null &&
          data['items'][0]['pagemap']['cse_image'] != null) {
        setState(() {
          imageUrl = data['items'][0]['pagemap']['cse_image'][0]['src'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.name} Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (imageUrl != null)
              Image.network(imageUrl!)
            else
              CircularProgressIndicator(),
            SizedBox(height: 16.0),
            Text(
              widget.name,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              '${getNationalityEmoji(widget.nationality)} ${widget.nationality}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Born: ${widget.birthDate}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Number: ${widget.number}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Code: ${widget.code}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () => _launchURL(widget.driverId),
              icon: Icon(Icons.info),
              label: Text('More info on Wikipedia'),
            ),
          ],
        ),
      ),
    );
  }
}
        