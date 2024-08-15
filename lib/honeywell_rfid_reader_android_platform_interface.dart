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
}
