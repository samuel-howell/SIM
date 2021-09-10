import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:howell_capstone/src/res/custom-colors.dart';

class SlidableWidget <T> extends StatelessWidget {
  final Widget child;

  const SlidableWidget({
    required this.child,
    required Key key,
  }) : super(key:key);
  @override
  Widget build(BuildContext context) => Slidable(
    actionPane: SlidableDrawerActionPane(),
    child: child,

    // left side
    actions: <Widget>[
      IconSlideAction(
        caption: 'Archive',
        color: CustomColors.cblue,
        icon: Icons.archive,
        onTap: () {},
      )
    ]
  );
}