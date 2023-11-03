import 'package:calentime/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class timetable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('time table',
        style: TextStyle(
            fontSize: 20,
            // font style 어케해
            //fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: PRIMARY_color,
        centerTitle: true,
        elevation: 0.0,
        leading: Icon(Icons.list_alt),


      ),
      body: Center(
        child: Text(
          '아 구웨ㅔ에에에엑',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}