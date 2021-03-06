import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:bt_sense_hat/bluetooth_constants.dart';
import 'package:bt_sense_hat/ui_scan/connected_device_tile.dart';
import 'package:bt_sense_hat/ui_scan/scan_result_tile.dart';

class FindDevicesScreen extends StatelessWidget {
  // TODO: Automatically start the first scan on startup

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Devices"),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        floatingActionButton: StreamBuilder<bool>(
          stream: FlutterBlue.instance.isScanning,
          initialData: false,
          builder: (_, snapshot) {
            if (snapshot.data!) {
              return FloatingActionButton(
                onPressed: () => FlutterBlue.instance.stopScan(),
                backgroundColor: Colors.red,
                child: const Icon(Icons.stop),
              );
            } else {
              return FloatingActionButton(
                onPressed: () => FlutterBlue.instance.startScan(
                  withServices: [
                    environmentSensorService,
                  ],
                  timeout: const Duration(seconds: 4),
                ),
                child: const Icon(Icons.search),
              );
            }
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListTile(
                  title: Text(
                'Connected Devices',
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              )),
              // style: title,
              const ConnectedDevices(),
              ListTile(
                  title: Text(
                "Scan Results",
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              )),
              const ScanResults(),
            ],
          ),
        ),
      );
}

class ConnectedDevices extends StatelessWidget {
  const ConnectedDevices({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<List<BluetoothDevice>>(
        stream: Stream<void>.periodic(const Duration(seconds: 2))
            .asyncMap((_) => FlutterBlue.instance.connectedDevices),
        initialData: const [],
        builder: (_, snapshot) => Column(
          children: snapshot.data!
              .map((device) => ConnectedDeviceTile(device: device))
              .toList(),
        ),
      );
}

class ScanResults extends StatelessWidget {
  const ScanResults({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<List<ScanResult>>(
        stream: FlutterBlue.instance.scanResults,
        initialData: const [],
        builder: (_, snapshot) => Column(
          children:
              snapshot.data!.map((r) => ScanResultTile(result: r)).toList(),
        ),
      );
}
