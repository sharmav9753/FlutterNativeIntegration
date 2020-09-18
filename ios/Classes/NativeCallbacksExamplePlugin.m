#import "./Shared/CallbackManager.h"
#import "NativeCallbacksExamplePlugin.h"
// #if __has_include(<native_callbacks_example/native_callbacks_example-Swift.h>)
// #import <native_callbacks_example/native_callbacks_example-Swift.h>
// #else
// #import "native_callbacks_example-Swift.h"
// #endif

@implementation NativeCallbacksExamplePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [NativeCallbacksExamplePlugin registerWithRegistrar:registrar];
}
@end
