import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  CustomRaisedButton({
    Key key,
    this.onPressed,
    this.child,
    this.color,
    this.borderRadius: 2.0,
    this.height: 50.0,
  })  : assert(borderRadius != null),
        super(key: key);

  final VoidCallback onPressed;
  final Color color;
  final Widget child;
  final double borderRadius;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
        child: child,
        color: color,
        disabledColor: color,
      ),
    );
  }
}
