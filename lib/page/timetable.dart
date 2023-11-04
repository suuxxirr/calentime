import 'package:calentime/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class timetable extends StatefulWidget {


  @override
  State<timetable> createState() => _timetableState();
}

class _timetableState extends State<timetable> {
  List week = ['월', '화', '수', '목', '금'];

  var kColumnLength = 22;

  double kFirstColumnHeight = 20; // 요일 컬럼
  double kBoxSize = 52;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('time table',
        style: TextStyle(
            fontSize: 20,
            // font style
            //fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: PRIMARY_color,
        centerTitle: true,
        elevation: 0.0,
        leading: Icon(Icons.edit),


      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: (kColumnLength / 2 * kBoxSize) + kFirstColumnHeight,
                child: Row(
                  children: [
                      buildTimeColumn(),
                    ...buildDayColumn(0),
                    ...buildDayColumn(1),
                    ...buildDayColumn(2),
                    ...buildDayColumn(3),
                    ...buildDayColumn(4),

                  ],
                )
              )
            ],
          ),
        ),
      )
    );
  }

  Expanded buildTimeColumn(){
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: kFirstColumnHeight,
          ),
          ...List.generate(
            kColumnLength.toInt(),
                (index) {
              if (index % 2 == 0) {
                return const Divider(
                  color: Colors.grey,
                  height: 0,
                );
              }
              return SizedBox(
                height: kBoxSize,
                child: Center(child: Text('${index ~/ 2 + 9}')), // 시간표 시작 시간
              );
            },
          ),
        ],
      ),
    );
  }

  List selectedLectures = []; // 강의를 담을 리스트
  List<Widget> buildDayColumn(int index) {
    String currentDay = week[index];
    List<Widget> lecturesForTheDay = [];

    for (var lecture in selectedLectures) {
      for (int i = 0; i < lecture.day.length; i++) {
        double top = kFirstColumnHeight + (lecture.start[i] / 60.0) * kBoxSize;
        double height = ((lecture.end[i] - lecture.start[i]) / 60.0) * kBoxSize;

        if (lecture.day[i] == currentDay) {
          lecturesForTheDay.add(
            Positioned(
              top: top,
              left: 0,
              child: Stack(children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedLectures.remove(lecture);
                      setTimetableLength();
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 5,
                    height: height,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                    child: Text(
                      "${lecture.lname}\n${lecture.classroom[i]}",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ]),
            ),
          );
        }
      }
    }
    return [
      const VerticalDivider(
        color: Colors.grey,
        width: 0,
      ),
      Expanded(
        flex: 4,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20,
                  child: Text(
                    '${week[index]}',
                  ),
                ),
                ...List.generate(
                  kColumnLength.toInt(),
                      (index) {
                    if (index % 2 == 0) {
                      return const Divider(
                        color: Colors.grey,
                        height: 0,
                      );
                    }
                    return SizedBox(
                      height: kBoxSize,
                      child: Container(),
                    );
                  },
                ),
              ],
            ),
            ...lecturesForTheDay, // 현재 요일에 해당하는 모든 강의를 Stack에 추가
          ],
        ),
      ),
    ];
  }

  // 시간표 길이 조정
  void setTimetableLength() {
    double newTimetableHeight = calculateTimetableHeight(selectedLectures.length);
    setState(() {
      double timetableHeight = newTimetableHeight;
    });
  }

  double calculateTimetableHeight(int lectureCount) {
    return lectureCount * kBoxSize;
  }
}