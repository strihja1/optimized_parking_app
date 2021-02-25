import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:optimized_parking_app/car.dart';
import 'package:optimized_parking_app/power.dart';
import 'package:optimized_parking_app/powerBloc.dart';
import 'package:optimized_parking_app/powerEvent.dart';
import 'package:optimized_parking_app/powerState.dart';

class ParkingSpot extends StatefulWidget {
  final int id;
  bool isFree;
  int priority;
  DateTime reservedUntil;
  double chargingSpeed;
  Timer timer;
  Power power;
  Car car;
  final int mode;

  ParkingSpot({
    this.id, this.isFree = true, this.priority, this.reservedUntil, this.power, this.mode
  });

  @override
  State<StatefulWidget> createState() => _ParkingSpotState();
}
  class _ParkingSpotState extends State<ParkingSpot>{
    Timer timer;
    String valueText;
    String codeDialog;
    double dividedPower;
    TextEditingController _textFieldController = TextEditingController();

    @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

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
          if(widget.mode == 1){
            return timeBasedCharging(color, context);
          }else{
            return equalityCharging(color, context);
          }
      }else{
          return Container();
        }
      }
    );
  }

  GestureDetector equalityCharging(Color color, BuildContext context) {
    if(widget.power.numberOfOccupiedSlots > 0) {
      widget.chargingSpeed =
          widget.power.power / widget.power.numberOfOccupiedSlots;
    }else{
      widget.chargingSpeed = widget.power.power;
    }
            return GestureDetector(
    child: Container(
      width: 80,
      height: 90,
      decoration: BoxDecoration(
          border: Border.all(width: 2),
        color: color
      ),
      child: Column(
        children: [
          Text("${widget.id}"),
          widget.isFree ? Container() : Text("${(widget.power.power / widget.power.numberOfOccupiedSlots).toStringAsFixed(2)} kWh"),
          widget.isFree ? Container() : Text("${widget.car.actualCharge.toStringAsFixed(2)} %")
        ],
      ),
    ),
    onTap: ()  {
       _callDatePicker(context);
    },
            );
  }

    GestureDetector timeBasedCharging(Color color, BuildContext context) {
      if(widget.power.numberOfOccupiedSlots > 0) {
        widget.chargingSpeed =
            widget.power.power / widget.power.numberOfOccupiedSlots;
      }else{
        widget.chargingSpeed = widget.power.power;
      }
      return GestureDetector(
        child: Container(
          width: 80,
          height: 90,
          decoration: BoxDecoration(
              border: Border.all(width: 2),
              color: color
          ),
          child: Column(
            children: [
              Text("${widget.id}"),
              widget.isFree ? Container() : Text("${(widget.power.power / widget.power.numberOfOccupiedSlots).toStringAsFixed(2)} kWh"),
              widget.isFree ? Container() : Text("${widget.car.actualCharge.toStringAsFixed(2)} %"),
              widget.isFree || widget.reservedUntil == null ? Container() : Text("Do: ${widget.reservedUntil.hour}:${widget.reservedUntil.minute}"),
              widget.isFree ? Container() : Text(" ${widget.priority}")
            ],
          ),
        ),
        onTap: ()  {
          _callDatePicker(context);
        },
      );
    }

  _callDatePicker(BuildContext context) async{
    DateTime selectedDate = await DatePicker.showDateTimePicker(context, minTime: DateTime.now(), onConfirm: (date) async {
       await _displayTextInputDialog(context, date);

    }, currentTime: DateTime.now(),);
  }

  _updateParkingSpot(DateTime selectedDate ){
    if(selectedDate.isAfter(DateTime.now())){
      setState(() {
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
    }else if(!widget.isFree && widget.car.actualCharge < 100){
      setState(() {
        widget.car.actualCharge = widget.car.actualCharge + (widget.chargingSpeed/60/6);
      });
    }
  }

    Future<void> _displayTextInputDialog(BuildContext context, DateTime date) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Procent baterie'),
              content: TextField(
                onChanged: (value) {
                  setState(() {
                    valueText = value;
                  });
                },
                controller: _textFieldController,
                decoration: InputDecoration(hintText: "zadej procenta baterie"),
              ),
              actions: <Widget>[
                FlatButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text('CANCEL'),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
                FlatButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  child: Text('OK'),
                  onPressed: () {
                    setState(() {
                      codeDialog = valueText;
                      widget.car = Car(batteryCapacity: 100, actualCharge: double.tryParse(valueText),);
                      widget.isFree = false;
                      _updateParkingSpot(date);
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            );
          });
    }




  }