import 'package:flutter/material.dart';
import 'package:qr_reader_app/src/bloc/scans_bloc.dart';
import 'package:qr_reader_app/src/utils/utils.dart' as utils;
import '../models/scan_model.dart';

class MapsListPage extends StatelessWidget {
  final scansBloc = ScansBloc();

  @override
  Widget build(BuildContext context) {
    scansBloc.getScans();
    return StreamBuilder(
      stream: scansBloc.scansStreamGeo,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if (snapshot.hasData) {
          final scans = snapshot.data;
          if (scans.length == 0) {
            return Center(
              child: Text('No data to show'),
            );
          }
          return _listView(scans);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _listView(List<ScanModel> scans) {
    return ListView.builder(
      itemCount: scans.length,
      itemBuilder: (context, i) => Dismissible(
        key: UniqueKey(),
        background: Container(color: Colors.red),
        onDismissed: (direction) => scansBloc.deleteScan(scans[i].id),
        child: ListTile(
          leading: Icon(
            Icons.map,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(scans[i].value),
          subtitle: Text('ID: ${scans[i].id}'),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: Colors.grey,
          ),
          onTap: () => utils.openScan(context, scans[i]),
        ),
      ),
    );
  }
}
