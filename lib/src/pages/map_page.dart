import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qr_reader_app/src/models/scan_model.dart';
import 'package:latlong/latlong.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final map = new MapController();

  String mapType = 'streets';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("QR Coordinates"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              map.move(scan.getLatLng(), 17);
            },
          )
        ],
      ),
      body: _showFullMap(scan),
      floatingActionButton: _floatingActionButton(context),
    );
  }

  Widget _showFullMap(ScanModel scan) {
    return FlutterMap(
        mapController: map,
        options: MapOptions(
          center: scan.getLatLng(),
          zoom: 15,
        ),
        layers: [
          _showMapLayer(),
          _showPin(scan),
        ]);
  }

  TileLayerOptions _showMapLayer() {
    return TileLayerOptions(
        urlTemplate: 'https://api.mapbox.com/v4/'
            '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
        additionalOptions: {
          'accessToken':
              'pk.eyJ1IjoiY2hyaXN1cmV6YSIsImEiOiJjazhwNWFwbmkwMmdhM2hvOXZ2NDN4dHp5In0.bCYWgvRCe6gYK3Knc7Ctiw',
          'id': 'mapbox.$mapType', // streets, dark, light, outdoors, satellite
        });
  }

  MarkerLayerOptions _showPin(ScanModel scan) {
    return MarkerLayerOptions(markers: <Marker>[
      Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
                  child: Icon(
                Icons.location_on,
                size: 45.0,
                color: Theme.of(context).primaryColor,
              ))),
    ]);
  }

  FloatingActionButton _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        // streets, dark, light, outdoors, satellite
        setState(() {
          if (mapType == 'streets') {
            mapType = 'dark';
          } else if (mapType == 'dark') {
            mapType = 'light';
          } else if (mapType == 'light') {
            mapType = 'outdoors';
          } else if (mapType == 'outdoors') {
            mapType = 'satellite';
          } else {
            mapType = 'streets';
          }
        });
      },
    );
  }
}
