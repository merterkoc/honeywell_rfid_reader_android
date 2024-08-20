import 'dart:io';

import 'package:honeywell_rfid_reader_android/honeywell_rfid_reader_android_method_channel.dart';
import 'package:honeywell_rfid_reader_android/model/my_blueetooth_device.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class HoneywellRfidReaderPlatform extends PlatformInterface {
  /// Constructs a HoneywellRfidReaderAndroidPlatform.
  HoneywellRfidReaderPlatform() : super(token: _token);

  static final Object _token = Object();

  static HoneywellRfidReaderPlatform _instance = Platform.isAndroid
      ? MethodChannelHoneywellRfidReaderAndroid()
      : throw UnsupportedError('Not supported');

  /// The default instance of [HoneywellRfidReaderPlatform] to use.
  ///
  /// Defaults to [MethodChannelHoneywellRfidReaderAndroid].
  static HoneywellRfidReaderPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HoneywellRfidReaderPlatform] when
  /// they register themselves.
  static set instance(HoneywellRfidReaderPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> initialize();

  Future<void> scanBluetoothDevices({bool bluetoothAutoConnect = false});

  Future<void> disableScanBluetoothDevices();

  Future<void> disconnectDevice();

  Future<void> createReader();

  Future<void> readStart();

  Future<void> readStop();

  Future<bool> bluetoothState();

  Future<void> bluetoothEnable();

  Future<void> bluetoothDisable();

  Future<bool> isConnected();

  Future<void> connectDevice(MyBluetoothDevice device);
}
