#include <thread>
#include <chrono>
#include <iostream>

using namespace std;

extern "C" __attribute__((visibility("default"))) __attribute__((used))
void perform_task() {
    this_thread::sleep_for(chrono::seconds(5));
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int32_t start_task(int32_t taskID) {
    cout<<"Hello"<<endl;
    thread newThread(&perform_task);
    newThread.detach();
    return taskID;
}
