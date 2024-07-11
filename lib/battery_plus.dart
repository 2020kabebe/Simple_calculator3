import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';

void monitorBattery(BuildContext context) {
  Battery().onBatteryStateChanged.listen((BatteryState state) {
    if (state == BatteryState.charging) {
      Battery().batteryLevel.then((level) {
        if (level >= 90) {
          // Show a toast or notification
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Battery at 90% or above')),
          );
        }
      });
    }
  });
}
