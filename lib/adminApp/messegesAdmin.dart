import 'package:flutter/material.dart';

class MessegesWidgetAdmin extends StatefulWidget {
  const MessegesWidgetAdmin({
    Key key,
  }) : super(key: key);

  @override
  _MessegesWidgetAdminState createState() => _MessegesWidgetAdminState();
}

class _MessegesWidgetAdminState extends State<MessegesWidgetAdmin> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      color: Colors.grey[200],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'My Messeges',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          /* ListView.builder(
              itemBuilder: (context, index) {},
            ), */
        ],
      ),
    );
  }
}
