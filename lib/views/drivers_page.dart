import 'package:flutter/material.dart';
import 'package:f1_app/controllers/drivers_controller.dart';
import 'package:f1_app/models/driver.dart';
import 'package:f1_app/views/driver_details_page.dart';

class DriversPage extends StatefulWidget {
  final String season;

  const DriversPage({required this.season});

  @override
  _DriversPageState createState() => _DriversPageState();
}

class _DriversPageState extends State<DriversPage> {
  final DriversController _controller = DriversController();
  List<Driver> drivers = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchDrivers();
  }

  Future<void> _fetchDrivers() async {
    setState(() {
      isLoading = true;
    });

    try {
      final newDrivers = await _controller.fetchDrivers(widget.season);
      setState(() {
        drivers = newDrivers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  Future _getFlag(String nationality) async {
    return await _controller.fetchNationalityFlag(nationality);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.season} Versenyzők'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: drivers.length,
              itemBuilder: (context, index) {
                final driver = drivers[index];
                return FutureBuilder(
                    future: _getFlag(drivers[index].nationality),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                              )),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Hiba történt');
                      } else {
                        return ListTile(
                            title: Text(driver.fullName),
                            subtitle: Text(snapshot.data),
                            trailing: driver.permanentNumber != null
                                ? Text('Rajtszám: ${driver.permanentNumber}')
                                : Text('Nincs rajtszám'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DriverDetailsPage(
                                      driverId: driver.driverId),
                                ),
                              );
                            });
                      }
                    });
              }),
    );
  }
}
