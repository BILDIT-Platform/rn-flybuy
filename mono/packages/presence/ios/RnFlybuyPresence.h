
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNRnFlybuyPresenceSpec.h"

@interface RnFlybuyPresence : NSObject <NativeRnFlybuyPresenceSpec>
#else
#import <React/RCTBridgeModule.h>

@interface RnFlybuyPresence : NSObject <RCTBridgeModule>
#endif

@end
