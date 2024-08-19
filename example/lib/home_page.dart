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
  bool isReaderCreated = false;
  List<String> tags = [];

  @override
  void initState() {
    super.initState();
    initializeRFIDReader();
  }

  Future<void> initializeRFIDReader() async {
    rfidManager = RFIDManager();
    rfidManager.initialize();
    rfidManager.connectionStatusChangedStream.listen((status) {
      setState(() {
        _connectionStatus = status;
      });
    });
    rfidManager.tagReadStream.listen((tagRead) {
      setState(() {
        tags.add(tagRead);
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
                      if (_connectionStatus != ConnectionStatus.CONNECTED) {
                        return;
                      }
                      await rfidManager.createReader();
                      debugPrint('created reader');
                      setState(() {
                        isReaderCreated = true;
                        isLoading = false;
                      });
                    },
                  );
                }),
              ),
              Opacity(
                opacity: isReaderCreated ? 1 : 0.5,
                child: Builder(builder: (context) {
                  return ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Read'),
                    onPressed: () async {
                      if (_connectionStatus != ConnectionStatus.CONNECTED ||
                          !isReaderCreated) return;
                      setState(() {
                        isReaderCreated = true;
                      });
                      await rfidManager.readStart();
                      debugPrint('read started');
                    },
                  );
                }),
              ),
              Opacity(
                opacity: isReaderCreated ? 1 : 0.5,
                child: Builder(builder: (context) {
                  return ElevatedButton.icon(
                    icon: const Icon(Icons.stop),
                    label: const Text('Stop Read'),
                    onPressed: () async {
                      if (_connectionStatus != ConnectionStatus.CONNECTED ||
                          !isReaderCreated) return;
                      setState(() {
                        isReaderCreated = true;
                      });
                      await rfidManager.readStop();
                      debugPrint('read stopped');
                    },
                  );
                }),
              ),
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: tags.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    subtitle: Text(index.toString()),
                    title: Text(tags[index]),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
