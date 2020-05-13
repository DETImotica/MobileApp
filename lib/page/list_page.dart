import 'dart:convert';
import 'dart:math';
import 'package:deti_motica_app/page/room_page.dart';
import 'package:deti_motica_app/src/import.dart';
import 'package:deti_motica_app/src/metric_utils.dart';
import 'package:deti_motica_app/src/sensor_brief.dart';
import 'package:flutter/material.dart';
import 'package:deti_motica_app/api.dart';

class RoomListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RoomListState();
}

class _RoomListState extends State<RoomListPage> {

  Future<List<RoomBr>> roomList;
  bool ready=false;

  _RoomListState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          _roomsFiltered = _rooms;
        });
      }
      else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    roomList=_getRooms();
  }

  String title="Salas Monitorizadas";

  final TextEditingController _filter = new TextEditingController();

  String _searchText = "";
  List<RoomBr> _rooms=List();
  List<RoomBr> _roomsFiltered=List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _searchBarTitle = new Text("Salas Monitorizadas");

  void _searchPressed() {
    if (ready) setState(() {
      if (_searchIcon.icon == Icons.search) {
        _searchIcon = new Icon(Icons.close);
        _searchBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search),
              hintText: '<dep>.<piso>.<sala>'
          ),
        );
      }
      else {
        _searchIcon = new Icon(Icons.search);
        _searchBarTitle = new Text("Search...");
        _roomsFiltered = _rooms;
        _filter.clear();
      }
    });
  }

  void _logout() async {
    String post=url+"api/v1/logout";
    await apiGet(post);

    if (statusCode==401) Navigator.popAndPushNamed(context, "/err/401");
    else Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("$title"),
        leading: new Container(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,
          )
        ],
      ),
      body: FutureBuilder<List<RoomBr>>(
        future: roomList,
        builder: (context, snapshot) {
          if (snapshot.connectionState==ConnectionState.done) {
            if (snapshot.hasData) {
              ready=true;

              if (_searchText.isNotEmpty) {
                List<RoomBr> tempList = new List<RoomBr>();
                for (int i = 0; i < _roomsFiltered.length; i++) {
                  if (_roomsFiltered[i].getName().toLowerCase().contains(_searchText.toLowerCase())) {
                    tempList.add(_roomsFiltered[i]);
                  }
                }
                _roomsFiltered = tempList;
              }
              return Column(
                children: <Widget>[
                  /*Expanded(
                    child: Container()
                  ),*/
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: _searchIcon,
                          onPressed: _searchPressed,
                        ),
                        Expanded(child: _searchBarTitle),
                      ],
                    )
                  ),
                  Expanded(
                    child:SingleChildScrollView(
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(children:<Widget>[_buildRoomList(context,_roomsFiltered)])
                        )
                      )
                    )
                  )
                ]
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
    String response;
    bool stop=true;
    var dict;

    do {
      try {
        stop=true;
        response=await apiGet(post);
        var code=num.tryParse(response);
        if (code==502) stop=false;
        else if (code==401) Navigator.popAndPushNamed(context, "/err/401");
        dict=jsonDecode(response);
      }
      on FormatException {
        print("Could not decode response: ${(response[0]=="<"?"(HTML page)":response)}");
        stop=false;
      }
    } while(!stop);

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
    _rooms=list;
    _roomsFiltered=_rooms;
    return list;
  }

  void collapseAll() {
    setState(() {
      for (RoomBr room in _rooms) {
        room.isExpanded=false;
      }
    });
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
                "${room.name}",
                style: TextStyle(fontSize: 28),
              ),
            ):
            Container(
              padding: EdgeInsets.fromLTRB(30, 16, 30, 16),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Text(
                    "${room.name}",
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
                          collapseAll();
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
      list.add(Image.asset(MetricIcon.getIcon(sensor.type),width: 48,height: 48));
    }
    return list;
  }
}