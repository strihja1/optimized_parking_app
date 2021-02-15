import 'package:meta/meta.dart';
import 'package:optimized_parking_app/power.dart';

@immutable
abstract class PowerEvent {}

class UpdatePower extends PowerEvent {
  final Power power;

  UpdatePower({this.power});

  @override
  String toString() {
    return 'UpdatePower {power ${power.power}, ${power.numberOfOccupiedSlots}';
  }

  @override
  List<Object> get props => [power];
}