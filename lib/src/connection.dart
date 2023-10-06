import 'dart:io';

import 'package:atmotuber/src/device_info.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:location/location.dart';

class AtmotubeConnection {
  BluetoothAdapterState? adapterState;
  BluetoothDevice? device;

  Future<void> warm() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // check adapter availability
// Note: The platform is initialized on the first call to any FlutterBluePlus method.
    if (await FlutterBluePlus.isAvailable == false) {
      print("Bluetooth not supported by this device");
      return;
    }

// handle bluetooth on & off
// note: for iOS the initial state is typically BluetoothAdapterState.unknown
// note: if you have permissions issues you will get stuck at BluetoothAdapterState.unauthorized

    FlutterBluePlus.scanResults.listen(
      (results) async {
        for (ScanResult r in results) {
          if (r.device.platformName == DeviceInfo.deviceName) {
            print(
                '${r.device.remoteId}: "${r.advertisementData.localName}" found! rssi: ${r.rssi}');
            device = r.device;
            await FlutterBluePlus.stopScan();
          }
        }
      },
      onError: (e) => print(e),
    );

    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) async {
      adapterState = state;
    });

// turn on bluetooth ourself if we can
// for iOS, the user controls bluetooth enable/disable
    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }
  }

  Future<void> connect() async {
    if (FlutterBluePlus.isScanningNow) {
      if (device != null) {
        await device!.connect();
        print(device!.connectionState);
      } else {
        print('no device found');
        return;
      }
    } else {
      print('scanning underway');
      return;
    }
  }
}
