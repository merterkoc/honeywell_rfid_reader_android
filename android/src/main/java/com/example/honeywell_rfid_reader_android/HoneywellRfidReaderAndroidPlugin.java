package com.example.honeywell_rfid_reader_android;

import android.Manifest;
import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.IntentFilter;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import com.example.honeywell_rfid_reader_android.bluetooth.BluetoothDeviceInfo;
import com.example.honeywell_rfid_reader_android.constants.ChannelAddress;
import com.example.honeywell_rfid_reader_android.helper.observer.TagChangeBroadcastReceiver;
import com.example.honeywell_rfid_reader_android.helper.observer.TagInfo;
import com.example.honeywell_rfid_reader_android.messages.DartMessenger;
import com.example.honeywell_rfid_reader_android.messages.model.ConnectionStatus;
import com.honeywell.rfidservice.EventListener;
import com.honeywell.rfidservice.RfidManager;
import com.honeywell.rfidservice.TriggerMode;
import com.honeywell.rfidservice.rfid.OnTagReadListener;
import com.honeywell.rfidservice.rfid.RfidReader;
import com.honeywell.rfidservice.rfid.TagAdditionData;
import com.honeywell.rfidservice.rfid.TagReadData;
import com.honeywell.rfidservice.utils.ByteUtils;

import java.sql.DriverManager;
import java.util.ArrayList;
import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * HoneywellRfidReaderAndroidPlugin
 */
public class HoneywellRfidReaderAndroidPlugin implements FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {

    private boolean bluetoothAutoConnect = false;
    private MethodChannel channel;
    private DartMessenger dartMessenger;

    static EventChannel.EventSink barcodeStream;
    private EventChannel eventChannel;

    private final String[] mPermissions = new String[]{
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.WRITE_EXTERNAL_STORAGE,
    };

    private final boolean[] mPermissionGranted = new boolean[]{
            false, false
    };

    private final List<String> mRequestPermissions = new ArrayList<>();
    private static final int PERMISSION_REQUEST_CODE = 1;

    private RfidManager rfidManager;


    private final List<BluetoothDeviceInfo> bluetoothDeviceList = new ArrayList<>();

    private long mPrevListUpdateTime;

    private BluetoothAdapter bluetoothAdapter;

    private final List<TagInfo> mTagDataList = new ArrayList<>();

    private final TagChangeBroadcastReceiver tagChangeBroadcastReceiver = new TagChangeBroadcastReceiver();


    private int mTargetSwitchInterval = 3000;

