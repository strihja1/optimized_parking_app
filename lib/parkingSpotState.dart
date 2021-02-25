import 'package:meta/meta.dart';

import 'parkingSpot.dart';

@immutable
abstract class ParkingSpotState {}

class InitialParkingSpotState extends ParkingSpotState {
  InitialParkingSpotState();

}

class UpdatedParkingSpotState extends ParkingSpotState{
  final ParkingSpot parkingSpot;

  UpdatedParkingSpotState(this.parkingSpot);

}