import 'package:flutter/services.dart';
import 'package:honeywell_rfid_reader_android/constants/channel_address.dart';
import 'package:honeywell_rfid_reader_android/handler/util/observer/observer.dart';
import 'package:honeywell_rfid_reader_android/handler/util/observer/observer_list.dart';
import 'package:honeywell_rfid_reader_android/model/connection_status.dart';

class HandleMethod extends ObserverList {
  static final MethodChannel _channel =
      MethodChannel(ChannelAddress.MAIN_CHANNEL.name);

  static void initialize(Observer observer) {
    _channel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'RFID_CONNECTION_STATUS_CHANGED':
          observer.notifyConnectionStatus(
            ConnectionStatus.values[
                (call.arguments as Map<dynamic, dynamic>)['status'] as int],
          );
        default:
          throw MissingPluginException('Method not implemented');
      }
    });
  }
}

class HandleEvent extends ObserverList {
  static final EventChannel _channel =
      EventChannel(ChannelAddress.ON_TAG_READ.name);

  static void initialize(Observer observer) {
    _channel.receiveBroadcastStream().listen((dynamic event) {
      if (event is String) {
        observer.notifyTagRead(event);
      } else {
        throw Exception('Invalid event value');
      }
    });
  }
}
