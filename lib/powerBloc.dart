import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:optimized_parking_app/powerEvent.dart';
import 'package:optimized_parking_app/powerState.dart';

class PowerBloc extends Bloc<PowerEvent, PowerState> {
  PowerBloc() : super(InitialPowerState());

  @override
  Stream<PowerState> mapEventToState(PowerEvent event) async* {
    if (event is UpdatePower) {
      try {
        yield UpdatedPowerState(
            event.power);
      } catch (_) {}
    }
  }
}