import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:food_app/pages/nointernet.dart';

class Checkinternet extends StatefulWidget {
  final Widget child;
  const Checkinternet({super.key, required this.child});

  @override
  State<Checkinternet> createState() => _CheckinternetState();
}

class _CheckinternetState extends State<Checkinternet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream:  Connectivity().onConnectivityChanged,
        builder: (context , snapshotinternet) {
          final connectivityResult = snapshotinternet.data;
          if(connectivityResult!.contains(ConnectivityResult.none)){
            return const Nointernet();
          }
          // IF ther internet this will work 
          return widget.child;
  }));
  }
}