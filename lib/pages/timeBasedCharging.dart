import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optimized_parking_app/pages/drawer.dart';
import 'package:optimized_parking_app/parkingSpot.dart';
import 'package:optimized_parking_app/power.dart';
import 'package:optimized_parking_app/powerBloc.dart';
import 'package:optimized_parking_app/powerState.dart';
import 'package:optimized_parking_app/powerEvent.dart';


class TimeBasedCharging extends StatefulWidget {
  TimeBasedCharging({Key key}) : super(key: key);


  @override
  _TimeBasedChargingState createState() => _TimeBasedChargingState();
}

class _TimeBasedChargingState extends State<TimeBasedCharging> {
  Power power;
  Timer timer;
  TextEditingController _controller;
  List<ParkingSpot> occupiedParkingSlots = [];
  List<ParkingSpot> parkingSpots = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    BlocProvider.of<PowerBloc>(context).add(UpdatePower(power: Power(numberOfOccupiedSlots: 0, power: 100)));
    for(int i = 0; i < 50; i++){
      parkingSpots.add(
          ParkingSpot(id: i, mode: 1,)
      );
    }
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(timer != null){
      timer.cancel();
    }
    timer = Timer.periodic(const Duration(seconds:10), (Timer t) => _refreshOccupiedSlots());
    occupiedParkingSlots = parkingSpots.where((element) => !element.isFree).toList();
    print(occupiedParkingSlots.length);
    occupiedParkingSlots.sort((a,b) => a.reservedUntil.compareTo(b.reservedUntil));
    for(int i = 0; i < occupiedParkingSlots.length; i++ ){
      occupiedParkingSlots.elementAt(i).priority = i;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Časově založené nabíjení"),
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

  _refreshOccupiedSlots(){
    setState(() {

    });
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
