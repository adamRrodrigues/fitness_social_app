import 'package:flutter/material.dart';

class FitnesstrackerPage extends StatefulWidget {
  const FitnesstrackerPage({ Key? key }) : super(key: key);

  @override
  _FitnesstrackerPageState createState() => _FitnesstrackerPageState();
}

class _FitnesstrackerPageState extends State<FitnesstrackerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Lazy tracker'),
      ),
    );
  }
}