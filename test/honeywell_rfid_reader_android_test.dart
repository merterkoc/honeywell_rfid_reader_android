// import 'dart:collection';
//
// import 'package:flutter_test/flutter_test.dart';
// import 'package:honeywell_rfid_reader_android/honeywell_rfid_reader_android.dart';
// import 'package:honeywell_rfid_reader_android/honeywell_rfid_reader_android_platform_interface.dart';
// import 'package:honeywell_rfid_reader_android/honeywell_rfid_reader_android_method_channel.dart';
// import 'package:honeywell_rfid_reader_android/model/bluetooh_device_info.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockHoneywellRfidReaderAndroidPlatform
//     with MockPlatformInterfaceMixin
//     implements HoneywellRfidReaderAndroidPlatform {
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
//
//   @override
//   Future<void> connectReader() {
//     // TODO: implement connectReader
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> createReader() {
//     // TODO: implement createReader
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> disconnect() {
//     // TODO: implement disconnect
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<bool> isBluetoothPermissionGranted() {
//     // TODO: implement isBluetoothPermissionGranted
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> onDevicesUpdated() {
//     // TODO: implement onDevicesUpdated
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> searchBluetoothDevices() {
//     // TODO: implement searchBluetoothDevices
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> startListening() {
//     // TODO: implement startListening
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<List<HashMap<String, dynamic>>> getAvailableBluetoothDevices() {
//     // TODO: implement getAvailableBluetoothDevices
//       throw UnimplementedError();
//   }
//
//   @override
//   Future<void> readRfid() {
//     // TODO: implement readRfid
//     throw UnimplementedError();
//   }
//
// }
//
// void main() {
//   final HoneywellRfidReaderAndroidPlatform initialPlatform =
//       HoneywellRfidReaderAndroidPlatform.instance;
//
//   test('$MethodChannelHoneywellRfidReaderAndroid is the default instance', () {
//     expect(initialPlatform,
//         isInstanceOf<MethodChannelHoneywellRfidReaderAndroid>());
//   });
//
//   test('getPlatformVersion', () async {
//     HoneywellRfidReaderAndroid honeywellRfidReaderAndroidPlugin =
//         HoneywellRfidReaderAndroid();
//     MockHoneywellRfidReaderAndroidPlatform fakePlatform =
//         MockHoneywellRfidReaderAndroidPlatform();
//     HoneywellRfidReaderAndroidPlatform.instance = fakePlatform;
//
//     expect(await honeywellRfidReaderAndroidPlugin.getPlatformVersion(), '42');
//   });
// }
