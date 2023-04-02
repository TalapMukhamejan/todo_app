import 'package:flutter/material.dart';
import 'package:todo_app/data/database.dart';
import 'bottom_sheet.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class TaskMaker extends StatefulWidget {
  static int globIndex = -1;

  @override
  State<TaskMaker> createState() => _TaskMakerState();
}

class _TaskMakerState extends State<TaskMaker> {
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    // TODO: implement initState
    if (_myBox.get('TODOLIST') == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  void modalBottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (builder) {
        return CustomBottomSheet();
      },
    ).then((value) {
      setState(() {
        TaskMaker.globIndex = -1;
        db.updateDataBase();
      });
    });
  }

  void _showPopupMenu(Offset offset, int idx) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      context: context,
      position: RelativeRect.fromLTRB(left, top, left, 0),
      items: [
        PopupMenuItem(
          value: 1,
          child: Text("Edit"),
        ),
        PopupMenuItem(
          value: 2,
          child: Text("Delete"),
        ),
      ],
      elevation: 5.0,
    ).then((value) {
// NOTE: even you didnt select item this method will be called with null of value so you should call your call back with checking if value is not null
      if (value == 1) {
        TaskMaker.globIndex = idx;
        modalBottomSheetMenu(context);
      } else if (value == 2) {
        ToDoDataBase.tasks.removeAt(idx);
        db.updateDataBase();
        setState(() {});
      }
      if (value != null) print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ToDoDataBase.tasks.isEmpty
        ? Expanded(
            child: Center(
            child: Text(
              'Add New Task',
              style: TextStyle(fontSize: 25, color: Colors.black45),
            ),
          ))
        : Expanded(
            child: GridView.builder(
              itemCount: ToDoDataBase.tasks.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                // crossAxisSpacing: 10,
                // mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      ToDoDataBase.tasks[index][2] =
                          !ToDoDataBase.tasks[index][2];
                      db.updateDataBase();
                    });
                  },
                  onLongPressStart: (details) {
                    _showPopupMenu(details.globalPosition, index);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(8),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(int.parse(ToDoDataBase.tasks[index][1])),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          ToDoDataBase.tasks[index][0],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          timeago.format(ToDoDataBase.tasks[index][3]),
                          style: TextStyle(
                            color: Colors.grey[100],
                            fontSize: 15,
                          ),
                        ),
                        Expanded(child: Container()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Color(
                                    int.parse(ToDoDataBase.tasks[index][1])),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    spreadRadius: 3,
                                  )
                                ],
                              ),
                              child: ToDoDataBase.tasks[index].length != 2
                                  ? (ToDoDataBase.tasks[index][2] == true
                                      ? Icon(
                                          Icons.circle,
                                          color: Colors.grey.shade100,
                                        )
                                      : null)
                                  : null,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }
}
