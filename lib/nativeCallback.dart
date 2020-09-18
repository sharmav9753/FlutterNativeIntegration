import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:isolate/ports.dart';

final DynamicLibrary nativeLib = Platform.isAndroid
    ? DynamicLibrary.open('libnative_add.so')
    : DynamicLibrary.executable();

final nRegisterPostCObject = nativeLib.lookupFunction<
    Void Function(
        Pointer<NativeFunction<Int8 Function(Int64, Pointer<Dart_CObject>)>>
            functionPointer),
    void Function(
        Pointer<NativeFunction<Int8 Function(Int64, Pointer<Dart_CObject>)>>
            functionPointer)>('RegisterDart_PostCObject');

final nativeStartTask = nativeLib.lookupFunction<Void Function(Int64, Int64),
    void Function(int, int)>('start_task');

class NativeCallbacksExample {
  static void doSetup() {
    nRegisterPostCObject(NativeApi.postCObject);
  }

  static Future<int> startTaskMethod(int taskID) async {
    return singleResponseFuture(
        (port) => nativeStartTask(port.nativePort, taskID));
  }
}
