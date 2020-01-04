import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Mapping.dart';
import 'Authentication.dart';
void main (){
  runApp(new BlogApp());
}
class BlogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  systemNavigationBarColor: Color(0xff21254a),
  statusBarIconBrightness: Brightness.light,
));
    return new MaterialApp(
      title: "Mr. Foxie",
      theme: new ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: MappingPage(auth: Auth(),),
    );
  }
}