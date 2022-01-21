import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_reader_app/src/utils/utils.dart' as utils;
import '../models/scan_model.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qr_reader_app/src/bloc/scans_bloc.dart';
import 'package:qr_reader_app/src/pages/directions_list_page.dart';
import 'package:qr_reader_app/src/pages/maps_list_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = ScansBloc();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Reader'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.deleteAllScans,
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'about',
                  child: Text('About'),
                ),
              ];
            },
            onSelected: (result) {
              switch (result) {
                case 'about':
                  Navigator.pushNamed(context, 'about');
                  break;
              }
            },
          ),
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _mainBottomNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _scanQR(BuildContext context) async {
    // Testing values:
    // https://chrisureza.com
    // geo:9.915461103865884,-84.17937770327457

    String futureString;

    try {
      futureString = await BarcodeScanner.scan();
    } catch (e) {
      futureString = e.toString();
    }

    if (futureString != null) {
      final scan = ScanModel(value: futureString);
      scansBloc.addScan(scan);

      if (Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750), () {
          utils.openScan(context, scan);
        });
      } else {
        utils.openScan(context, scan);
      }
    }
  }

  Widget _callPage(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return MapsListPage();
      case 1:
        return DirectionsListPage();
      default:
        return MapsListPage();
    }
  }

  Widget _mainBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Map'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cloud_queue),
          title: Text('Directions'),
        ),
      ],
    );
  }
}
