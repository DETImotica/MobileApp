import 'dart:io';
import 'dart:convert';

String apiHost="192.168.85.215";
String url="https://$apiHost:443/";

bool _certificateCheck(X509Certificate cert, String host, int port) {
  return host==apiHost;
}

class Metric {
  String id;
  dynamic value;
  String type;

  Metric(this.id,this.type) {
    value=0;
  }

  update() async {
    HttpClient client = new HttpClient()
      ..badCertificateCallback = (_certificateCheck);

    String post=url+"api/v1/sensor/$id/measure/instant";

    var request=await client.getUrl(Uri.parse(post));
    var response=await request.close();
    String responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode>=200 && response.statusCode<=400) {
      var dict=jsonDecode(responseBody);
      value=dict["values"][0]["value"];
    }
    else print("Communications Error: ${response.statusCode}");

    client.close();
  }
}