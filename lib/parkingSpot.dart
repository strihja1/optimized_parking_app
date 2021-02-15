import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:optimized_parking_app/power.dart';
import 'package:optimized_parking_app/powerBloc.dart';
import 'package:optimized_parking_app/powerEvent.dart';
import 'package:optimized_parking_app/powerState.dart';

class ParkingSpot extends StatefulWidget {
  final int id;
  bool isFree;
  int priority;
  DateTime reservedUntil;
  int chargingSpeed;
  Timer timer;
  Power power;

  ParkingSpot({
    this.id, this.isFree = true, this.priority, this.reservedUntil, this.power
  });

  @override
  State<StatefulWidget> createState() => _ParkingSpotState();
}
  class _ParkingSpotState extends State<ParkingSpot>{
    Timer timer;

  @override
  Widget build(BuildContext context) {
    if(timer != null){
      timer.cancel();
    }
    timer = Timer.periodic(const Duration(seconds:10), (Timer t) => _monitorParkingSpot());
    Color color = widget.isFree ? Colors.green : Colors.red;
    return BlocBuilder<PowerBloc, PowerState>(
      builder: (context, state) {
        if(state is UpdatedPowerState){
          widget.power = state.power;
        return GestureDetector(
          child: Container(
            width: 30,
            height: 60,
            decoration: BoxDecoration(
                border: Border.all(width: 2),
              color: color
            ),
            child: Column(
              children: [
                Text("${widget.id}"),
                widget.isFree ? Container() : state.power
              ],
            ),
          ),
          onTap: ()  {
             _callDatePicker(context);
          },
        );
      }else{
          return Container();
        }
      }
    );
  }

  _callDatePicker(BuildContext context) async{
    DateTime selectedDate = await DatePicker.showDateTimePicker(context, minTime: DateTime.now(), onConfirm: (date) {
      _updateParkingSpot(date);
    }, currentTime: DateTime.now());
  }

  _updateParkingSpot(DateTime selectedDate ){
    if(selectedDate.isAfter(DateTime.now())){
      setState(() {
        widget.isFree = false;
        widget.reservedUntil = selectedDate;
        BlocProvider.of<PowerBloc>(context).add(UpdatePower(power: Power(numberOfOccupiedSlots: widget.power.numberOfOccupiedSlots+1, power: widget.power.power,)));
      });
    }
  }

  _monitorParkingSpot(){
    if(!widget.isFree && widget.reservedUntil.isBefore(DateTime.now())){
      setState(() {
        widget.isFree = true;
        BlocProvider.of<PowerBloc>(context).add(UpdatePower(power: Power(numberOfOccupiedSlots: widget.power.numberOfOccupiedSlots-1, power: widget.power.power,)));
      });
    }
  }



}