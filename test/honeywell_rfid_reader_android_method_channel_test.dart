import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:honeywell_rfid_reader_android/honeywell_rfid_reader_android_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelHoneywellRfidReaderAndroid platform = MethodChannelHoneywellRfidReaderAndroid();
  const MethodChannel channel = MethodChannel('honeywell_rfid_reader_android');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
