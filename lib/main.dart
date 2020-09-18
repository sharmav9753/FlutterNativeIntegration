import 'package:flutter/material.dart';
import 'dart:async';
import 'package:async/async.dart';
import 'package:TaskManager/nativeCallback.dart';

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
  CancelableOperation<List<String>> methodBOperation;
  int completedTask;
  dynamic items = [];

  @override
  void initState() {
    super.initState();
    NativeCallbacksExample.doSetup();
  }

  Future<void> setTask(int taskID) async {
    startOperation = CancelableOperation.fromFuture(
        NativeCallbacksExample.startTaskMethod(taskID));
    startOperation.value.then((_completedTask) {
      print("task with id $_completedTask completed");
      setState(() {
        completedTask = _completedTask;
      });
    });
  }

  addTaskAction() {
    print("addTaskAction called");
    final int currentTimestamp =
        DateTime.now().millisecondsSinceEpoch.toUnsigned(16);
    items.add({"id": currentTimestamp, "status": "pending"});
    setState(() {});
    setTask(currentTimestamp);
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
      // body: listViewTile()
    );
  }

  Widget listViewTile() {
    return ListView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          dynamic data = items[index];
          return Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[300])),
            ),
            child: ListTile(
              title: Text("${data['id']}"),
              subtitle: Text("${data['status']}"),
            ),
          );
        });
  }
}
