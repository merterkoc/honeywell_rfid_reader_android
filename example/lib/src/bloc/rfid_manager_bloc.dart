import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:honeywell_rfid_reader_android_beta/model/connection_status.dart';
import 'package:honeywell_rfid_reader_android_beta/model/my_bluetooth_device.dart';
import 'package:honeywell_rfid_reader_android_beta/rfid_manager/rfid_manager.dart';
import 'package:honeywell_rfid_reader_android_example/src/model/enum/operation_status.dart';
import 'package:honeywell_rfid_reader_android_example/src/model/enum/scanning_status.dart';
import 'package:honeywell_rfid_reader_android_example/src/model/scanner_settings.dart';

part 'rfid_manager_event.dart';

part 'rfid_manager_state.dart';

class RfidManagerBloc extends Bloc<RfidManagerEvent, RfidManagerState> {
  RfidManagerBloc() : super(const RfidManagerState.initial()) {
    on<Initialize>(_initialize);
    on<ChangeSettings>(_changeSettings);
    on<BluetoothConnectionStatusChanged>(_bluetoothConnectionStatusChanged);
    on<CheckBluetoothState>(_checkBluetoothState);
    on<BluetoothEnabledChanged>(_bluetoothEnabledChanged);
    on<ScanBluetoothDevices>(_scanBluetoothDevices);
    on<DisableScanBluetoothDevices>(_disableScanBluetoothDevices);
    on<DisconnectDevice>(_disconnectDevice);
    on<CreateReader>(_createReader);
    on<ReadStart>(_readStart);
    on<ReadStop>(_readStop);
    on<ReadStatusChanged>(_readStatusChanged);
    on<OnTagRead>(_onTagRead);
    on<ClearTags>(_clearTags);
    on<BluetoothDeviceFound>(_bluetoothDeviceFound);
    on<ConnectDevice>(_connectDevice);
    on<ConnectUsbDevice>(_connectUsbDevice);
    on<DisconnectUsbDevice>(_disconnectUsbDevice);

    connectionStatusChangedStream =
        rfidManager.connectionStatusChangedStream.listen((status) {
      add(BluetoothConnectionStatusChanged(status: status));
    });
    tagReadStream = rfidManager.tagReadStream.listen((tagRead) {
      add(OnTagRead(tagRead: tagRead));
    });
    readStatusChangedStream =
        rfidManager.readStatusChangedStream.listen((status) {
      add(ReadStatusChanged(isReading: status));
    });

    bluetoothDeviceFoundStream =
        rfidManager.bluetoothDeviceFoundStream.listen((device) {
      add(BluetoothDeviceFound(device: device));
    });
  }

  final RFIDManager rfidManager = RFIDManager();
  late final StreamSubscription<ConnectionStatus> connectionStatusChangedStream;
  late final StreamSubscription<String> tagReadStream;
  late final StreamSubscription<bool> readStatusChangedStream;
  late final StreamSubscription<MyBluetoothDevice> bluetoothDeviceFoundStream;

  Future<void> _initialize(
    Initialize event,
    Emitter<RfidManagerState> emit,
  ) async {
    rfidManager.initialize();
    add(const CheckBluetoothState());
  }

