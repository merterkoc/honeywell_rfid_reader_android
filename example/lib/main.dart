import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:honeywell_rfid_reader_android/honeywell_rfid_reader_android.dart';
import 'package:honeywell_rfid_reader_android/model/bluetooh_device_info.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  PermissionStatus? _bluetoothPermissionStatus;
  final _honewayPlugin = HoneywellRfidReaderAndroid();
  PermissionStatus? _permissionStatus;
  List<HashMap<String, dynamic>>? _devices;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initPermission();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    _honewayPlugin.connectionStatusChanged();
  }

  void initPermission() {
    Permission.location.request().then((value) {
      setState(() {
        _permissionStatus = value;
      });
    }).catchError((error) {
      print('Permission denied');
      _permissionStatus = PermissionStatus.denied;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Text(
                'Location Permission Status: ${_permissionStatus?.toString()}'),
            ElevatedButton(
              onPressed: () async {
                final hashMap =
                    await _honewayPlugin.getAvailableBluetoothDevices();
                setState(() {
                  _devices = hashMap;
                });
              },
              child: const Text('Get Available Bluetooth Devices'),
            ),
            Text('Available Bluetooth Devices: ${_devices?.length}'),
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            ElevatedButton(
              onPressed: () async {
                _honewayPlugin.createReader();
              },
              child: const Text('Create Reader'),
            ),
            ElevatedButton(
              onPressed: () async {
                _honewayPlugin.connectReader();
              },
              child: const Text('Connect Reader'),
            ),
            ElevatedButton(
              onPressed: () async {
                _honewayPlugin.disconnect();
              },
              child: const Text('Disconnect Reader'),
            ),
            ElevatedButton(
              onPressed: () async {
                _honewayPlugin.startListening();
              },
              child: const Text('Start Listening'),
            ),
            ElevatedButton(
              onPressed: () async {
                _honewayPlugin.searchBluetoothDevices();
              },
              child: const Text('Search Bluetooth Devices'),
            ),
            ElevatedButton(
              onPressed: () async {
                final device = _honewayPlugin.onDevicesUpdated();
              },
              child: const Text('Update Devices'),
            ),
            ElevatedButton(
              onPressed: () async {
                final status = await Permission.bluetooth.request();
                print('Is Bluetooth Permission Granted: $status');
                setState(() {
                  _bluetoothPermissionStatus = status;
                });
              },
              child: Text(
                  'Location Permission Status: ${_bluetoothPermissionStatus?.toString()}'),
            ),
            ElevatedButton(
              onPressed: () async {
                _honewayPlugin.readRfid();
              },
              child: const Text('Read RFID'),
            ),
          ],
        ),
      ),
    );
  }
}
