import 'dart:convert';

import "package:deti_motica_app/src/metric.dart";
import 'package:deti_motica_app/src/metric_utils.dart';
import 'package:deti_motica_app/src/sensor_brief.dart';
import 'package:flutter/material.dart';

class Room {

  Map<String, Metric> _metrics;
  int dept;
  int floor;
  int num;


  Room(Map<String,SensorBr> sensors, this.dept, this.floor, this.num) {
    _metrics=new Map();
    for (String metric in sensors.keys) _metrics[sensors[metric].type]=sensors[metric].metricInfo();
  }

  bool hasMetric(String metric) => _metrics.containsKey(metric);

  dynamic getValue(String metric) => _metrics[metric].value;

  dynamic getDescription(String metric) => _metrics[metric].description;

  dynamic getUnit(String metric) => _metrics[metric].unit;

  dynamic getDate(String metric) => _metrics[metric].date;

  dynamic getTime(String metric) => _metrics[metric].time;

  String getIconPath(String metric) => _metrics[metric].iconPath;

  Image getGauge(String metric, dynamic value) => MetricRanges.getGauge(metric,value);

  Color getColor (String metric) => _metrics[metric].color;

  List<dynamic> getPastValues (String metric) => _metrics[metric].pastValues;

  dynamic getGain (String metric) => _metrics[metric].gain;

  dynamic getGainPercentage (String metric) => _metrics[metric].gainPercentage;

  int getNumSensors() => _metrics.length;

  Iterable<String> getMetrics() => _metrics.keys;

  initTracked(Map dict) {
    for (String id in dict['tracked']) {
      _metrics.forEach((key, value) {
        if (id==value.id) value.tracked=true;
      });
    }
  }

  bool toggleTracked(String metric) {
    _metrics[metric].tracked=!_metrics[metric].tracked;
    return _metrics[metric].tracked;
  }

  bool isTracked(String metric) {
    return _metrics[metric].tracked;
  }

  String getIdOf(String metric) {
    return _metrics[metric].id;
  }

  Future<Room> update() async {
    for (String metric in _metrics.keys) {
      await _metrics[metric].update();
    }
    return this;
  }

}