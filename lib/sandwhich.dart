import 'package:flutter/material.dart';
import 'package:todo_app/task_maker.dart';
import 'color_dot.dart';
import 'data/database.dart';

class Sandwhich extends StatefulWidget {
  @override
  State<Sandwhich> createState() => _SandwhichState();
}

class _SandwhichState extends State<Sandwhich> {
  final _controller = TextEditingController();
  String _charCounter = '39';

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    if (TaskMaker.globIndex != -1) {
      _controller.text = ToDoDataBase.tasks[TaskMaker.globIndex][0];
      _charCounter = (39 - _controller.text.length).toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [TitleSand(), TextSand(), ColorSand(), pressMe()],
    );
  }

  List<String> backColors = [
    // '0xFF69F0AE'
    '0xFF4BB1F8',
    '0xFF53DB88',
    '0xFFF98A4B',
    '0xFFFF5E5E',
    '0xFF838FA4',
    '0xFF634BFA',
    '0xFFBBE587',
    '0xFFbc3e9f',
  ];

  List<bool> isButtonsEnabled = List.generate(8, (_) => false);

  // Color backgroundModalColor = Colors.orange;
  String backgroundModalColorHex = TaskMaker.globIndex != -1 ? ToDoDataBase.tasks[TaskMaker.globIndex][1] : '0xFF69F0AE';

  Row ColorSand() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        backColors.length,
        (index) {
          return Expanded(
            // padding: const EdgeInsets.all(8.0),
            child: ColorDot(
                backgroundColor: Color(int.parse(backColors[index])),
                its_index: index,
                onTap: () {
                  setState(() {
                    backgroundModalColorHex = backColors[index];
                    // backgroundModalColor = Color(int.parse(backColors[index]));
                    isButtonsEnabled =
                        isButtonsEnabled.map((e) => false).toList();
                    isButtonsEnabled[index] = true;
                  });
                },
                checker: isButtonsEnabled),
          );
        },
      ),
    );
  }

  Padding TextSand() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _controller,
        maxLength: 39,
        maxLines: 1,
        keyboardType: TextInputType.streetAddress,
        onChanged: (value) {
          setState(() {
            _charCounter = (39 - value.length).toString();
          });
        },
        decoration: InputDecoration(
          focusColor: Colors.white,
          hintText: 'Write a task',
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlueAccent),
          ),
          suffix: Text(_charCounter),
          counter: Offstage(),
        ),
      ),
    );
  }

  Container TitleSand() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Color(
          int.parse(backgroundModalColorHex),
        ),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
      ),
    );
  }

  Container pressMe() {
    return Container(
      margin: EdgeInsets.all(20),
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent),
        ),
        onPressed: () {
          setState(() {
            Navigator.pop(context);
            TaskMaker.globIndex != -1
                ? ToDoDataBase.tasks[TaskMaker.globIndex] = [
                    _controller.value.text,
                    backgroundModalColorHex,
                    ToDoDataBase.tasks[TaskMaker.globIndex][2],
                    ToDoDataBase.tasks[TaskMaker.globIndex][3]
                  ]
                : ToDoDataBase.tasks.add([
                    _controller.value.text,
                    backgroundModalColorHex,
                    false,
                    DateTime.now()
                  ]);
            TaskMaker.globIndex = -1;
          });
        },
        child: Text(
          TaskMaker.globIndex != -1 ? 'Change Task' : 'Create Task',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
