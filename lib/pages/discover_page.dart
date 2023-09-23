import 'package:flutter/material.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({ Key? key }) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Center(
        child: Text('Discover more stuff'),
      ),
    );
  }
}