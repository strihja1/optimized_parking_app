import 'package:meta/meta.dart';

import 'parkingSpot.dart';

@immutable
abstract class ParkingSpotEvent {}

class UpdateParkingSpot extends ParkingSpotEvent {
  final ParkingSpot parkingSpot;

  UpdateParkingSpot({this.parkingSpot});

  @override
  String toString() {
    return 'UpdateParkingSpot';
  }

  @override
  List<Object> get props => [parkingSpot];
}