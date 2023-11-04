import 'package:calentime/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:calentime/page/timetable.dart';

class TimetableEdit extends StatelessWidget {
  const TimetableEdit({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: PRIMARY_color,
      body: Center(
        child: ElevatedButton(
          child: const Text('돌아가기'),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      )
    );
  }
}

