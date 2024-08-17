package com.example.honeywell_rfid_reader_android.messages;

import android.content.Context;
import android.os.Handler;

import androidx.annotation.NonNull;

import com.example.honeywell_rfid_reader_android.messages.model.ConnectionStatus;
import com.example.honeywell_rfid_reader_android.messages.model.EventType;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

public class DartMessenger {
    @NonNull
    private final MethodChannel readerChannel;
    @NonNull
    private final Handler handler;
    @NonNull
    private final Context context;

    /**
     * Creates a new instance of the {@link DartMessenger} class.
     */
    public DartMessenger(@NonNull Context context, @NonNull MethodChannel readerChannel, @NonNull Handler handler) {
        this.context = context;
        this.readerChannel = readerChannel;
        this.handler = handler;
    }

    public void sendRfidConnectionStatusEvent(ConnectionStatus connectionStatus) {
        this.send(EventType.RFID_CONNECTION_STATUS_CHANGED,
                new HashMap<String, Object>() {
                    {
                        put("status", connectionStatus.getValue());
                    }
                });
    }

    /**
     * Sends a message to the Flutter client informing that the new tag read.
     */
    public void sendRfidReadEvent(String data) {
        send(EventType.RFID_READ,
                new HashMap<String, Object>() {
                    {
                        put("data", data);
                    }
                }
        );
    }


    /**
     * Sends a message to the Flutter client informing that an error occurred while interacting with
     * the reader.
     *
     * @param code contains details regarding the error that occurred.
     */
    public void sendReaderErrorEvent(int code) {
        this.send(
                EventType.RFID_ERROR,
                new HashMap<String, Object>() {
                    {
                        put("message", context.getString(code));
                    }
                }
        );
    }

    private void send(EventType eventType) {
        send(eventType, new HashMap<>());
    }

    private void send(EventType eventType, Map<String, Object> args) {
        handler.post(() -> readerChannel.invokeMethod(eventType.name(), args));
    }
}
