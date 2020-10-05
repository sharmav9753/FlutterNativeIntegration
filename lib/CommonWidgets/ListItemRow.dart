import 'package:flutter/material.dart';

class ListItemRow extends StatelessWidget {
  Widget taskTitle;
  Widget taskSubTitle;
  Widget taskLeading;

  ListItemRow({this.taskTitle, this.taskSubTitle, this.taskLeading});

  @override
  Widget build(BuildContext context) {
    return listViewTile();
  }

  Widget listViewTile() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300])),
      ),
      child: ListTile(
        title: taskTitle,
        subtitle: taskSubTitle,
        leading: taskLeading,
      ),
    );
  }
}
