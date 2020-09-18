#import "./Shared/CallbackManager.h"
#import "TaskCompletionCallback.h"

@implementation TaskCompletionCallback
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [TaskCompletionCallback registerWithRegistrar:registrar];
}
@end
