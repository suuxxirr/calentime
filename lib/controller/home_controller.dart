import 'package:calentime/components/work_editor.dart';
import 'package:calentime/controller/work_editor_controller.dart';
import 'package:calentime/model/todo_item.dart';
import 'package:calentime/repository/todo_repository.dart';
import 'package:calentime/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  Rx<Size> calendarSize = Size.zero.obs;
  Rx<Size> calendarHeaderSize = Size.zero.obs;
  GlobalKey calendarKey = GlobalKey();
  GlobalKey calendarHeaderKey = GlobalKey();

  Rx<DateTime> headerDate = DateTime.now().obs;
  RxList<TodoItem> currentMonthTodoList = <TodoItem>[].obs;
  RxList<TodoItem> currentTodoListByCurrentDate = <TodoItem>[].obs; // 할 일 목록
  RxList<TodoItem> currentWorkDoneListByCurrentDate = <TodoItem>[].obs; // 완료 목록
  RxDouble progress = 0.0.obs; // 할 일 진행도
  DateTime currentDate = DateTime.now(); // 현재 날짜

  @override
  void onInit() {
    super.onInit();
    refreshCurrentMonth();
  }

  // 달력 완성 시 호출
  void onCalendarCreated(PageController pageController) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      var calendarSizeData = getRenderBoxSize(calendarKey);
      if (calendarSizeData != null) {
        calendarSize(calendarSizeData);
      } // 달력 높이
      var calendarHeaderSizeData = getRenderBoxSize(calendarHeaderKey);
      if (calendarHeaderSizeData != null) {
        calendarHeaderSize(calendarHeaderSizeData); // panel 올렸을 때
      }
    });
  }

  Size? getRenderBoxSize(GlobalKey key) {
    if (key.currentContext != null) {
      var renderBox = key.currentContext!.findRenderObject() as RenderBox;
      var translation = renderBox.getTransformTo(null).getTranslation();
      return Size(0, renderBox.size.height + translation.y + 20);
    }
    return null;
  }

  void refreshCurrentMonth() async {
    await onPageChange(currentDate);
    var list = // 현재 날짜 받아오기
    TodoDataUtils.findTodoListByDateTime(currentMonthTodoList, currentDate);
    onSelectedDate(currentDate, list);
  }

  //
  void onSelectedDate(DateTime date, List<TodoItem> todayTodoList) {
    currentDate = date;
    currentWorkDoneListByCurrentDate.clear();
    currentTodoListByCurrentDate.clear();
    for (var todo in todayTodoList) {
      if (todo.isDone != null && todo.isDone) { // 완료
        currentWorkDoneListByCurrentDate.add(todo);
      } else { // 미완료
        currentTodoListByCurrentDate.add(todo);
      }
    }
    _calcTodayWorkProgresive();
  }

  // 체크 토글
  void toggleTodoItem(TodoItem todoItem) async {
    late TodoItem changeTodoItem;
    if (todoItem.isDone) { // 완료 시 취소
      changeTodoItem = todoItem.clone(isDone: !todoItem.isDone);
      currentWorkDoneListByCurrentDate.remove(todoItem); // 완료 목록에서 빼서
      currentTodoListByCurrentDate.add(changeTodoItem); // 할 일 목록에 넣기
    } else { // 취소 시 완료
      changeTodoItem = todoItem.clone(isDone: !todoItem.isDone);
      currentTodoListByCurrentDate.remove(todoItem); // 할일 목록에서 빼서
      currentWorkDoneListByCurrentDate.add(changeTodoItem); // 완료 목록에 넣기
    }
    await TodoRepository.update(changeTodoItem);
    _calcTodayWorkProgresive();
    refreshCurrentMonth();
  }

  // 진행도 바
  void _calcTodayWorkProgresive() {
    var total = currentTodoListByCurrentDate.length +
        currentWorkDoneListByCurrentDate.length;
    if (total == 0) { // 등록 + 완료 = 0
      progress(0);
    } else {
      progress(currentWorkDoneListByCurrentDate.length / total); // 진행도 = 완료 / 전체
    }
  }

  Future<void> onPageChange(DateTime date) async {
    var startDate = date.subtract(Duration(days: date.day - 1));
    var endDate = DateTime(date.year, date.month + 1, 0);
    var findCurrentMonthTodoList =
    await TodoRepository.findByDateRange(startDate, endDate);
    currentMonthTodoList(findCurrentMonthTodoList);
    headerDate(date); // 연월
  }

  // 할 일 삭제
  Future<void> deleteTodoItem(TodoItem item) async {
    await TodoRepository.delete(item);
    refreshCurrentMonth();
  }

  Future<void> editTodoItem(TodoItem item) async {
    Get.to(
          () => const WorkEditor(),
      arguments: {'editItem': item},
      opaque: false,
      fullscreenDialog: true,
      duration: Duration.zero,
      transition: Transition.downToUp,
      binding: BindingsBuilder(
            () {
          Get.put(WorkEditorController());
        },
      ),
    );
  }

  double get slidingUpPanelMinHeight {
    return Get.height -
        calendarSize.value.height -
        Get.mediaQuery.padding.bottom;
  }

  double get slidingUpPanelMaxHeight {
    return Get.height -
        calendarHeaderSize.value.height +
        Get.mediaQuery.padding.top;
  }
}