import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';

class ToDoDataBase {
  static List tasks = [
    // ['Make it', Colors.orange]
  ];

  final _myBox = Hive.box('mybox');

  void createInitialData() {
    tasks.add(['Make it', '0xFF69F0AE']);
  }

  void loadData() {
    tasks = _myBox.get('TODOLIST');
  }

  void checkData(){
    for(List task in tasks){
      if (task.length == 2){
        task.add(false);
      }
    }
  }

  void updateDataBase() {
    _myBox.put('TODOLIST', tasks);
  }
}
