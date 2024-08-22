import 'package:honeywell_rfid_reader_android/model/connection_status.dart';
import 'package:honeywell_rfid_reader_android/model/my_bluetooth_device.dart';

class Observer {
  void addObserver(Observer observer) {
    _observers.add(observer);
  }

  void removeObserver(Observer observer) {
    _observers.remove(observer);
  }

  void notifyConnectionStatus(ConnectionStatus status) {
    for (final observer in _observers) {
      observer.notifyConnectionStatus(status);
    }
  }

  void notifyTagRead(String tagRead) {
    for (final observer in _observers) {
      observer.notifyTagRead(tagRead);
    }
  }

  void notifyReadStatus({required bool isReading}) {
    for (final observer in _observers) {
      observer.notifyReadStatus(isReading: isReading);
    }
  }

  void notifyBluetoothDeviceFound(MyBluetoothDevice device) {
    for (final observer in _observers) {
      observer.notifyBluetoothDeviceFound(device);
    }
  }

  final List<Observer> _observers = [];
}
