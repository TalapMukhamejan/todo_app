import 'package:flutter/material.dart';
import 'sandwhich.dart';

class ColorDot extends StatefulWidget {
  VoidCallback onTap;
  late final Color backgroundColor;
  late int its_index;
  late List<bool> checker;

  ColorDot(
      {required this.backgroundColor,
        required this.its_index,
        required this.onTap,
        required this.checker});

  @override
  State<ColorDot> createState() => _ColorDotState();
}

class _ColorDotState extends State<ColorDot> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: widget.checker[widget.its_index]
                  ? widget.backgroundColor
                  : Colors.black45.withOpacity(0.4),
              spreadRadius: 1.5,
            )
          ],
        ),
        child: widget.checker[widget.its_index] ? Icon(Icons.check, color: Colors.white,) : null,
      ),
    );
  }
}
