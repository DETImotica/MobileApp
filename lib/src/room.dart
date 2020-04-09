import "package:deti_motica_app/src/metric.dart";

class Room {

  Map<String, Metric> _metrics;
  int dept;
  int floor;
  int num;


  Room(Map<String,String> sensorIDs, this.dept, this.floor, this.num) {
    _metrics=new Map();
    for (String metric in sensorIDs.keys) _metrics[metric]=new Metric(sensorIDs[metric],metric);
    //update();
  }

  bool hasMetric(String metric) => _metrics.containsKey(metric);

  dynamic getValue(String metric) => _metrics[metric].value;

  int getNumSensors() => _metrics.length;

  Iterable<String> getMetrics() => _metrics.keys;

  void update() {
    for (String metric in _metrics.keys) _metrics[metric].update();
  }

}