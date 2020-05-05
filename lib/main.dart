import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String appTitle = 'MainPage';
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: appTitle,
      home: MainPage(appTitle: appTitle),
    );
}

class MainPage extends StatelessWidget {
  final String appTitle;

  const MainPage({this.appTitle});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: Container(),
    );
}