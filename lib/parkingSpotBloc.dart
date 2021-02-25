import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:optimized_parking_app/parkingSpotEvent.dart';
import 'package:optimized_parking_app/parkingSpotState.dart';

class ParkingSpotBloc extends Bloc<ParkingSpotEvent, ParkingSpotState> {
  ParkingSpotBloc() : super(InitialParkingSpotState());

  @override
  Stream<ParkingSpotState> mapEventToState(ParkingSpotEvent event) async* {
    if (event is UpdateParkingSpot) {
      try {
        yield UpdatedParkingSpotState(
            event.parkingSpot);
      } catch (_) {}
    }
  }
}