import 'dart:io';

String apiHost="192.168.85.215";
String url="https://$apiHost:443/";

bool certificateCheck(X509Certificate cert, String host, int port) {
  return host==apiHost;
}