import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optimized_parking_app/pages/equalityCharging.dart';
import 'package:optimized_parking_app/pages/home.dart';
import 'package:optimized_parking_app/pages/timeBasedCharging.dart';
import 'package:optimized_parking_app/power.dart';
import 'package:optimized_parking_app/powerBloc.dart';
import 'package:optimized_parking_app/powerEvent.dart';

void main() {
  runApp(
    MultiBlocProvider(providers: [
        BlocProvider(create: (BuildContext context) => PowerBloc()..add(UpdatePower(power: Power(numberOfOccupiedSlots: 0, power: 100,))),
      )
    ], child: MaterialApp(
      title: 'Optimized charging',
      initialRoute: "/",
      routes: {
        '/': (context) => Home(title: "Parking"),
        '/equalityCharging': (context) => EqualityCharging(),
        '/timeBasedCharging': (context) => TimeBasedCharging(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    ))
      );
  }

