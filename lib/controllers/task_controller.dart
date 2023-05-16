import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/db/db_helper.dart';

import '../models/task.dart';

class TaskController extends GetxController {
  final RxList<Task> taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  Future<void> getTask() async {
    /// فى الداله دي بقى هنستعين ب الداله اللى عملناها ف كلاس الداتابيز و اللى كان اسمها query اللى كان وظيفتها تستعلم عن البيانات عشان اجيب كل التاسكات اللى متخزنة عندي ف الداتابيز واقدر اعرضها
    try{
      final List<Map<String, dynamic>> tasks = await DBHelper.query();
      taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    }
    catch(e){
      print('i found errrrrrrrrror her KAREEM !!!!!!!!!!!! $e');
    }
  }

  void deleteTask(Task task) async {
    await DBHelper.delete(task);
    getTask();
  }
  void deleteAllTask() async {
    await DBHelper.deleteAll();
    getTask();
  }

  void markTaskAsCompleted(int id) async {
    await DBHelper.update(id);
    getTask();
  }
  // void check(){
  //   for(var i in taskList){
  //     if(DateTime.now()==i.endTime){
  //
  //     }
  //   }
  // }
}
