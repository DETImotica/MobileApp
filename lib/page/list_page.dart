import 'dart:convert';
import 'package:deti_motica_app/page/room_page.dart';
import 'package:deti_motica_app/src/import.dart';
import 'package:deti_motica_app/src/sensor_brief.dart';
import 'package:flutter/material.dart';
import 'package:deti_motica_app/api.dart';

class RoomListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RoomListState();
}

class _RoomListState extends State<RoomListPage> {

  Future<List<RoomBr>> roomList;

  _RoomListState() {
    super.initState();
    roomList=_getRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Salas Monitorizadas"),
          centerTitle: true,
        ),
        body: FutureBuilder<List<RoomBr>>(
          future: roomList,
          builder: (context, snapshot) {
            if (snapshot.connectionState==ConnectionState.done) {
              if (snapshot.hasData) {
                return ListView(
                    children: _buildRoomList(context,snapshot.data)
                );
              }
            }
            else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          }
        )
    );
  }

  Future<List<RoomBr>> _getRooms() async {
    List<RoomBr> list=List();

    String post=url+"api/v1/rooms";
    String response=await apiGet(post);

    var dict=jsonDecode(response);
    for (String id in dict["ids"]) {
      post=url+"api/v1/room/$id";
      response=await apiGet(post);
      dict=jsonDecode(response);

      RoomBr room=RoomBr.id(dict["name"],dict["description"]);
      list.add(room);

      post=url+"api/v1/room/$id/sensors";
      response=await apiGet(post);
      Map senMap=jsonDecode(response);
      for (String sensor in senMap["ids"]) {
        post=url+"api/v1/sensor/$sensor";
        response=await apiGet(post);
        Map senData=jsonDecode(response);
        try {
          room.sensors[sensor]=SensorBr(
              sensor,
              senData["description"],
              senData["data"]["type"],
              senData["data"]["unit_symbol"]
          );
        }
        catch(exc) {
          print(exc);
        }
      }
    }

    return list;
  }

  List<Widget> _buildRoomList(BuildContext context, List<RoomBr> rList) {
    List<Widget> list=List();

    for (RoomBr room in rList) {
      list.add(Container(
        padding: EdgeInsets.all(8),
        child: FlatButton(
          child: Align(
            child: Text("${room.dept}.${room.floor}.${room.num}"),
            alignment: Alignment.centerLeft,
          ),
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => RoomPage(room.roomInfo())));
          },
        )
      ));
    }
    return list;
  }
}