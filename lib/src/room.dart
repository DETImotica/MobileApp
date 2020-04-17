import "package:deti_motica_app/src/metric.dart";
import 'package:flutter/material.dart';

class Room {

  Map<String, Metric> _metrics;
  int dept;
  int floor;
  int num;


  Room(Map<String,String> sensorIDs, this.dept, this.floor, this.num) {
    _metrics=new Map();
    for (String metric in sensorIDs.keys) _metrics[metric]=new Metric(sensorIDs[metric],metric);
  }

  bool hasMetric(String metric) => _metrics.containsKey(metric);

  dynamic getValue(String metric) => _metrics[metric].value;

  dynamic getDate(String metric) => _metrics[metric].date;

  dynamic getTime(String metric) => _metrics[metric].time;

  String getIconPath(String metric) => _metrics[metric].iconPath;

  Color getColor (String metric) => _metrics[metric].color;

  List<dynamic> getPastValues (String metric) => _metrics[metric].pastValues;

  dynamic getGain (String metric) => _metrics[metric].gain;

  dynamic getGainPercentage (String metric) => _metrics[metric].gainPercentage;

  int getNumSensors() => _metrics.length;

  Iterable<String> getMetrics() => _metrics.keys;

  update() async {
    for (String metric in _metrics.keys) {
      await _metrics[metric].update();
    }
  }

}