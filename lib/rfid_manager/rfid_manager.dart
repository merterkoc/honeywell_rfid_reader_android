import 'dart:async';

import 'package:honeywell_rfid_reader_android/handler/handle_method.dart';
import 'package:honeywell_rfid_reader_android/handler/util/observer/observer.dart';
import 'package:honeywell_rfid_reader_android/honeywell_rfid_reader_platform_interface.dart';
import 'package:honeywell_rfid_reader_android/model/connection_status.dart';
import 'package:permission_handler/permission_handler.dart';

class RFIDManager extends Observer {
  factory RFIDManager() {
    _instance ??= RFIDManager._internal();
    _honeywellPlugin = HoneywellRfidReaderPlatform.instance;
    HandleMethod.initialize(_instance!);
    HandleEvent.initialize(_instance!);
    return _instance!;
  }

  RFIDManager._internal();

  static late final HoneywellRfidReaderPlatform _honeywellPlugin;

  static RFIDManager? _instance;

  final _connectionStatusChanged =
      StreamController<ConnectionStatus>.broadcast();

  Stream<ConnectionStatus> get connectionStatusChangedStream =>
      _connectionStatusChanged.stream;

  final _tagRead = StreamController<String>.broadcast();

  Stream<String> get tagReadStream => _tagRead.stream;

  Future<void> initialize() async {
    await _honeywellPlugin.initialize();
  }

  Future<void> scanBluetoothDevices({bool bluetoothAutoConnect = false}) async {
    const permission = Permission.bluetoothScan;
    const Permission locationPermission = Permission.location;
    if (await permission.request().isGranted &&
        await locationPermission.request().isGranted) {
      return _honeywellPlugin.scanBluetoothDevices(
        bluetoothAutoConnect: bluetoothAutoConnect,
      );
    }
    throw Exception('Permission not granted');
  }

  Future<void> disableScanBluetoothDevices() async {
    return _honeywellPlugin.disableScanBluetoothDevices();
  }

  Future<void> disconnectDevice() async {
    await _honeywellPlugin.disconnectDevice();
  }

  Future<void> createReader() async {
    await _honeywellPlugin.createReader();
  }

  Future<void> readStart() async {
    await _honeywellPlugin.readStart();
  }

  Future<void> readStop() async {
    await _honeywellPlugin.readStop();
  }


  @override
  void notifyConnectionStatus(ConnectionStatus status) {
    _connectionStatusChanged.add(status);
  }

  @override
  void notifyTagRead(String tagRead) {
    _tagRead.add(tagRead);
  }
}
