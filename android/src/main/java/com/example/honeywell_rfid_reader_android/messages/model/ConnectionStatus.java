package com.example.honeywell_rfid_reader_android.messages.model;

public enum ConnectionStatus {
    DISCONNECTED(0),
    CONNECTED(1);
    private final int value;

    ConnectionStatus(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }
}