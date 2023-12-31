import 'package:calentime/const/colors.dart';
import 'package:calentime/model/todo_item.dart';
import 'package:calentime/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

class TodoCalendar extends StatefulWidget {
  final Function(PageController) onCalendarCreated;
  final Function(DateTime) onPageChange;
  final Function(DateTime, List<TodoItem>) onSelectedDate;
  final List<TodoItem> todoItmes;
  final DateTime focusMonth;
  TodoCalendar({
    Key? key,
    required this.focusMonth,
    required this.onCalendarCreated,
    required this.onPageChange,
    required this.onSelectedDate,
    required this.todoItmes,
  }) : super(key: key);

  @override
  State<TodoCalendar> createState() => _TodoCalendarState();
}

class _TodoCalendarState extends State<TodoCalendar> {
  DateTime? _selectedDay;
  DateTime? _focusedDay;
  List<TodoItem> todoItems = [];
  @override
  void initState() {
    super.initState();
  }

  setTodoItems() {
    todoItems = widget.todoItmes;
    _focusedDay = widget.focusMonth;
    update();
  }

  void update() => setState(() {});

  @override
  void didUpdateWidget(TodoCalendar oldWidget) {
    if (todoItems != widget.todoItmes) {
      setTodoItems();
    }
    super.didUpdateWidget(oldWidget);
  }

  Widget _dowHeaderStyle({required String date, required Color color}) {
    return Center(
      child: SizedBox(
        height: 30,
        child: Text(
          date,
          style: GoogleFonts.notoSans(color: color, fontSize: 13),
        ),
      ),
    );
  }

  Widget _dayStyle({
    required DateTime date,
    Color? color,
    bool isToday = false,
    bool isSelected = false, // 선택
    bool isComplete = false, // 작업 완료
  }) {
    var backgroundColor = Colors.white;
    if (isToday) backgroundColor = const Color(0xffbebfc7);
    if (isSelected) backgroundColor = const Color(0xFF4DA9FF);
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: Text(
              '${date.day}',
              style: GoogleFonts.notoSans(
                  color: isToday ? Colors.white : color, fontSize: 16),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Builder(builder: (context) {
                var items =
                TodoDataUtils.findTodoListByDateTime(todoItems, date);
                if (items.isNotEmpty) {
                  print(date);
                }
                return items.isNotEmpty
                    ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isComplete ? Colors.grey : Color(0xFF725bf4), // 투두리스트 완료/미완료
                    ),
                    width: 5,
                    height: 5)
                    : Container();
              }),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      headerVisible: false,
      locale: 'ko_KR',
      firstDay: DateTime(DateTime.now().year, 1, 1),
      lastDay: DateTime(DateTime.now().year + 2, 1, 1),
      focusedDay: _focusedDay ?? DateTime.now(),
      calendarFormat: CalendarFormat.month,
      calendarStyle: const CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: PRIMARY_color,//Colors.red,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Color(0xFF4DA9FF),// 오늘
          shape: BoxShape.circle,
        ),
      ),
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          widget.onSelectedDate(selectedDay,
              TodoDataUtils.findTodoListByDateTime(todoItems, selectedDay));
        }
      },

      // 스타일 (요일 색상)
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, date) {
          //상단 요일
          return _dowHeaderStyle(
            date: TodoDataUtils.convertWeekdayToStringValue(date.weekday),
            color: TodoDataUtils.dayToColor(date),
          );
        },
        // 1~끝 일
        defaultBuilder: (context, date, _) => _dayStyle(
          date: date,
          color: TodoDataUtils.dayToColor(date),
          isToday: false,
          isComplete: TodoDataUtils.isComplate(todoItems, date),
        ),
        // 전달&다음달 일 일부 보여주기
        outsideBuilder: (context, date, _) => _dayStyle(
          date: date,
          color: TodoDataUtils.dayToColor(date, opacity: 0.3),
          isComplete: TodoDataUtils.isComplate(todoItems, date),
        ),
      ),
      onCalendarCreated: widget.onCalendarCreated,
      onFormatChanged: (format) {},
      onPageChanged: widget.onPageChange,
    );
  }
}


//