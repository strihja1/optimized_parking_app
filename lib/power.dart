import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:optimized_parking_app/parkingSpot.dart';
import 'package:optimized_parking_app/powerBloc.dart';
import 'package:optimized_parking_app/powerState.dart';

class Power {
  double power;
  int numberOfOccupiedSlots;
  int mode;

  Power({
    this.power, this.numberOfOccupiedSlots, this.mode
  });
}