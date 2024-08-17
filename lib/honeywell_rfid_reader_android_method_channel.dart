import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:honeywell_rfid_reader_android/model/bluetooh_device_info.dart';

import 'honeywell_rfid_reader_android_platform_interface.dart';

/// An implementation of [HoneywellRfidReaderAndroidPlatform] that uses method channels.
class MethodChannelHoneywellRfidReaderAndroid
    extends HoneywellRfidReaderAndroidPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('honeywell_rfid_reader_android');

  final EventChannel eventChannel =
      const EventChannel('honeywell_rfid_reader_android/onTagRead');
  final EventChannel connectionStatusChannel =
      const EventChannel('RFID_CONNECTION_STATUS_CHANGED');

  void startListenTag() {
    connectionStatusChannel.receiveBroadcastStream().listen((event) {
      print(event);
    });

    eventChannel.receiveBroadcastStream().listen((event) {
      print(event);
    });
  }

  void startListenConnectionStatus() {}

  @override
  Stream<dynamic> connectionStatusChanged() {
    return connectionStatusChannel.receiveBroadcastStream();
  }

  @override
  Future<void> createReader() async {
    await methodChannel.invokeMethod('createReader');
  }

  @override
  Future<void> connectReader() async {
    await methodChannel.invokeMethod('connectReader');
  }

  @override
  Future<void> disconnect() async {
    await methodChannel.invokeMethod('disconnect');
  }

  @override
  Future<void> startListening() async {
    await methodChannel.invokeMethod('startListening');
  }

  @override
  Future<void> searchBluetoothDevices() async {
    await methodChannel.invokeMethod('searchBluetoothDevices');
  }

  @override
  Future<void> onDevicesUpdated() async {
    await methodChannel.invokeMethod('onDevicesUpdated');
  }

  @override
  Future<bool> isBluetoothPermissionGranted() async {
    final isGranted =
        await methodChannel.invokeMethod<bool>('isBluetoothPermissionGranted');
    return isGranted!;
  }

  @override
  Future<List<HashMap<String, dynamic>>> getAvailableBluetoothDevices() async {
    final bluetoothDeviceInfo =
        await methodChannel.invokeListMethod<HashMap<String, dynamic>>(
            'getAvailableBluetoothDevices');
    return bluetoothDeviceInfo! as List<HashMap<String, dynamic>>;
  }

  @override
  Future<void> readRfid() async {
    await methodChannel.invokeMethod('readRfid');
    startListenTag();
  }
}
