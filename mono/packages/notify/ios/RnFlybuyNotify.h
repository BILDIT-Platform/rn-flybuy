
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNRnFlybuyNotifySpec.h"

@interface RnFlybuyNotify : NSObject <NativeRnFlybuyNotifySpec>
#else
#import <React/RCTBridgeModule.h>

@interface RnFlybuyNotify : NSObject <RCTBridgeModule>
#endif

@end
