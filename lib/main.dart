import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optimized_parking_app/parkingSpot.dart';
import 'package:optimized_parking_app/power.dart';
import 'package:optimized_parking_app/powerBloc.dart';
import 'package:optimized_parking_app/powerEvent.dart';
import 'package:optimized_parking_app/powerState.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Optimized charging',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
          create: (BuildContext context) => PowerBloc()..add(UpdatePower(power: Power(numberOfOccupiedSlots: 0, power: 100,))),
          child: MyHomePage(title: 'Parking')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PowerBloc _powerBloc = PowerBloc();

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
      body: BlocBuilder<PowerBloc, PowerState>(
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
      ),
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
