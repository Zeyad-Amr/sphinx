import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Function press;
  final Widget child;
  final String text;
  final double widthRatioSize;
  final double paddingRatioSize;
  final Color textColor;
  final Color buttonColor;
  final double fontS;
  const RoundedButton({
    Key key,
    @required this.press,
    @required this.text,
    @required this.textColor,
    @required this.buttonColor,
    @required this.widthRatioSize,
    this.child,
    this.fontS,
    @required this.paddingRatioSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context)
        .size; // This size provide us total height and width of our screen

    return Row(
      children: [
        Container(
          width: size.width * widthRatioSize,
          child: ClipRRect(
            child: FlatButton(
              padding: EdgeInsets.all(size.height * paddingRatioSize),
              onPressed: press,
              child: Text(
                '$text',
                style: TextStyle(color: textColor, fontSize: fontS),
              ),
              color: buttonColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(29),
                  side: BorderSide(color: Colors.grey)),
            ),
          ),
        ),
      ],
    );
  }
}
