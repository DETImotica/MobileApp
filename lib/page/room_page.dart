import 'package:flutter/material.dart';
import 'package:deti_motica_app/src/import.dart';

Room info;

class RoomPage extends StatefulWidget {

  RoomPage(Room room) {
    info=room;
  }

  @override
  State<StatefulWidget> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {

  @override
  Widget build(BuildContext context) {
    _values() async {
      //await info.update();
      setState(() {});
    }
    _values();

    return Scaffold(
      appBar: AppBar(
        title: Text("Sala ${info.dept}.${info.floor}.${info.num}"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height*0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Número estimado de ocupantes"),
                  Text(
                    info.hasMetric("ocupacao")?info.getValue("ocupacao"):"N/A",
                    style: TextStyle(backgroundColor: Colors.blueGrey)
                  ),
                ],
              ),
            ),
            ExpansionTile(
              title: Text("Dados Sensoriais"),
              backgroundColor: Colors.blueGrey,
              children: _buildSensorData(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSensorData() {
    List<Widget> sensors=[];

    for (String metric in info.getMetrics()) {
      sensors.add(Text(
        metric+": ${info.getValue(metric)}",
        style: TextStyle(fontSize: 24),
      ));
    }

    return sensors;
  }

}