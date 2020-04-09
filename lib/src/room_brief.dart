import 'package:deti_motica_app/src/import.dart';

class RoomBr {
  int dept;
  int floor;
  int num;

  RoomBr(this.dept, this.floor, this.num);

  Room roomInfo() {
    return Room(
      {
        "temp":"ID1",
        "humidity":"ID2",
      },
      dept,floor,num
    );
  }
}