import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:optimized_parking_app/car.dart';
import 'package:optimized_parking_app/power.dart';
import 'package:optimized_parking_app/powerBloc.dart';
import 'package:optimized_parking_app/powerEvent.dart';
import 'package:optimized_parking_app/powerState.dart';
import 'package:intl/intl.dart';

class ParkingSpot extends StatefulWidget {
  final int id;
  bool isFree;
  int priority = 99;
  DateTime reservedUntil;
  double chargingSpeed;
  Timer timer;
  Power power;
  Car car;
  final int mode;
  double requiredPowerToFullyCharge;

  ParkingSpot({
    this.id, this.isFree = true, this.priority, this.reservedUntil, this.power, this.mode, this.requiredPowerToFullyCharge = 0
  });

  @override
  State<StatefulWidget> createState() => _ParkingSpotState();
}
  class _ParkingSpotState extends State<ParkingSpot>{
    Timer timer;
    String valueText;
    String codeDialog;
    double dividedPower;
    DateTime selectedDate;
    TextEditingController _textFieldController = TextEditingController();
    double remainingBatteryToCharge;

    @override
  void dispose() {
      timer.cancel();
      super.dispose();
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
          if(!widget.isFree) {
            remainingBatteryToCharge = widget.car.batteryCapacity -
                widget.car.actualCharge;
            widget.car.timeUntilCharged = calculateTimeUntilCharged(chargingSpeed: widget.chargingSpeed);
          }
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

   DateTime calculateTimeUntilCharged({double chargingSpeed}) {
    double secondsUntilCharged = remainingBatteryToCharge /
        chargingSpeed * 3600;
    return DateTime.now().toLocal().add(Duration(seconds: secondsUntilCharged.toInt()));
  }

    double calculateRequiredSpeedFromTime({double seconds}) {
      return remainingBatteryToCharge /
          seconds * 3600;

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
        width: 90,
        height: 200,
        decoration: BoxDecoration(
            border: Border.all(width: 2),
          color: color
        ),
      child: Column(
        children: [
          Text("${widget.id}"),
          widget.isFree ? Container() : Text("${(widget.power.power / widget.power.numberOfOccupiedSlots).toStringAsFixed(2)} kWh"),
          widget.isFree ? Container() : Text("${widget.car.actualCharge.toStringAsFixed(2)} %"),
          widget.isFree || widget.reservedUntil == null ? Container() : Text("Do: ${dateTimeFormatToString(widget.reservedUntil)}"),
          widget.isFree ? Container() : Text("Očekávané nabití v : ${dateTimeFormatToString(widget.car.timeUntilCharged.toLocal())}"),
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

      calculateRequiredPower();

      // widget.minutesUntilCharged = widget.chargingSpeed
      return GestureDetector(
        child: Container(
          width: 150,
          height: 200,
          decoration: BoxDecoration(
              border: Border.all(width: 2),
              color: color
          ),
          child: Column(
            children: [
              Text("${widget.id}"),
              widget.isFree ? Container() : Text("${(widget.power.power / widget.power.numberOfOccupiedSlots).toStringAsFixed(2)} kWh"),
              widget.isFree ? Container() : Text("${widget.car.actualCharge.toStringAsFixed(2)} %"),
              widget.isFree || widget.reservedUntil == null ? Container() : Text("Do: ${dateTimeFormatToString(widget.reservedUntil)}"),
              widget.isFree ? Container() : Text("Priorita: ${widget.priority}"),
              widget.isFree ? Container() : Text("Očekávané nabití v : ${dateTimeFormatToString(widget.car.timeUntilCharged.toLocal())}"),
              widget.isFree ? Container() : Text("Požadovaný výkon do odjetí : ${widget.requiredPowerToFullyCharge.toStringAsFixed(2)} kWh")
            ],
          ),
        ),
        onTap: ()  {
          _callDatePicker(context);
        },
      );
    }

    void calculateRequiredPower() async {
      if(!widget.isFree && widget.reservedUntil.isAfter(widget.car.timeUntilCharged)){ // stihne se nabít
        for(double i = widget.chargingSpeed; i > 0 ; i--){
          DateTime timeUntilCharged = calculateTimeUntilCharged(chargingSpeed: i);
          if(widget.reservedUntil.isAfter(timeUntilCharged)) {
            widget.requiredPowerToFullyCharge = i;
          }
        }
      }else if(!widget.isFree && widget.reservedUntil.isBefore(widget.car.timeUntilCharged)){ // nestihne se nabít
        double i = widget.chargingSpeed;
        DateTime timeUntilChargedWithCalculationPower = calculateTimeUntilCharged(chargingSpeed: i);

        while(widget.reservedUntil.isBefore(timeUntilChargedWithCalculationPower)){
        //for(double i = widget.chargingSpeed; i < widget.power.power ; i++){
          print(timeUntilChargedWithCalculationPower);
          timeUntilChargedWithCalculationPower = calculateTimeUntilCharged(chargingSpeed: i);
          i = i+10;
        }
        widget.requiredPowerToFullyCharge = i;
      }
    }

    String dateTimeFormatToString(DateTime dateTime) =>
        DateFormat("HH:mm dd.MM.yyyy ").format(dateTime.toLocal());

  _callDatePicker(BuildContext context) async{
    await DatePicker.showDateTimePicker(context, minTime: DateTime.now(), onConfirm: (date) async {
       await _displayTextInputDialog(context, date);

    }, currentTime: DateTime.now(),);
  }

  _updateParkingSpot(DateTime selectedDate ){
    print("selected $selectedDate");
    print(DateTime.now().toLocal());
    if(selectedDate.isAfter(DateTime.now().toLocal())){
      setState(() {
        widget.reservedUntil = selectedDate;
        BlocProvider.of<PowerBloc>(context).add(UpdatePower(power: Power(numberOfOccupiedSlots: widget.power.numberOfOccupiedSlots+1, power: widget.power.power,)));
      });
    }
  }

  _monitorParkingSpot(){
    if(!widget.isFree && widget.reservedUntil != null && widget.reservedUntil.isBefore(DateTime.now().toLocal())){
      setState(() {
        widget.isFree = true;
        BlocProvider.of<PowerBloc>(context).add(UpdatePower(power: Power(numberOfOccupiedSlots: widget.power.numberOfOccupiedSlots-1, power: widget.power.power,)));
      });
    }else if(!widget.isFree && widget.car.actualCharge < 100){
      setState(() {
        widget.car.actualCharge = widget.car.actualCharge + (widget.chargingSpeed/60/6);
      });
    }else if(!widget.isFree && widget.car.actualCharge > 100){
      setState(() {
        widget.isFree = true;
        BlocProvider.of<PowerBloc>(context).add(UpdatePower(power: Power(numberOfOccupiedSlots: widget.power.numberOfOccupiedSlots-1, power: widget.power.power,)));
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