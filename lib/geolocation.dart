ximport 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:haversine/haversine.dart';

class GetLocationPage extends StatefulWidget {
  @override
  _GetLocationPageState createState() => _GetLocationPageState();
}

class _GetLocationPageState extends State<GetLocationPage> {
  var location = new Location();

  Map<String, double> userLocation;

  double localiza;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: new Text("Localização",
            style: TextStyle(color: Colors.white, shadows: <Shadow>[
              Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 8.0,
                  color: Colors.black54)
            ])),
        backgroundColor: new Color.fromARGB(127, 0, 243, 255),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () {
                  _getLocation().then((value) {
                    setState(() {
                      userLocation = value;
                      localizacao();
                    });
                  });
                },
                color: Color.fromARGB(127, 0, 243, 255),
                child: Text(
                  "Você está em",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            userLocation == null
                ? CircularProgressIndicator()
                : Text("Localização:" +
                    userLocation["latitude"].toString() +
                    " " +
                    userLocation["longitude"].toString() +
                    "\n\nKM entre eles:$localiza")
          ],
        ),
      ),
    );
  }

  Future<Map<String, double>> _getLocation() async {
    var currentLocation = <String, double>{};
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  void localizacao() {
    final lat1 = userLocation["latitude"];
    final lon1 = userLocation["longitude"];
    final lat2 = -20.8118; //Rio preto
    final lon2 = -49.3762; //Rio preto

    final harvesine = new Haversine.fromDegrees(
        latitude1: lat1, longitude1: lon1, latitude2: lat2, longitude2: lon2);

    localiza = harvesine.distance() * 0.001;
  }
}
