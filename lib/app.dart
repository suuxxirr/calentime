import 'package:calentime/controller/database_controller.dart';
import 'package:calentime/controller/home_controller.dart';
import 'package:calentime/page/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery( // 미디어 쿼리 위젯 사용
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), // 폰트 고정
      child: Container(
        color: Colors.white,
        child: FutureBuilder<bool>(
            future: DataBaseController.to.initDataBase(),
            builder: (_, snaphot) {
              if (snaphot.hasError) {
                return const Center(
                  child: Text('sqflite를 지원하지 않습니다.'),
                );
              }
              if (snaphot.hasData) {
                Get.put(HomeController()); //컨트롤러 등록
                return const TodoHome();
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}