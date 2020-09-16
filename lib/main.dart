import 'package:flutter/material.dart';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

final DynamicLibrary nativeInterface = Platform.isAndroid
    ? DynamicLibrary.open("libnative_start_task.so")
    : DynamicLibrary.process();

typedef startTask = Int32 Function(Int32 taskID);
typedef StartTaskDef = int Function(int taskID);

typedef example_callback = Int32 Function(Int32, Int32);

StartTaskDef nativeStartTask = nativeInterface
    .lookup<NativeFunction<startTask>>('start_task')
    .asFunction();

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
  dynamic items = [];

  Future<int> processTask(int currentTimestamp) {
    int x = nativeStartTask(currentTimestamp);
    print(x);
    return Future.value(x);
  }

  addTaskAction() async {
    print("addTaskAction called");
    final int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    items.add({"id": currentTimestamp, "status": "pending"});
    processTask(currentTimestamp).then((value) => {
          setState(() {
            print("Future");
          })
        });
    return;
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
