import 'dart:io';
import 'dart:convert';
import 'package:deti_motica_app/src/metric_icon.dart';
import 'package:deti_motica_app/api.dart';
import 'package:flutter/material.dart';

class Metric {
  String id;
  String description;
  dynamic value;
  dynamic date;
  dynamic time;
  String type;
  String unit;
  String iconPath;
  Color color;
  dynamic pastValues;
  dynamic gain;
  dynamic gainPercentage;

  var iconData = MetricIcon.getData;

  Metric(this.id,this.type,[this.description,this.unit]) {
    value=0;
    date= "Invalid Date";
    time= "Invalid Hour";
    iconPath= iconData[this.type]['path'];
    color= iconData[this.type]['color'];
    pastValues= [0.0,1.0,2.0,3.0,4.0,5.0];
    gain=0;
    gainPercentage=0;
  }

  update() async {
    HttpClient client = new HttpClient()
      ..badCertificateCallback = (certificateCheck);

    DateTime now= DateTime.now();
    DateTime ago10= now.subtract(new Duration(minutes: 1));
    String post=url+"api/v1/sensor/$id/measure/interval?start="+ago10.toString()+"&end="+now.toString();
    var request=await client.getUrl(Uri.parse(post));
    var response=await request.close();
    String responseBody = await response.transform(utf8.decoder).join();
    if (response.statusCode>=200 && response.statusCode<400) {
      var dict=jsonDecode(responseBody);
      var data= [];
      for (var tuple in dict["values"]){
        data.add(tuple["value"].toDouble());
      }
      if (data.length > 0){
        pastValues= data;
        value=dict["values"][data.length-1]["value"];
        date=dict["values"][data.length-1]["time"].toString().substring(0,10);
        time=dict["values"][data.length-1]["time"].toString().substring(11,19);
        (data.length > 1) ? gain= dict["values"][data.length-1]["value"]- dict["values"][data.length-2]["value"]: gain = 0;
        (data.length > 1) ? gainPercentage= (dict["values"][data.length-1]["value"]- dict["values"][data.length-2]["value"])/dict["values"][data.length-2]["value"].toDouble(): gainPercentage = 0;
      }
    }
    else print("Communications Error: ${response.statusCode}");

    client.close();
  }
}
