#include <stdio.h>
#include <stdint.h>
#include <thread>
#include <chrono>
// #include "dart_api.h"
// #include "dart_native_api.h"
#include "include/dart_api.h"
#include "include/dart_native_api.h"

using namespace std;

extern "C"
void *performTask(int32_t taskid, int32_t sendPort) {
   this_thread::sleep_for(chrono::seconds(5));
   Dart_CObject dart_object;
   dart_object.type = Dart_CObject_kInt64;
   dart_object.value.as_int64 = taskid;
   const bool result = Dart_PostCObject(sendPort, &dart_object);
   return nullptr;
}

extern "C"
int32_t native_add(int32_t taskid, int32_t sendPort) {
   //    this_thread::sleep_for(chrono::seconds(5));
   thread newThread(&performTask, taskid, sendPort);
   newThread.detach();
   return int32_t(0);
}