    @SuppressLint("UnspecifiedRegisterReceiverFlag")
    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), ChannelAddress.MAIN_CHANNEL);
        dartMessenger = new DartMessenger(flutterPluginBinding.getApplicationContext(), channel, new Handler(Looper.getMainLooper()));

        eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), ChannelAddress.ON_TAG_READ);
        eventChannel.setStreamHandler(this);

        IntentFilter filter = new IntentFilter("action.TAG_CHANGE");
        filter.addAction("action.TAG_CHANGE");
        flutterPluginBinding.getApplicationContext().registerReceiver(tagChangeBroadcastReceiver, filter);
        ;
        channel.setMethodCallHandler(this);
        bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        RfidManager.create(flutterPluginBinding.getApplicationContext(), new RfidManager.CreatedCallback() {
            @Override
            public void onCreated(RfidManager rfid) {
                rfidManager = rfid;
                rfidManager.addEventListener(mEventListener);

            }
        });
    }

    private final BluetoothAdapter.LeScanCallback mLeScanCallback =
            new BluetoothAdapter.LeScanCallback() {
                @Override
                public void onLeScan(BluetoothDevice device, int rssi, byte[] scanRecord) {
                    if (device.getName() != null && !device.getName().isEmpty()) {
                        synchronized (bluetoothDeviceList) {
                            boolean newDevice = true;

                            for (BluetoothDeviceInfo info : bluetoothDeviceList) {
                                if (device.getAddress().equals(info.dev.getAddress())) {
                                    newDevice = false;
                                    info.rssi = rssi;
                                }
                            }

                            if (newDevice) {
                                bluetoothDeviceList.add(new BluetoothDeviceInfo(device, rssi));
                            }

                            long cur = System.currentTimeMillis();

                            if (newDevice || cur - mPrevListUpdateTime > 500) {
                                mPrevListUpdateTime = cur;
                            }
                        }
                    }
                    if (bluetoothAutoConnect && device.getName() != null && device.getName().equals("IH45")) {
                        bluetoothAdapter.stopLeScan(mLeScanCallback);
                        rfidManager.connect(device.getAddress());
                        if (rfidManager.getReader() == null) {
                            dartMessenger.sendReaderErrorEvent("Reader not connected");
                        }
                    }
                }
            };


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("scanBluetoothDevices")) {
            bluetoothAutoConnect = Boolean.TRUE.equals(call.arguments());
            final boolean permissionGranted = isBluetoothPermissionGranted();
            bluetoothAdapter.isEnabled();
            bluetoothAdapter.startLeScan(mLeScanCallback);
            result.success(true);
        } else if (call.method.equals("disconnectDevice")) {
            rfidManager.disconnect();
            //dartMessenger.sendRfidConnectionStatusEvent(ConnectionStatus.DISCONNECTED);
            result.success(true);
        } else if (call.method.equals("createReader")) {
            rfidManager.createReader();
            result.success(true);
        } else if (call.method.equals("disableScanBluetoothDevices")) {
            bluetoothAdapter.stopLeScan(mLeScanCallback);
            result.success(true);
        } else if (call.method.equals("readStart")) {
            startRead();
            result.success(true);
        } else if (call.method.equals("readStop")) {
            stopRead();
            result.success(true);
        } else {
            result.notImplemented();
        }
