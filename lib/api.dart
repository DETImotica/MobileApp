import 'dart:io';
import 'dart:convert';

//String apiHost="192.168.85.215/";
String apiHost="detimotic-aulas.ws.atnog.av.it.pt/";
String url="https://$apiHost";

bool certificateCheck(X509Certificate cert, String host, int port) {
  return host==apiHost;
}

Future<String> apiGet(String url) async {
  HttpClient client = new HttpClient()
    ..badCertificateCallback = (certificateCheck);

  print("Start: $url");
  var request=await client.getUrl(Uri.parse(url));
  print("Done");
  var response=await request.close();
  String responseBody = await response.transform(utf8.decoder).join();
  client.close();
  String ret="";
  if (response.statusCode>=200 && response.statusCode<400) ret=responseBody;
  else print("Communications Error: ${response.statusCode}");

  return ret;
}