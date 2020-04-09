import 'package:http/http.dart' as http;
import 'dart:convert';

String url="https://192.168.85.215:443/";

class Metric {
  String id;
  dynamic value;
  String type;

  Metric(this.id,this.type) {
    value=0;
  }

  void update() async {
    //String post=url+"1/sensor/$id/measure/instant";
    String post=url+"1/sensor/144f7484-7446-4e8f-b58e-c25221904dea/measure/instant";

    var response=await http.get(Uri.encodeFull(post));
    if (response.statusCode>=200 && response.statusCode<=400) {
      var dict=jsonDecode(response.body);
      //TODO parse values from response
      print(dict);
    }
    else print("Communications Error: ${response.statusCode}");
  }
}