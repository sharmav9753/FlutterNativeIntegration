## Overview

This is a single screen cross platform application to test the interoperability between Flutter and Native (C/C++) code. This also verifiies the concurrent working of multiple threads so that we can perform heavy task on Native side without blocking the UI.

This app contains:
- An empty list view when no task is being performed
- A "Add task" button which triggers a task to be performed in background
- A list view which shows the tasks which are currently in progress

## Task Requirements

-  Flutter app calls a c/c++ function to create and start a task in separate thread (5 seconds sleep).
-  Once a new task created, it will be added to the pending list and will be visible in task list.
-  Flutter app will listen for the completion handler, where we will get task details which we need to remove .
-  C/C++ calls a callback function which notifies completion handler in flutter to remove the particular task from list.
-  As the task will be removed from the pending list, the task list will be updated automatically.

## Structure

```
├── TaskManager
│ ├── ios
│ │ ├── Classes
│ │ │ ├── Shared
│ │ │ │ ├── CallbackManager.cpp
│ │ │ │ └── CallbackManager.h
│ │ │ ├── TaskCompletionCallback.h
│ │ │ └── TaskCompletionCallback.m
│ │ └── podfile
│ ├── lib
│ │ ├── Models
│ │ │ └── Task.dart
│ │ ├── CommonWidgets
│ │ │ └── ListItemRow.dart
│ │ ├── UI
│ │ │ └── HomePage.dart
│ │ ├── AppConstants
│ │ │ ├── AppStrings.dart
│ │ │ ├── Constants.dart
│ │ │ └── TextStyleConstants.dart
│ │ ├── main.dart
│ │ └── nativeConnectivity.dart
│ ├── android
│ └── Tests
├── pubspec.yaml
└── README.md
```

#### Structure details

The app is structured to make sure that the business logic (Native C/C++ code) remains detached from UI code and hence is unit testable.

###### Classes

This directory resides inside "ios" directory contains the Native code in the form of C/C++ and header files which contains the required business logic (create thread and make it sleep for 5 seconds) and provide callback to flutter.

###### Models

This directory is responsible for keeping all the `Models` and related `Enums` for the app

###### CommonWidgets

This directory is responsible for keeping reusable view components to make application more scalable.

###### UI

This directory contains different screens for the app, if available

###### AppConstants

This directory is responsible for keeping all the constants and hardcoded values required in application.

## Notes

- `nativeConnectivity.dart` is the file which holds the code for interoperability of Flutter and Native (C/C++). 
- `Dart FFI` - https://api.flutter.dev/flutter/dart-ffi/dart-ffi-library.html, is used or interoperability
- Project should built using `Flutter dev channel`

## Build Info

- iOS 13.0+
- Xcode 11.6
- Swift 5
- Flutter 1.22.0-12.0.pre • channel dev
- Dart 2.10.0

## Project Setup

> Install flutter dependencies

- Go to the project's root directory on the mac's terminal

If you are not on dev channel:
- Run `flutter channel dev`
- Run `flutter upgrade` 

Then
- Run `flutter pub get`

On iOS
> CocoaPods is one of our dependency manager. If it is not installed on the machine please visit: https://guides.cocoapods.org/using/getting-started.html

- Go to the "ios" directory in project's root directory on the mac's terminal
- Run `pod install`
- Make sure to open `cheq.xcworkspace` and then run the app

## Project Dependencies

> Flutter
- [Isolate] isolate: "^2.0.3" - https://pub.flutter-io.cn/packages/isolate/install
