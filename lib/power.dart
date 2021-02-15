import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:optimized_parking_app/powerBloc.dart';
import 'package:optimized_parking_app/powerState.dart';

class Power extends StatefulWidget {
  double power;
  int numberOfOccupiedSlots;

  Power({
    this.power, this.numberOfOccupiedSlots
  });

  @override
  State<StatefulWidget> createState() => _PowerState();
}
  class _PowerState extends State<Power>{

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PowerBloc, PowerState>(
      builder: (context, state) {

        if (state is UpdatedPowerState) {
          print("occupied ${state.power.numberOfOccupiedSlots}");
          print("power ${state.power.power}");
          print("vydeleno ${state.power.power / state.power.numberOfOccupiedSlots}");
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