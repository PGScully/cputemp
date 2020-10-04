import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceScreen extends StatelessWidget {
  final BluetoothDevice device;
  const DeviceScreen({
    Key key,
    this.device,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(device.toString()),
        ),
      );
}
