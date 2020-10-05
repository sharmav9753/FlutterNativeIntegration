import 'package:TaskManager/AppConstants/TextStyleConstants.dart';
import 'package:TaskManager/AppConstants/appStrings.dart';
import 'package:TaskManager/Models/Task.dart';
import 'package:TaskManager/commonWidgets/ListItemRow.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:async/async.dart';
import 'package:TaskManager/nativeConnectivity.dart';
import 'package:TaskManager/AppConstants/Constants.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  CancelableOperation<int> startOperation;
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    TaskManager.doSetup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.homeScreenTitle),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTaskAction();
        },
        child: Icon(Icons.add),
      ),
      body: Stack(
        children: [listViewTile(), noTaskView()],
      ),
    );
  }

  refreshData(int taskID) {
    for (var task in tasks) {
      if (task.id == taskID) {
        tasks.remove(task);
        break;
      }
    }
    setState(() {});
  }

  Future<void> startTask(int taskID) async {
    startOperation =
        CancelableOperation.fromFuture(TaskManager.startTask(taskID));
    startOperation.value.then((_completedTaskID) {
      refreshData(_completedTaskID);
    });
  }

  addTaskAction() {
    final int taskID = DateTime.now().millisecondsSinceEpoch.toUnsigned(16);
    tasks.add(Task(id: taskID, status: TaskStatus.inProgress));
    setState(() {});
    startTask(taskID);
  }

  Widget listViewTile() {
    return ListView.builder(
        itemCount: tasks.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          dynamic data = tasks[index];
          return ListItemRow(
            taskTitle: Text('Task #${data.id}'),
            taskSubTitle: Text('${data.status}'),
          );
        });
  }

  Widget noTaskView() {
    return Visibility(
      visible: tasks.isEmpty,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Strings.oopsNoTask,
                style: textInBold,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(Strings.tap, style: normalText),
                  Icon(Icons.add_circle, color: Colors.blue),
                  Text(Strings.toAdd, style: normalText)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
