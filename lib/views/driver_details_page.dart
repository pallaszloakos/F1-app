import 'package:flutter/material.dart';
import 'package:f1_app/controllers/driver_details_controller.dart';
import 'package:f1_app/models/driver.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverDetailsPage extends StatefulWidget {
  final String driverId;

  const DriverDetailsPage({required this.driverId});

  @override
  _DriverDetailsPageState createState() => _DriverDetailsPageState();
}

class _DriverDetailsPageState extends State<DriverDetailsPage> {
  final DriverDetailsController _controller = DriverDetailsController();
  Driver? driver;
  bool isLoading = false;
  String? imageUrl;
  String flag = '';

  @override
  void initState() {
    super.initState();
    _fetchDriverDetails();
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future _fetchDriverImage(name) async {
    imageUrl = await _controller.fetchDriverImage(name);
  }

  Future _getFlag(String nationality) async {
    flag = await _controller.fetchNationalityFlag(nationality);
  }

  Future<void> _fetchDriverDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      final newDriver = await _controller.fetchDriverDetails(widget.driverId);
      setState(() {
        driver = newDriver;
        _fetchDriverImage(driver!.fullName);
        _getFlag(driver!.nationality);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(driver?.fullName ?? ' adatai'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : driver != null
              ? Column(
                  children: [
                    if (imageUrl != null)
                      Image.network(imageUrl!)
                    else
                      CircularProgressIndicator(),
                    SizedBox(height: 16.0),
                    Text(
                      driver!.fullName,
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    if (flag != null)
                      Text(
                        flag,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    SizedBox(height: 8.0),
                    Text(
                      'Született: ${driver!.dateOfBirth}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Rajszám: ${driver!.permanentNumber}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Kód: ${driver!.code}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton.icon(
                      onPressed: () => _launchURL('${driver!.url}'),
                      icon: Icon(Icons.info),
                      label: Text('További info a Wikipedián'),
                    ),
                  ],
                )
              : Center(child: Text('Versenyző nem található')),
    );
  }
}
