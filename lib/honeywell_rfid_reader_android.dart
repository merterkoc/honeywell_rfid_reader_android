import 'package:honeywell_rfid_reader_android/honeywell_rfid_reader_platform_interface.dart';
import 'package:honeywell_rfid_reader_android/model/my_blueetooth_device.dart';

class HoneywellRfidReaderAndroid implements HoneywellRfidReaderPlatform {
  static HoneywellRfidReaderPlatform get instance =>
      HoneywellRfidReaderPlatform.instance;

  @override
  Future<void> initialize() {
    return instance.initialize();
  }

  @override
  Future<void> scanBluetoothDevices({bool bluetoothAutoConnect = false}) {
    return instance.scanBluetoothDevices(
      bluetoothAutoConnect: bluetoothAutoConnect,
    );
  }

  @override
  Future<void> disableScanBluetoothDevices() {
    return instance.disableScanBluetoothDevices();
  }

  @override
  Future<void> disconnectDevice() async {
    await instance.disconnectDevice();
  }

  @override
  Future<void> createReader() async {
    await instance.createReader();
  }

  @override
  Future<void> readStart() async {
    await instance.readStart();
  }

  @override
  Future<void> readStop() async {
    await instance.readStop();
  }

  @override
  Future<void> bluetoothDisable() async {
    await instance.bluetoothDisable();
  }

  @override
  Future<void> bluetoothEnable() async {
    await instance.bluetoothEnable();
  }

  @override
  Future<bool> bluetoothState() async {
    return instance.bluetoothState();
  }

  @override
  Future<bool> isConnected() async {
    return instance.isConnected();
  }

  @override
  Future<void> connectDevice(MyBluetoothDevice device) async {
    return instance.connectDevice(device);
  }

  @override
  Future<void> connectUsbDevice() async {
    return instance.connectUsbDevice();
  }

  @override
  Future<void> disconnectUsbDevice() async {
    return instance.disconnectUsbDevice();
  }
}