//        switch (call.method) {
//            case "initialize":
//                if (isInitialized) {
//                    rfidManager.addEventListener(mEventListener);
//                    result.success(true);
//                } else {
//                    result.error("Reader not initialized", "Reader not initialized", null);
//                }
//                break;
//            case "scanBluetoothDevices":
//                bluetoothAutoConnect = Boolean.TRUE.equals(call.arguments());
//                final boolean permissionGranted = isBluetoothPermissionGranted();
//                if (false) {
//                    result.error("Bluetooth permission not granted", "Permission not granted", null);
//                    return;
//                } else if (false) {
//                    result.error("Bluetooth not enabled", "Bluetooth not enabled", null);
//                } else {
//                    bluetoothAdapter.isEnabled();
//                    bluetoothAdapter.startLeScan(mLeScanCallback);
//                    result.success(true);
//                }
//                break;
//            case "disconnectDevice":
//                rfidManager.disconnect();
//                result.success(true);
//                break;
//            case "disconnectRfidReader":
//                rfidManager.setAutoReconnect(false);
//                rfidManager.disconnect();
//                if (rfidManager.isConnected()) {
//                    throw new RuntimeException("Reader not disconnected");
//                } else {
//                    dartMessenger.sendRfidConnectionStatusEvent(ConnectionStatus.DISCONNECTED);
//                }
//                result.success(true);
//                break;
//            case "getAvailableBluetoothDevices":
//                final List<Map<String, Object>> devices = new ArrayList<>();
//                for (BluetoothDeviceInfo info : bluetoothDeviceList) {
//                    devices.add(new HashMap<String, Object>() {{
//                        put("name", info.dev.getName());
//                        put("address", info.dev.getType());
//                        put("rssi", info.rssi);
//                    }});
//                }
//                result.success(devices);
//                break;
//            case "isBluetoothPermissionGranted":
//                result.success(isBluetoothPermissionGranted());
//                break;
//            case "createReader":
//                rfidManager.createReader();
//                rfidManager.getReader().setOnTagReadListener(dataListener);
//                result.success(true);
//                break;
//            case "disconnect":
//                if (rfidManager == null) {
//                    result.error("Reader not created", "Reader not created", null);
//                    return;
//                }
//                rfidManager.disconnect();
//                result.success(true);
//                break;
//            case "readRfid":
//                startStream();
//                read();
//                result.success(true);
//                break;

    }

    private boolean isReaderAvailable() {
        return rfidManager.getReader() != null && rfidManager.getReader().available();
    }

    private void startRead() {
        if (!isReaderAvailable()) {
            return;
        }
        synchronized (mTagDataList) {
            mTagDataList.clear();
        }
        rfidManager.getReader().setOnTagReadListener(dataListener);
        rfidManager.getReader().read(TagAdditionData.NONE);
    }

    private void stopRead() {
        if (!isReaderAvailable()) {
            return;
        }
        synchronized (mTagDataList) {
            mTagDataList.clear();
        }
        rfidManager.getReader().removeOnTagReadListener(dataListener);
        rfidManager.getReader().stopRead();
    }

    private boolean isBluetoothPermissionGranted() {

        for (int i = 0; i < mPermissions.length; ++i) {
            if (Manifest.permission.ACCESS_FINE_LOCATION.equals(mPermissions[i])) {
                return mPermissionGranted[i];
            }
        }
        return false;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }


    private final EventListener mEventListener = new EventListener() {

        @Override
        public void onReadRemoteRssi(BluetoothDevice bluetoothDevice, int i) {
            EventListener.super.onReadRemoteRssi(bluetoothDevice, i);
            Log.d("onReadRemoteRssi", "onReadRemoteRssi");
        }

        @Override
        public void onDeviceConnected(Object o) {
            DriverManager.println("onDeviceConnected");
            dartMessenger.sendRfidConnectionStatusEvent(ConnectionStatus.CONNECTED);
        }

        @Override
        public void onDeviceDisconnected(Object o) {
            DriverManager.println("onDeviceDisconnected");
            dartMessenger.sendRfidConnectionStatusEvent(ConnectionStatus.DISCONNECTED);
        }

        @Override
        public void onUsbDeviceAttached(Object o) {

        }

        @Override
        public void onUsbDeviceDetached(Object o) {

        }

        @Override
        public void onReaderCreated(boolean b, final RfidReader rfidReader) {
            DriverManager.println("onReaderCreated");
        }

        @Override
        public void onRfidTriggered(boolean b) {

            Log.d("onRfidTriggered", "onRfidTriggered");
            if (b) {
                startRead();
            } else {
                stopRead();
            }

        }

        @Override
        public void onTriggerModeSwitched(TriggerMode triggerMode) {
        }

        @Override
        public void onReceivedFindingTag(int i) {

        }
    };


    private final OnTagReadListener dataListener = new OnTagReadListener() {
        @Override
        public void onTagRead(final TagReadData[] t) {
            synchronized (mTagDataList) {
                for (TagReadData trd : t) {
                    String epc = trd.getEpcHexStr();
                    if (true) {
                        epc += ByteUtils.bytes2HexStr(trd.getAdditionData());
                    }
                    boolean doUpdate = true;
                    for (TagInfo tagInfo : mTagDataList) {
                        if (true) {
                            String key = tagInfo.tagReadData.getEpcHexStr()
                                    + ByteUtils.bytes2HexStr(tagInfo.tagReadData.getAdditionData());
                            if (key.equals(epc)) {
                                ++tagInfo.count;
                                doUpdate = false;
                                break;
                            }
                        } else {
                            if (tagInfo.tagReadData.getEpcHexStr().equals(trd.getEpcHexStr())) {
                                ++tagInfo.count;
                                doUpdate = false;
                                break;
                            }
                        }
                    }
                    if (doUpdate) {
                        TagInfo tagInfo = new TagInfo();
                        tagInfo.tagReadData = trd;
                        tagInfo.count = 1;
                        mTagDataList.add(tagInfo);
                        new Handler(Looper.getMainLooper()).post(new Runnable() {
                            @Override
                            public void run() {
                                if (barcodeStream != null) {
                                    barcodeStream.success(tagInfo.tagReadData.getEpcHexStr());
                                }
                            }
                        });
                    }
                }
            }
        }
    };

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        try {
            barcodeStream = events;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void onCancel(Object arguments) {
        try {
            barcodeStream = null;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
