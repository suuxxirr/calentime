import 'package:calentime/controller/database_controller.dart';
import 'package:calentime/model/todo_item.dart';

// 함수

class TodoRepository {
  static Future<int> create(TodoItem item) async {
    return await DataBaseController.to.database.insert(
      TodoItemDbInfo.table,
      item.toMap(),
    );
  }

  static Future<List<TodoItem>> findByDateRange(
      DateTime startDate, DateTime endDate,
      {bool? isDone}) async {
    List<dynamic> queryValues = [
      startDate.toIso8601String(),
      endDate.toIso8601String()
    ];
    // 생성 날짜 기준 조회
    // sqflite
    var query = '''  
              select 
              *
              from ${TodoItemDbInfo.table} 
              where ${TodoItemDbInfo.createdAt} >= ? and ${TodoItemDbInfo.createdAt} <= ? ''';
    if (isDone != null) {
      query += 'and ${TodoItemDbInfo.isDone} = ?';
      queryValues.add(isDone ? 1 : 0);
    }
    var results = await DataBaseController.to.database.rawQuery(
      query,
      queryValues,
    );
    return results.map((data) => TodoItem.fromJson(data)).toList();
  }

  // 리스트 업데이트
  static Future<int> update(TodoItem item) async {
    try {
      return await DataBaseController.to.database.update(
          TodoItemDbInfo.table, item.toMap(),
          where: '${TodoItemDbInfo.id} = ?', whereArgs: [item.id]);
    } catch (e) {
      print(e);

      return 0;
    }
  }

  // 삭제 함수
  static Future<int> delete(TodoItem item) async {
    return await DataBaseController.to.database
        .delete(TodoItemDbInfo.table, where: 'id=?', whereArgs: [item.id]);
  }
}