  Future<void> _scanBluetoothDevices(
    ScanBluetoothDevices event,
    Emitter<RfidManagerState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          startScanBluetoothDevicesStatus: OperationStatus.IN_PROGRESS,
        ),
      );
      await rfidManager.scanBluetoothDevices(
        bluetoothAutoConnect: state.settings.autoConnect,
      );
      emit(
        state.copyWith(
          startScanBluetoothDevicesStatus: OperationStatus.SUCCESS,
          scanBluetoothDevicesStatus: ScanningStatus.SCANNING,
        ),
      );
    } on PlatformException catch (e) {
      emit(
        state.copyWith(
          startScanBluetoothDevicesStatus: OperationStatus.FAILURE,
          scanBluetoothDevicesStatus: ScanningStatus.FAILURE,
          errorMessage: e.message,
        ),
      );
      rethrow;
    }
  }

  FutureOr<void> _disableScanBluetoothDevices(
    DisableScanBluetoothDevices event,
    Emitter<RfidManagerState> emit,
  ) {
    rfidManager.disableScanBluetoothDevices();
  }

  FutureOr<void> _disconnectDevice(
    DisconnectDevice event,
    Emitter<RfidManagerState> emit,
  ) {
    rfidManager.disconnectDevice();
  }

  Future<void> _createReader(
    CreateReader event,
    Emitter<RfidManagerState> emit,
  ) async {
    emit(state.copyWith(createReaderStatus: OperationStatus.IN_PROGRESS));
    try {
      await rfidManager.createReader();
      emit(state.copyWith(createReaderStatus: OperationStatus.SUCCESS));
    } catch (e) {
      emit(state.copyWith(createReaderStatus: OperationStatus.FAILURE));
      rethrow;
    }
  }

  void _readStart(
    ReadStart event,
    Emitter<RfidManagerState> emit,
  ) {
    if (!state.isReadStartAllowed) return;
    rfidManager.readStart();
    add(const ReadStatusChanged(isReading: true));
  }

  void _readStop(
    ReadStop event,
    Emitter<RfidManagerState> emit,
  ) {
    if (!state.isReadStopAllowed) return;
    rfidManager.readStop();
    add(const ReadStatusChanged(isReading: false));
  }

  FutureOr<void> _changeSettings(
    ChangeSettings event,
    Emitter<RfidManagerState> emit,
  ) {
    emit(state.copyWith(settings: event.settings));
  }

  FutureOr<void> _bluetoothConnectionStatusChanged(
    BluetoothConnectionStatusChanged event,
    Emitter<RfidManagerState> emit,
  ) {
    emit(state.copyWith(bluetoothStatus: event.status));
  }

  Future<void> _checkBluetoothState(
    CheckBluetoothState event,
    Emitter<RfidManagerState> emit,
  ) async {
    final bluetoothEnabled = await rfidManager.bluetoothState();
    emit(
      state.copyWith(
        settings: state.settings.copyWith(bluetoothEnabled: bluetoothEnabled),
      ),
    );
  }

  FutureOr<void> _bluetoothEnabledChanged(
    BluetoothEnabledChanged event,
    Emitter<RfidManagerState> emit,
  ) {
    if (event.value) {
      rfidManager.bluetoothEnable();
    } else {
      rfidManager.bluetoothDisable();
    }
    emit(
      state.copyWith(
        settings: state.settings.copyWith(bluetoothEnabled: event.value),
      ),
    );
  }

  FutureOr<void> _onTagRead(OnTagRead event, Emitter<RfidManagerState> emit) {
    final tag = state.tags.toList()..add(event.tagRead);
    emit(state.copyWith(tags: tag.toSet()));
    debugPrint(
      'TAG READIED:${event.tagRead}' 'Total tags:${state.tags.length}',
    );
  }

  FutureOr<void> _readStatusChanged(
    ReadStatusChanged event,
    Emitter<RfidManagerState> emit,
  ) {
    emit(state.copyWith(isReading: event.isReading));
  }

  FutureOr<void> _clearTags(ClearTags event, Emitter<RfidManagerState> emit) {
    emit(state.copyWith(tags: <String>{}));
  }

  FutureOr<void> _bluetoothDeviceFound(
    BluetoothDeviceFound event,
    Emitter<RfidManagerState> emit,
  ) {
    final bluetoothDevices = state.bluetoothDevices.toSet()..add(event.device);
    emit(state.copyWith(bluetoothDevices: bluetoothDevices));
  }

  Future<void> _connectDevice(
    ConnectDevice event,
    Emitter<RfidManagerState> emit,
  ) async {
    emit(
      state.copyWith(manuelDeviceConnectionStatus: OperationStatus.IN_PROGRESS),
    );
    try {
      await rfidManager.connectDevice(event.device);
      emit(
        state.copyWith(manuelDeviceConnectionStatus: OperationStatus.SUCCESS),
      );
    } on Exception {
      emit(
        state.copyWith(manuelDeviceConnectionStatus: OperationStatus.FAILURE),
      );
      rethrow;
    }
  }

  @override
  Future<void> close() async {
    await connectionStatusChangedStream.cancel();
    await tagReadStream.cancel();
    await bluetoothDeviceFoundStream.cancel();
    await readStatusChangedStream.cancel();
    rfidManager.close();
    await super.close();
  }

  FutureOr<void> _connectUsbDevice(
    ConnectUsbDevice event,
    Emitter<RfidManagerState> emit,
  ) async {
    try {
      await rfidManager.connectUsbDevice();
      emit(
        state.copyWith(manuelDeviceConnectionStatus: OperationStatus.SUCCESS),
      );
    } on Exception {
      emit(
        state.copyWith(manuelDeviceConnectionStatus: OperationStatus.FAILURE),
      );
      rethrow;
    }
  }

  FutureOr<void> _disconnectUsbDevice(
    DisconnectUsbDevice event,
    Emitter<RfidManagerState> emit,
  ) async {
    try {
      await rfidManager.disconnectUsbDevice();
      emit(
        state.copyWith(manuelDeviceConnectionStatus: OperationStatus.SUCCESS),
      );
    } on Exception {
      emit(
        state.copyWith(manuelDeviceConnectionStatus: OperationStatus.FAILURE),
      );
      rethrow;
    }
  }
}
