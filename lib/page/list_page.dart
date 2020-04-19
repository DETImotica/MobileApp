import 'dart:convert';
import 'dart:math';
import 'package:deti_motica_app/page/room_page.dart';
import 'package:deti_motica_app/src/import.dart';
import 'package:deti_motica_app/src/metric_icon.dart';
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
                return SingleChildScrollView(
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child:_buildRoomList(context,snapshot.data)
                    )
                  )
                );
              }
            }
            else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(flex: 3),
                  Image.asset("assets/images/logo.png",height: 48,width: 48),
                  Spacer(flex: 1),
                  CircularProgressIndicator(),
                  Spacer(flex: 3),
                ],
              )
            );
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
      //TODO fetch occupants from sensor
      room.occupancy=Random().nextInt(3);
    }

    return list;
  }

  Widget _buildRoomList(BuildContext context, List<RoomBr> rList) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          rList[index].isExpanded=!isExpanded;
        });
      },
      children: rList.map<ExpansionPanel>((RoomBr room) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return (isExpanded?
            Container(
              padding: EdgeInsets.fromLTRB(30, 16, 30, 16),
              alignment: Alignment.center,
              child: Text(
                "${room.dept}.${room.floor}.${room.num}",
                style: TextStyle(fontSize: 28),
              ),
            ):
            Container(
              padding: EdgeInsets.fromLTRB(30, 16, 30, 16),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Text(
                    "${room.dept}.${room.floor}.${room.num}",
                    style: TextStyle(fontSize: 28),
                  ),
                  Expanded(
                    child: Text(
                      "${room.occupancy} pessoas",
                      style: TextStyle(color: Colors.grey, fontSize: 24),
                      textAlign: TextAlign.right,
                    )
                  )
                ],
              )
            ));
          },
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Número estimado de ocupantes: ${room.occupancy}",
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.left
                  ),
                )
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                      "${room.description}",
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                      textAlign: TextAlign.left
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 8, 8, 30),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Wrap(children: _getRoomIcons(room), direction: Axis.horizontal)
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 16, 0),
                      child: IconButton(
                        icon: Image.asset("assets/images/details.png"),
                        iconSize: 48,
                        onPressed: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => RoomPage(room.roomInfo())));
                        },
                      )
                    )
                  ],
                )
              )
            ],
          ),
          isExpanded: room.isExpanded
        );
      }).toList()
    );
  }

  List<Widget> _getRoomIcons(RoomBr room) {
    List<Widget> list=List();
    for (SensorBr sensor in room.sensors.values) {
      if (MetricIcon.getData.containsKey(sensor.type)) list.add(
        Image.asset(MetricIcon.getData[sensor.type]["path"],width: 48,height: 48)
      );
    }
    return list;
  }
}