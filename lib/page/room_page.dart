import 'package:flutter/material.dart';
import 'package:deti_motica_app/src/import.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'dart:async';

class RoomPage extends StatefulWidget {
  final Room room;

  RoomPage(this.room);

  @override
  State<StatefulWidget> createState() => _RoomPageState(room);
}

class _RoomPageState extends State<RoomPage> {
  Room room;
  Future<Room> info;
  Timer timer;

  _RoomPageState(this.room) {
    super.initState();
    info=room.update();
    timer=Timer.periodic(Duration(seconds: 2),(Timer t)=>setState((){}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sala ${room.dept}.${room.floor}.${room.num}"),
        centerTitle: true,
      ),
      body: FutureBuilder<Room>(
        future: info,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                    children: _buildSensorData()
                ),
              );
            }
          }
          else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        }
      )
    );
  }

  List<Widget> _buildSensorData() {
    List<Widget> sensors=[];
    for (String metric in room.getMetrics()) {
      sensors.add(Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        height: 220,
        width: double.maxFinite,
        child: Card(
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    width: 2.0, color: room.getColor(metric)),
              ),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(7),
              child: Stack(children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(left: 10, top: 5),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[_metricIcon(metric),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  _metricNameSymbol(metric),
                                  Spacer(),
                                  _sensorChange(metric),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  _changeIcon(metric),
                                  SizedBox(
                                    width: 20,
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  _sensorValueData(metric),
                                  SizedBox(
                                    width: 100,
                                  ),
                                  _changeGraph(metric)
                                ],
                              )
                            ],
                          ))
                    ],
                  ),
                )
              ]),
            ),
          ),
        ),
      ));
    }

    return sensors;
  }

  Widget _metricIcon(metric) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Image.asset(room.getIconPath(metric))),
    );
  }
  Widget _metricNameSymbol(metric) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: '$metric',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
          children: <TextSpan>[
            /*TextSpan(
                text: '\n${metric.unit}',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),*/
          ],
        ),
      ),
    );
  }
  Widget _sensorChange(metric) {
    double gain= room.getGain(metric).toDouble();
    double gainPercentage= room.getGainPercentage(metric).toDouble() * 100;
    String gainStr = (gain < 0) ?gain.toStringAsFixed(2) : "+"+gain.toStringAsFixed(2);
    String gainPercentageStr = (gainPercentage < 0) ?gainPercentage.toStringAsFixed(2) : "+"+gainPercentage.toStringAsFixed(2);
    return Align(
      alignment: Alignment.topRight,
      child: RichText(
        text: TextSpan(
          text: '$gainPercentageStr%',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: (gainPercentageStr.contains('-') ? Colors.red : Colors.green), fontSize: 20),
          children: <TextSpan>[
            TextSpan(
                text: '\n$gainStr',
                style: TextStyle(
                  color: (gainStr.contains('-') ? Colors.red : Colors.green),
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
  Widget _changeIcon(metric) {
    double gainPercentage= room.getGainPercentage(metric).toDouble() * 100;
    String gainPercentageStr = (gainPercentage < 0) ?gainPercentage.toStringAsFixed(2) : "+"+gainPercentage.toStringAsFixed(2);
    return Align(
        alignment: Alignment.topRight,
        child: gainPercentageStr.contains('-')
        ? Icon(
      Typicons.arrow_sorted_down,
      color: Colors.red,
      size: 30,
    )
        : Icon(
      Typicons.arrow_sorted_up,
      color: Colors.green,
      size: 30,
    ));
  }
  Widget _sensorValueData(metric) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Row(
          children: <Widget>[
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: '\n${room.getValue(metric)}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 35,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: '\n${room.getTime(metric)}',
                      style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: '\n${room.getDate(metric)}',
                      style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _changeGraph (metric){
    return Align(
      alignment: Alignment.bottomRight,
      child: new Container(
        width: 120.0,
        height: 80.0,
        child: new Sparkline(
          data: room.getPastValues(metric).map((s) => s as double).toList(),
          lineWidth: 5.0,
          lineGradient: new LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [room.getColor(metric), Colors.grey],
          ),
        ),
      ),
    );
  }
}