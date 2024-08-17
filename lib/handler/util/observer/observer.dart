import 'package:honeywell_rfid_reader_android/model/connection_status.dart';

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

  final List<Observer> _observers = [];
}
