import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';

class Utils {
  static getBackgroundColor(serverStatus) {
    switch (serverStatus) {
      case ServerStatus.Online:
        return Colors.greenAccent;
        break;
      case ServerStatus.Offline:
        return Colors.redAccent;
        break;
      case ServerStatus.Connecting:
        return Colors.orangeAccent;
        break;
      default:
        return Colors.grey;
    }
  }
}
