import 'package:deti_motica_app/page/list_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(DETIMotica());

class DETIMotica extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RoomListPage()
    );
  }
}
