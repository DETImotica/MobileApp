import 'package:deti_motica_app/src/import.dart';

class RoomBr {
  int dept;
  int floor;
  int num;

  RoomBr(this.dept, this.floor, this.num);

  Room roomInfo() {
    return Room(
      {
        "luminosidade":"144f7484-7446-4e8f-b58e-c25221904dea",
        "temperatura":"55fbf7d0-cc47-4642-9290-a493d383ad8c",
      },
      dept,floor,num
    );
  }
}