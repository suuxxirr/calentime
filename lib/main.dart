import 'package:calentime/app.dart';
import 'package:calentime/bindings/init_binding.dart';
import 'package:calentime/controller/home_controller.dart';
import 'package:calentime/page/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:calentime/page/timetable.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
//import 'home.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'calentime',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // appbar 모서리 둥글게
        appBarTheme: AppBarTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15), // 원하는 만큼 조절
            ),
          ),
        ),
      ),

      initialBinding: InitBinding(),
      home: PageSlider(), // PageSlider를 홈으로 설정
    );
  }
}

// page view용 page slider
class PageSlider extends StatelessWidget {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: [
        App(),         // 첫 번째 페이지
        timetable(),  // 두 번째 페이지
      ],
    );
  }
}
