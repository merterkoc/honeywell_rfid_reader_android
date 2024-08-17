import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:honeywell_rfid_reader_android/constants/channel_address.dart';

import 'package:honeywell_rfid_reader_android/honeywell_rfid_reader_platform_interface.dart';

/// An implementation of [HoneywellRfidReaderPlatform] that uses method
/// channels.
class MethodChannelHoneywellRfidReaderAndroid
    extends HoneywellRfidReaderPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = MethodChannel(ChannelAddress.MAIN_CHANNEL.name);

  @visibleForTesting
  final EventChannel eventChannel =
      EventChannel(ChannelAddress.ON_TAG_READ.name);

  @override
  Future<void> initialize() {
    return methodChannel.invokeMethod('initialize');
  }

  @override
  Future<void> scanBluetoothDevices({bool bluetoothAutoConnect = false}) {
    return methodChannel.invokeMethod(
      'scanBluetoothDevices',
      bluetoothAutoConnect,
    );
  }

  @override
  Future<void> disableScanBluetoothDevices() {
    return methodChannel.invokeMethod('disableScanBluetoothDevices');
  }

  @override
  Future<void> disconnectDevice() async {
    await methodChannel.invokeMethod('disconnectDevice');
  }

  @override
  Future<void> createReader() {
    return methodChannel.invokeMethod('createReader');
  }
}
