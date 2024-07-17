
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNRnFlybuyCoreSpec.h"

@interface RnFlybuyCore : NSObject <NativeRnFlybuyCoreSpec>
#else
#import <React/RCTBridgeModule.h>

@interface RnFlybuyCore : NSObject <RCTBridgeModule>
#endif

@end
