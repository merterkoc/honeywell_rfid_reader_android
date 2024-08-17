import 'package:flutter_test/flutter_test.dart';
import 'package:honeywell_rfid_reader_android/honeywell_rfid_reader_android_method_channel.dart';
import 'package:honeywell_rfid_reader_android/honeywell_rfid_reader_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHoneywellRfidReaderAndroidPlatform
    with MockPlatformInterfaceMixin
    implements HoneywellRfidReaderPlatform {
  void main() {
    final initialPlatform = HoneywellRfidReaderPlatform.instance;

    test('$MethodChannelHoneywellRfidReaderAndroid is the default instance',
        () {
      expect(
        initialPlatform,
        isInstanceOf<MethodChannelHoneywellRfidReaderAndroid>(),
      );
    });

    test('getPlatformVersion', () async {
      final fakePlatform = MockHoneywellRfidReaderAndroidPlatform();
      HoneywellRfidReaderPlatform.instance = fakePlatform;
    });
  }

  @override
  Future<void> disconnectDevice() {
    // TODO(mert): implement disconnectDevice
    throw UnimplementedError();
  }

  @override
  Future<void> initialize() {
    // TODO(mert): implement initialize
    throw UnimplementedError();
  }

  @override
  Future<void> scanBluetoothDevices({bool bluetoothAutoConnect = false}) {
    // TODO(mert): implement scanBluetoothDevices
    throw UnimplementedError();
  }

  @override
  Future<void> disableScanBluetoothDevices() {
    // TODO: (mert) implement disableScanBluetoothDevices
    throw UnimplementedError();
  }

  @override
  Future<void> createReader() {
    // TODO(mert): implement createReader
    throw UnimplementedError();
  }
}
