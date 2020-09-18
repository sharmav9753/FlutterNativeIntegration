import 'package:flutter/material.dart';
import 'dart:async';
import 'package:async/async.dart';
import 'package:TaskManager/nativeCallback.dart';
import 'package:TaskManager/Constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Task Manager'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CancelableOperation<int> startOperation;
  int taskCounter = 0;
  dynamic tasks = [];

  @override
  void initState() {
    super.initState();
    TaskManager.doSetup();
  }

  refreshData(int taskID) {
    for (var task in tasks) {
      if (task["id"] == taskID) {
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
    tasks.add({"id": taskID, "status": "${TaskStatus.inProgress}"});
    setState(() {});
    startTask(taskID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addTaskAction();
          },
          child: Icon(Icons.add),
        ),
        body: listViewTile());
  }

  Widget listViewTile() {
    return ListView.builder(
        itemCount: tasks.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          dynamic data = tasks[index];
          return Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[300])),
            ),
            child: ListTile(
              title: Text("Task #${data['id']}"),
              subtitle: Text("${data['status']}"),
            ),
          );
        });
  }
}
