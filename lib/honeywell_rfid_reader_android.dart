
import 'honeywell_rfid_reader_android_platform_interface.dart';

class HoneywellRfidReaderAndroid {
  Future<String?> getPlatformVersion() {
    return HoneywellRfidReaderAndroidPlatform.instance.getPlatformVersion();
  }
}
