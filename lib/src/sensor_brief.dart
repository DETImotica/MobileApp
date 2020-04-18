import 'package:deti_motica_app/src/metric.dart';

class SensorBr {
  String id;
  String description;
  String type;
  String unit;

  SensorBr(this.id, this.description, this.type, this.unit);

  Metric metricInfo() => Metric(id,type,description,unit);
}