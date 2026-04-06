import 'package:flutter/material.dart';

class TableNumberShape extends StatelessWidget {
  final int number;
  final Color backgroundColor;
  final Color textColor;
  final ShapeBorder shape;

  const TableNumberShape({
    Key? key,
    required this.number,
    this.backgroundColor = Colors.amber,
    this.textColor = Colors.white,
    this.shape = const CircleBorder(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: shape,
      elevation: 4,
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        child: Text(
          number.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
