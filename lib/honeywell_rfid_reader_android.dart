import 'dart:collection';

import 'package:honeywell_rfid_reader_android/model/bluetooh_device_info.dart';

import 'honeywell_rfid_reader_android_platform_interface.dart';

class HoneywellRfidReaderAndroid {
  void connectionStatusChanged() {
    HoneywellRfidReaderAndroidPlatform.instance.connectionStatusChanged();
  }

  void createReader() {
    HoneywellRfidReaderAndroidPlatform.instance.createReader();
  }

  void connectReader() {
    HoneywellRfidReaderAndroidPlatform.instance.connectReader();
  }

  void disconnect() {
    HoneywellRfidReaderAndroidPlatform.instance.disconnect();
  }

  void startListening() {
    HoneywellRfidReaderAndroidPlatform.instance.startListening();
  }

  Future<void> searchBluetoothDevices() async {
    await HoneywellRfidReaderAndroidPlatform.instance.searchBluetoothDevices();
  }

  Future<void> onDevicesUpdated() async {
    await HoneywellRfidReaderAndroidPlatform.instance.onDevicesUpdated();
  }

  Future<bool> isBluetoothPermissionGranted() {
    return HoneywellRfidReaderAndroidPlatform.instance
        .isBluetoothPermissionGranted();
  }

  Future<List<HashMap<String, dynamic>>> getAvailableBluetoothDevices() {
    return HoneywellRfidReaderAndroidPlatform.instance
        .getAvailableBluetoothDevices();
  }

  Future<void> readRfid() {
    return HoneywellRfidReaderAndroidPlatform.instance.readRfid();
  }
}
