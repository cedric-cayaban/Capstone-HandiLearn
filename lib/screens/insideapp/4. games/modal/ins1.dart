import 'package:flutter/material.dart';

class Ins1 extends StatefulWidget {
  const Ins1({super.key});

  @override
  State<Ins1> createState() => _Ins1State();
}

class _Ins1State extends State<Ins1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('data1'),
          Text('data1'),
        ],
      ),
    );
  }
}
