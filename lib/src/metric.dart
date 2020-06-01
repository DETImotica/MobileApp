import 'dart:convert';
import 'package:deti_motica_app/src/metric_utils.dart';
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
  bool tracked;

  bool active;

  Metric(this.id,this.type,[this.description,this.unit]) {
    value=0;
    date= "Invalid Date";
    time= "Invalid Hour";
    iconPath=MetricIcon.getIcon(type);
    color=MetricIcon.getColour(type);
    pastValues= [0.0,1.0,2.0,3.0,4.0,5.0];
    gain=0;
    gainPercentage=0;
    tracked=false;
    active=true;
  }

  update() async {
    DateTime now= DateTime.now();
    DateTime ago10= now.subtract(new Duration(minutes: 1));
    String post=url+"api/v1/sensor/$id/measure/interval?start="+ago10.toUtc().toString().replaceAll(" ", "T")+"&end="+now.toUtc().toString().replaceAll(" ", "T");
    String responseBody=await apiGet(post);

    var dict;
    try {
      dict=jsonDecode(responseBody);
      if ((dict as Map).length==0) {
        active=false;
        return;
      }
    }
    on FormatException {
      print("Could not decode response: ${(responseBody[0]=="<"?"(HTML page)":responseBody)}");
      if (responseBody[0]!="<") active=false;
      return;
    }
    on Exception {
      print("Misc Error");
      active=false;
      return;
    }

    var data= [];
    for (var tuple in dict["values"]){
      data.add(tuple["value"].toDouble());
    }
    if (data.length > 0){
      var lastVal=value;
      pastValues= data;
      value=dict["values"][data.length-1]["value"];
      DateTime dt=DateTime.parse(dict["values"][data.length-1]["time"]).toLocal();
      date="${dt.year}-${dt.month}-${dt.day}";
      time="${dt.hour}:${dt.minute}:${dt.second}";
      (data.length > 1) ? gain= value-lastVal: gain = 0;
      (data.length > 1 && lastVal.toDouble()!=0) ? gainPercentage= (value-lastVal)/lastVal.toDouble(): gainPercentage = 0;
      active=true;
    }
    else active=false;
  }
}
