import 'dart:collection';

import 'package:honeywell_rfid_reader_android/model/bluetooh_device_info.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'honeywell_rfid_reader_android_method_channel.dart';

abstract class HoneywellRfidReaderAndroidPlatform extends PlatformInterface {
  /// Constructs a HoneywellRfidReaderAndroidPlatform.
  HoneywellRfidReaderAndroidPlatform() : super(token: _token);

  static final Object _token = Object();

  static HoneywellRfidReaderAndroidPlatform _instance = MethodChannelHoneywellRfidReaderAndroid();

  /// The default instance of [HoneywellRfidReaderAndroidPlatform] to use.
  ///
  /// Defaults to [MethodChannelHoneywellRfidReaderAndroid].
  static HoneywellRfidReaderAndroidPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HoneywellRfidReaderAndroidPlatform] when
  /// they register themselves.
  static set instance(HoneywellRfidReaderAndroidPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> createReader() {
    throw UnimplementedError('createReader() has not been implemented.');
  }

  Future<void> connectReader() {
    throw UnimplementedError('connectReader() has not been implemented.');
  }

  Future<void> disconnect() {
    throw UnimplementedError('disconnect() has not been implemented.');
  }

  Future<void> startListening() {
    throw UnimplementedError('startListening() has not been implemented.');
  }

  Future<void> searchBluetoothDevices() {
    throw UnimplementedError('searchBluetoothDevices() has not been implemented.');
  }

  Future<void> onDevicesUpdated() {
    throw UnimplementedError('onDevicesUpdated() has not been implemented.');
  }

  Future<bool> isBluetoothPermissionGranted() {
    throw UnimplementedError('isBluetoothPermissionGranted() has not been implemented.');
  }

  Future<List<HashMap<String, dynamic>>> getAvailableBluetoothDevices() {
    throw UnimplementedError('getAvailableBluetoothDevices() has not been implemented.');
  }

  Future<void> readRfid() {
    throw UnimplementedError('readRfid() has not been implemented.');
  }

  void connectionStatusChanged() {
    throw UnimplementedError('connectionStatusChanged() has not been implemented.');
  }
}
