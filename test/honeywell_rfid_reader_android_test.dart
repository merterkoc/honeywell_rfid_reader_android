import 'package:flutter_test/flutter_test.dart';
import 'package:honeywell_rfid_reader_android/honeywell_rfid_reader_android.dart';
import 'package:honeywell_rfid_reader_android/honeywell_rfid_reader_android_platform_interface.dart';
import 'package:honeywell_rfid_reader_android/honeywell_rfid_reader_android_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHoneywellRfidReaderAndroidPlatform
    with MockPlatformInterfaceMixin
    implements HoneywellRfidReaderAndroidPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final HoneywellRfidReaderAndroidPlatform initialPlatform = HoneywellRfidReaderAndroidPlatform.instance;

  test('$MethodChannelHoneywellRfidReaderAndroid is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelHoneywellRfidReaderAndroid>());
  });

  test('getPlatformVersion', () async {
    HoneywellRfidReaderAndroid honeywellRfidReaderAndroidPlugin = HoneywellRfidReaderAndroid();
    MockHoneywellRfidReaderAndroidPlatform fakePlatform = MockHoneywellRfidReaderAndroidPlatform();
    HoneywellRfidReaderAndroidPlatform.instance = fakePlatform;

    expect(await honeywellRfidReaderAndroidPlugin.getPlatformVersion(), '42');
  });
}
