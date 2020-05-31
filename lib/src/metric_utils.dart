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

  static String getIcon(String metric) {
    if (getData.containsKey(metric)) return getData[metric]['path'];
    else return 'assets/images/noimage.png';
  }

  static Color getColour(String metric) {
    if (getData.containsKey(metric)) return getData[metric]['color'];
    else return Colors.grey;
  }
}

class MetricRanges {

  static final _valueRanges = {
    'Luminosidade': {'min': 100, 'midlow': 200, 'midhigh': 500, 'measure': 'Lux'},
    'Temperatura': {'min': 12, 'midlow': 18, 'midhigh': 24, 'max': 30, 'measure': 'ºC'},
    'Som': {'midlow': 0, 'midhigh': 65, 'max': 100, 'measure': 'Db'},
    'Humidade': {'midlow': 30, 'midhigh': 50, 'max': 65, 'measure': 'RH'},
    'Dióxido de Carbono': {'midlow': 100, 'midhigh': 1000, 'max': 2000},
    'Qualidade do Ar': {'midlow': 0, 'midhigh': 100, 'max': 200, 'measure': 'IAQ'},
  };

  static Image getGauge(String metric, String measure, dynamic value) {
    double val;
    if (value is num) val=value.toDouble();
    else return null;
    if (!_valueRanges.containsKey(metric)) return null;

    String path;
    var dict=_valueRanges[metric];
    if (dict.containsKey('measure') && dict['measure']!=measure) return null;
    else if (dict.containsKey('min') && val<dict['min']) path="assets/images/lowest.png";
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
