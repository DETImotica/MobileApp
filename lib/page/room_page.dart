import 'package:deti_motica_app/src/metric_icon.dart';
import 'package:flutter/material.dart';
import 'package:deti_motica_app/src/import.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

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
      await info.update();
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
          children: _buildSensorData()
          /*<Widget>[
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
          ],*/
        ),
      ),
    );
  }

  List<Widget> _buildSensorData() {
    List<Widget> sensors=[];
    for (String metric in info.getMetrics()) {
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
                    width: 2.0, color: info.getColor(metric)),
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
                                  _sensorChange(),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  _changeIcon(),
                                  SizedBox(
                                    width: 20,
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  _sensorValueData(metric)
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
          child: Image.asset(info.getIconPath(metric))),
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
            TextSpan(
                text: '\n${metric.substring(0, 4)}',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
  Widget _sensorChange() {
    return Align(
      alignment: Alignment.topRight,
      child: RichText(
        text: TextSpan(
          text: '+0.4%',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.green, fontSize: 20),
          children: <TextSpan>[
            TextSpan(
                text: '\n+0.8',
                style: TextStyle(
                  color: ('+0.4%'.contains('-') ? Colors.red : Colors.green),
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
  Widget _changeIcon() {
    return Align(
        alignment: Alignment.topRight,
        child: '+0.4%'.contains('-')
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
                text: '\n${info.getValue(metric)}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 35,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: '\n${info.getTime(metric)}',
                      style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}