import 'package:band_names/models/band.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;
  List<Band> _bands = new List();

  SocketService() {
    _initConfig();
  }

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  List<Band> get bands => this._bands;

  void _initConfig() {
    print("trying connect");
    _socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    // Dart client
    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.Online;
      print('connect');
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.Offline;
      print('not connected');
      notifyListeners();
    });
  }
}
