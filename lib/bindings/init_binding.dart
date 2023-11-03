import 'package:calentime/controller/database_controller.dart';
import 'package:get/get.dart';

class InitBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(DataBaseController()); //databasecontroller 등록
  }
}