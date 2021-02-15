import 'package:meta/meta.dart';
import 'package:optimized_parking_app/power.dart';

@immutable
abstract class PowerState {}

class InitialPowerState extends PowerState {
  InitialPowerState();

}

class UpdatedPowerState extends PowerState{
  final Power power;

  UpdatedPowerState(this.power);

}