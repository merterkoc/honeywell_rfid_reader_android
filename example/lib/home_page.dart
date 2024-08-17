import 'package:flutter/material.dart';
import 'package:honeywell_rfid_reader_android/model/connection_status.dart';
import 'package:honeywell_rfid_reader_android/rfid_manager/rfid_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ConnectionStatus? _connectionStatus;
  late final RFIDManager rfidManager;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> initializeRFIDReader() async {
    rfidManager = RFIDManager();
    rfidManager.initialize();
    rfidManager.connectionStatusChangedStream.listen((status) {
      setState(() {
        _connectionStatus = status;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Icon(
                _connectionStatus == ConnectionStatus.CONNECTED
                    ? Icons.bluetooth_connected
                    : Icons.bluetooth_disabled,
                color: _connectionStatus == ConnectionStatus.CONNECTED
                    ? Colors.green
                    : Colors.red,
                size: 50,
              ),
              ElevatedButton(
                onPressed: () async {
                  await initializeRFIDReader();
                  setState(() {});
                },
                child: const Text('Initialize RFID Reader'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await rfidManager.scanBluetoothDevices(
                    bluetoothAutoConnect: true,
                  );
                },
                child: const Text('Scan Bluetooth Devices'),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await rfidManager.disableScanBluetoothDevices();
                },
                icon: const Icon(Icons.bluetooth_disabled),
                label: const Text('Disable Scan Bluetooth Devices'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await rfidManager.disconnectDevice();
                },
                child: const Text('Disconnect Device'),
              ),
              Opacity(
                opacity:
                    _connectionStatus == ConnectionStatus.CONNECTED ? 1 : 0.5,
                child: Builder(builder: (context) {
                  return ElevatedButton.icon(
                    icon: isLoading
                        ? const CircularProgressIndicator()
                        : const Icon(Icons.barcode_reader),
                    label: const Text('Create Reader'),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      if (_connectionStatus != ConnectionStatus.CONNECTED)
                        return;
                      await rfidManager.createReader();
                      print('create reader');
                      setState(() {
                        isLoading = false;
                      });
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
