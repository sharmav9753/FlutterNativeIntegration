import 'package:flutter/material.dart';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

final DynamicLibrary nativeInterface = Platform.isAndroid
    ? DynamicLibrary.open("libnative_add.so")
    : DynamicLibrary.process();

typedef example_foo = Int32 Function(Int32 bar, Int32 nativePort);
typedef ExampleFoo = int Function(int bar, int nativePort);

typedef example_callback = Int32 Function(Int32, Int32);

ExampleFoo nativeFoo = nativeInterface
    .lookup<NativeFunction<example_foo>>('native_add')
    .asFunction();

void handleCppRequests(dynamic message) {
  final cppRequest = CppRequest.fromCppMessage(message);
  print('Dart:   Got message: $cppRequest');
}

class CppRequest {
  final SendPort replyPort;
  final int pendingCall;
  final String method;
  final Uint8List data;

  factory CppRequest.fromCppMessage(List message) {
    return CppRequest._(message[0], message[1], message[2], message[3]);
  }

  CppRequest._(this.replyPort, this.pendingCall, this.method, this.data);

  String toString() => 'CppRequest(method: $method, ${data.length} bytes)';
}

void main() {
  runApp(MyApp());
  final interactiveCppRequests = ReceivePort()..listen(handleCppRequests);
  final int nativePort = interactiveCppRequests.sendPort.nativePort;
  print(nativePort);
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

int callback(Pointer<Void> ptr, int i) {
  print('Task with id $i removed');
  // _MyHomePageState().refreshData(i);
  return i + 1;
}

final interactiveCppRequests = ReceivePort()..listen(handleCppRequests);
final int nativePort = interactiveCppRequests.sendPort.nativePort;
// const except = -1;
// Pointer ptr = Pointer.fromFunction<example_callback>(callback, except);

class _MyHomePageState extends State<MyHomePage> {
  dynamic items = [];

  refreshData(int i) {
    for (var item in items) {
      if (item["id"] == i) {
        items.remove(item);
        break;
      }
    }
    setState(() {});
  }

  addTaskAction() {
    print("addTaskAction called");
    final int currentTimestamp =
        DateTime.now().millisecondsSinceEpoch.toUnsigned(16);
    items.add({"id": currentTimestamp, "status": "pending"});
    setState(() {});
    int x = nativeFoo(currentTimestamp, nativePort);
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

  // Widget listViewTile() {
  //   return ListView.builder(
  //       itemCount: items.length,
  //       shrinkWrap: true,
  //       itemBuilder: (context, index) {
  //         dynamic data = items[index];
  //         return Container(
  //           decoration: BoxDecoration(
  //             border: Border(bottom: BorderSide(color: Colors.grey[300])),
  //           ),
  //           child: ListTile(
  //             title: Text("${data['id']}"),
  //             subtitle: Text("${data['status']}"),
  //           ),
  //         );
  //       });
  // }
}
