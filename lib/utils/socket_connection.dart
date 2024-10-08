import 'dart:io';

import 'package:e_track/utils/global.dart';

class SocketConnection {
  // Private constructor
  SocketConnection._privateConstructor();

  // The single instance of the class
  static final SocketConnection _instance =
      SocketConnection._privateConstructor();

  // Getter to access the instance
  static SocketConnection get instance => _instance;

  Socket? _socket;

  // Method to connect to the server
  Future<void> connect(String ip, int port) async {
    if (_socket == null) {
      try {
        _socket = await Socket.connect(ip, port);
        kPrintLog(
            'Connected to: ${_socket!.remoteAddress.address}:${_socket!.remotePort}');
        _socket!.listen(
          (List<int> event) {
            kPrintLog('Received: ${String.fromCharCodes(event)}');
          },
          onError: (error) {
            kPrintLog('Error: $error');
            _socket!.destroy();
            _socket = null;
          },
          onDone: () {
            kPrintLog('Server closed the connection');
            _socket!.destroy();
            _socket = null;
          },
        );
      } catch (e) {
        kPrintLog('Unable to connect: $e');
        _socket = null;
      }
    }
  }

  // Method to send data
  void sendData(String message, Function(String) callback) {
    try {
      if (_socket != null) {
        _socket!.write(message);
        kPrintLog('Sent: $message');
      } else {
        kPrintLog('Problem occurred, please check Socket');
        callback('Problem occurred, please check Socket');
      }
    } catch (e) {
      callback("Problem occurred, please check Socket.");
      kPrintLog(e);
    }
  }

  // Method to close the connection
  void close() {
    try {
      if (_socket != null) {
        _socket!.close();
        _socket = null;
        kPrintLog('Socket connection closed');
      }
    } catch (e) {
      kPrintLog(e);
    }
  }
}
