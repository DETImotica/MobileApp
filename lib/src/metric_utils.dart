import 'package:flutter/material.dart';

class MetricIcon{

  static final getData = {
    'Luminosidade': {'path': 'assets/images/lux.png', 'color': Colors.orange},
    'Temperatura': {'path': 'assets/images/temp.png', 'color': Colors.red},
    'Som': {'path': 'assets/images/audio.png', 'color': Colors.black},
    'Pressão': {'path': 'assets/images/pressure.png', 'color': Colors.lightBlue},
    'Humidade': {'path': 'assets/images/humidity.png', 'color': Colors.blue},
    'Dióxido de Carbono': {'path': 'assets/images/co2.png', 'color': Colors.blueGrey},
    'Qualidade do Ar': {'path': 'assets/images/iaq.png', 'color': Colors.blue},
    'Bluetooth': {'path': 'assets/images/bluetooth.png', 'color': Colors.blue}
  };
}

class MetricRanges {

  static final _valueRanges = {
    'Luminosidade': {'min': 100, 'midlow': 200, 'midhigh': 500},
    'Temperatura': {'min': 12, 'midlow': 18, 'midhigh': 24, 'max': 30},
    'Som': {'midlow': 0, 'midhigh': 65, 'max': 100},
    'Humidade': {'midlow': 30, 'midhigh': 40, 'max': 55},
    'Dióxido de Carbono': {'midlow': 100, 'midhigh': 1000, 'max': 2000},
    'Qualidade do Ar': {'midlow': 0, 'midhigh': 100, 'max': 200},
  };

  static Image getGauge(String metric, dynamic value) {
    double val;
    if (value is num) val=value.toDouble();
    else return null;
    if (!_valueRanges.containsKey(metric)) return null;

    String path;
    var dict=_valueRanges[metric];
    if (dict.containsKey('min') && val<dict['min']) path="assets/images/lowest.png";
    else if (dict.containsKey('midlow') && val<dict['midlow']) path="assets/images/low.png";
    else if (dict.containsKey('midhigh') && val<dict['midhigh']) path="assets/images/good.png";
    else if (dict.containsKey('max')) {
      if (val<dict['max']) path="assets/images/high.png";
      else path="assets/images/highest.png";
    }
    if (path==null) return null;
    return Image.asset(path,width:50,height:50);
  }
}
