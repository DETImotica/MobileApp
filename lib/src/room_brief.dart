import 'package:deti_motica_app/src/import.dart';
import 'package:deti_motica_app/src/sensor_brief.dart';

class RoomBr {
  int dept;
  int floor;
  int num;
  String description;
  bool isExpanded;
  int occupancy;

  Map<String,SensorBr> sensors;

  RoomBr(this.dept, this.floor, this.num, this.description) {
    sensors=Map();
    isExpanded=false;
    occupancy=-1;
  }

  RoomBr.id(String id, this.description) {
    var split=id.split(".");
    if (split.length==3) {
      try {
        dept = int.parse(split[0]);
        floor = int.parse(split[1]);
        num = int.parse(split[2]);
      }
      on FormatException {
        dept=floor=num=0;
      }
    }
    else dept=floor=num=0;
    sensors=Map();
    isExpanded=false;
    occupancy=-1;
  }

  Room roomInfo() {
    return Room(sensors,dept,floor,num);
  }

  String getName() => "$dept.$floor.$num";
}