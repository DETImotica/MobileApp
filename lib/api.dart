import 'dart:io';
import 'dart:convert';

//String apiHost="192.168.85.215/";
String apiHost="detimotic-aulas.ws.atnog.av.it.pt/";
String url="https://$apiHost";
String sessionID="";
String userAgent="detimotic_app";
int statusCode=0;

bool certificateCheck(X509Certificate cert, String host, int port) {
  return host==apiHost;
}

Future<String> apiGet(String url) async {
  HttpClient client = HttpClient()
    ..badCertificateCallback = (certificateCheck);

  client.userAgent=userAgent;

  var request=await client.getUrl(Uri.parse(url));
  request.cookies.add(Cookie("session",sessionID));
  request.followRedirects=false;
  var response=await request.close();
  String responseBody = await response.transform(utf8.decoder).join();
  client.close();
  String ret="${response.statusCode}";
  statusCode=response.statusCode;
  if (response.statusCode>=200 && response.statusCode<400) ret=responseBody;
  else print("$url-Communications Error: ${response.statusCode}");

  return ret;
}

setSession(String id) {
  sessionID=id;
}