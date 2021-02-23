import 'package:flutter/material.dart';
import 'package:optimized_parking_app/pages/drawer.dart';
import 'package:optimized_parking_app/pages/equalityCharging.dart';
import 'package:optimized_parking_app/parkingSpot.dart';
import 'package:optimized_parking_app/power.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          ParkingSpot(id: i, power: power,)
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
          title: Text(widget.title),
        ),
        drawer: AppDrawer(),
        body: Text("vyber mod")
      /* BlocBuilder<PowerBloc, PowerState>(
        builder: (BuildContext context, PowerState powerState) {
          if(powerState is UpdatedPowerState) {
            power = powerState.power;

            return Container(
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
            );
          } else
            {
              return Text("hmmm");
            }
        }
      ), */
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