import 'package:flutter/material.dart';

class AppointmentWidgetAdmin extends StatelessWidget {
  const AppointmentWidgetAdmin({
    Key key,
  }) : super(key: key);

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
              'My Appointments',
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
