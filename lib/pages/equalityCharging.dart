import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optimized_parking_app/pages/drawer.dart';
import 'package:optimized_parking_app/parkingSpot.dart';
import 'package:optimized_parking_app/power.dart';
import 'package:optimized_parking_app/powerBloc.dart';
import 'package:optimized_parking_app/powerEvent.dart';
import 'package:optimized_parking_app/powerState.dart';

class EqualityCharging extends StatefulWidget {
  EqualityCharging({Key key}) : super(key: key);

  @override
  _EqualityChargingState createState() => _EqualityChargingState();
}

class _EqualityChargingState extends State<EqualityCharging> {
  Power power;
  TextEditingController _controller;
  List<ParkingSpot> occupiedParkingSlots = [];
  List<ParkingSpot> parkingSpots = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    for(int i = 0; i < 50; i++){
      parkingSpots.add(
          ParkingSpot(id: i)
      );
    }
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rovnoměrné nabíjení"),
      ),
      body: BlocBuilder<PowerBloc, PowerState>(
          builder: (BuildContext context, PowerState powerState) {
            if(powerState is UpdatedPowerState) {
              power = powerState.power;
              return SingleChildScrollView(
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Center(
                      child: Column(
                        children: [
                          Wrap(children: parkingSpots, runSpacing: 20, spacing: 5,),
                          Text("Počet obsazených míst:${power.numberOfOccupiedSlots}"),
                          Text("Celkový výkon:${power.power} kWh")
                        ],
                      )
                  ),
                ),
              );
            } else
            {
              return Text("hmmm");
            }
          }
      ),
      drawer: AppDrawer(),
    );
  }

/*

  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(width: 2)
                ),
                child: Text("$id"),
              ),
              onTap: () {
                _callDatePicker(context, id);
              },
            ),
          ],
        ),

   */
}
