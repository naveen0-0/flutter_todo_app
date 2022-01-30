import 'package:flutter/material.dart';
import 'package:todo/app.dart';

void main(){
  runApp(MaterialApp(
    title: "Todo Application",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.green
    ),
    home: MyApp(),
  ));
}