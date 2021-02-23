import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:optimized_parking_app/parkingSpot.dart';
import 'package:optimized_parking_app/powerBloc.dart';
import 'package:optimized_parking_app/powerState.dart';

class Car extends StatefulWidget {
  double batteryCapacity;
  DateTime timeUntilCharged;
  double actualCharge;

  Car({
    this.batteryCapacity, this.timeUntilCharged, this.actualCharge
  });

  @override
  State<StatefulWidget> createState() => _CarState();
}
class _CarState extends State<Car>{

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PowerBloc, PowerState>(
        builder: (context, state) {

          if (state is UpdatedPowerState) {
            return Text(
                state.power.numberOfOccupiedSlots == 0 ? "${state.power.power}" : "${ (state.power.power / state.power.numberOfOccupiedSlots).toStringAsFixed(1)}"
            );
          }
          else {
            return Text("chyba");
          }
        }
    );
  }
}