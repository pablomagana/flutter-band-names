import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket_service.dart';
import 'package:band_names/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];
  SocketService socketService;

  @override
  void initState() {
    socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-bands', _handlerActiveBands);

    super.initState();
  }

  @override
  void dispose() {
    socketService.socket.off('active-bands');
    super.dispose();
  }

  _handlerActiveBands(dynamic payload) {
    this.bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BandNames',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.check_circle_outline,
              color: Utils.getBackgroundColor(socketService.serverStatus),
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) => _bandTile(bands[i]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => socketService.emit('delete-band', {'id': band.id}),
      background: Container(
        padding: EdgeInsets.only(left: 10),
        color: Colors.red,
        child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.delete_forever_rounded,
              color: Colors.white,
            )),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: TextStyle(fontSize: 20),
        ),
        onTap: () {
          socketService.emit('vote-band', {'id': band.id});
        },
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('new band name:'),
                content: TextFormField(
                  controller: textController,
                ),
                actions: [
                  MaterialButton(
                    child: Text('add'),
                    elevation: 5,
                    textColor: Colors.blue,
                    onPressed: () => addBandTiList(textController.text),
                  )
                ],
              ));
    } else {
      showCupertinoDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
                title: Text("new band name"),
                content: CupertinoTextField(
                  controller: textController,
                ),
                actions: [
                  CupertinoDialogAction(
                      isDefaultAction: true,
                      child: Text('Add'),
                      onPressed: () => addBandTiList(textController.text)),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    child: Text('Dismiss'),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ));
    }
  }

  void addBandTiList(String name) {
    if (name.length > 1) {
      this.socketService.socket.emit('add-band', {'name': name});
    }

    Navigator.pop(context);
  }
}
