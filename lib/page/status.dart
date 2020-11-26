import 'package:band_names/services/socket_service.dart';
import 'package:band_names/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    //socketService.socket.emit('');

    return Scaffold(
        appBar: AppBar(backgroundColor: Utils.getBackgroundColor(socketService.serverStatus)),
        body: Center(
          child: Text(
            "${socketService.serverStatus}",
            style: TextStyle(color: Colors.black),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.message),
          onPressed: () {
            socketService.emit('emitir-mensaje', 'hola desde flutter');
          },
        ));
  }
}
