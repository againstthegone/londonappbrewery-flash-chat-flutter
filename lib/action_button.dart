import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Color backgroundColor;
  final String text;
  final VoidCallback? onPressed;

  ActionButton(
    this.text, {
    this.backgroundColor = Colors.blue,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: () {
            (onPressed ?? () {})();
          },
          minWidth: 200.0,
          height: 42.0,
          child: Text(text),
        ),
      ),
    );
  }
}
