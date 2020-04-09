import 'package:deti_motica_app/page/room_page.dart';
import 'package:deti_motica_app/src/import.dart';
import 'package:flutter/material.dart';

List<RoomBr> roomList;

class RoomListPage extends StatelessWidget {

  RoomListPage() {
    roomList=List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Salas Monitorizadas"),
          centerTitle: true,
        ),
        body: ListView(
          children: _buildRoomList(context)
        )
    );
  }

  List<Widget> _buildRoomList(BuildContext context) {
    //TODO retrieve room list from api
    List<Widget> list=List();

    for (var i=0;i<20;i++) {
      RoomBr room=RoomBr(4,1,10+i);
      roomList.add(room);
      list.add(Container(
        padding: EdgeInsets.all(8),
        child: FlatButton(
          child: Text("${room.dept}.${room.floor}.${room.num}"),
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => RoomPage(room.roomInfo())));
          },
        )
      ));
    }
    return list;
  }
}