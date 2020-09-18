#import "./Shared/CallbackManager.h"
#import "NativeCallbacksExamplePlugin.h"

@implementation NativeCallbacksExamplePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [NativeCallbacksExamplePlugin registerWithRegistrar:registrar];
}
@end
