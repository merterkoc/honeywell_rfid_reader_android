import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'honeywell_rfid_reader_android_platform_interface.dart';

/// An implementation of [HoneywellRfidReaderAndroidPlatform] that uses method channels.
class MethodChannelHoneywellRfidReaderAndroid extends HoneywellRfidReaderAndroidPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('honeywell_rfid_reader_android');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
