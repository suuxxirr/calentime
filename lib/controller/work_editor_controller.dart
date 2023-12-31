import 'package:calentime/controller/home_controller.dart';
import 'package:calentime/model/todo_item.dart';
import 'package:calentime/repository/todo_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkEditorController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController dscriptionController = TextEditingController();
  bool isEditMode = false; // 수정/생성 모드
  bool isLoaded = false; // 로드 상태
  int editItemId = -1; // 수정할 작업 아이디
  RxDouble modalPosition = (Get.height - 300).obs; // 애니메이션용
  late DateTime createdAt;

  @override
  void onInit() {
    super.onInit();
    createdAt = HomeController.to.currentDate;
    if (Get.arguments != null && Get.arguments['editItem'] != null) {
      var editItem = (Get.arguments['editItem'] as TodoItem);
      editItemId = editItem.id!;
      isEditMode = true;
      titleController.text = editItem.todo;
      createdAt = editItem.createdAt;
      dscriptionController.text = editItem.description;
    }
    _setModalPosition();
    isLoaded = true;
  }

  void _setModalPosition() async {
    await Future.delayed(const Duration(milliseconds: 100));
    modalPosition(modalPositionValue);
  }

  double get modalPositionValue {
    return HomeController.to.calendarHeaderSize.value.height -
        Get.mediaQuery.padding.top +
        Get.mediaQuery.padding.bottom;
  }

  Future<void> submit() async {
    var title = titleController.text;
    var discription = dscriptionController.text;
    try {
      if (title.trim() != '') {
        var todoItem = TodoItem(
          todo: title,
          description: discription,
          createdAt: HomeController.to.currentDate,
        );

        var result = -1;
        if (isEditMode) {
          result = await TodoRepository.update(todoItem.clone(id: editItemId));
        } else {
          result = await TodoRepository.create(todoItem);
        }
        if (result > 0) {
          HomeController.to.refreshCurrentMonth();
          back();
        }
      }
    } catch (e) {
      //메세지 처리
    }
  }

  void focusOut() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void back() {
    focusOut();
    Get.back();
  }
}