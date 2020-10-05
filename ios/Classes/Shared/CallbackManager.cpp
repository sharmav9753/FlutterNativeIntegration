#include <stdlib.h>
#include <thread>
#include <iostream>
#include "CallbackManager.h"

using namespace std;

Dart_PostCObjectType dartPostCObject = NULL;

void RegisterDart_PostCObject(Dart_PostCObjectType _dartPostCObject) {
    dartPostCObject = _dartPostCObject;
}

void performTask(int32_t taskID, Dart_Port callbackPort) {
    cout<<taskID<<endl;
    this_thread::sleep_for(chrono::seconds(5));
    Dart_CObject dart_object;
    dart_object.type = Dart_CObject_kInt32;
    dart_object.value.as_int32 = taskID;

    bool result = dartPostCObject(callbackPort, &dart_object);
    if (!result) {
        printf("call from native to Dart failed, result was: %d\n", result);
    }
}

void start_task(Dart_Port callbackPort, int32_t taskID) {
    thread newThread(&performTask, taskID, callbackPort);
    newThread.detach();
}


