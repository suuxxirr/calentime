import 'package:calentime/app.dart';
import 'package:calentime/bindings/init_binding.dart';
import 'package:calentime/controller/home_controller.dart';
import 'package:calentime/page/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'calentime',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialBinding: InitBinding(),
      home: const App(),
    );
  }
}