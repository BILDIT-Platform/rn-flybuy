
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNRnFlybuyPickupSpec.h"

@interface RnFlybuyPickup : NSObject <NativeRnFlybuyPickupSpec>
#else
#import <React/RCTBridgeModule.h>

@interface RnFlybuyPickup : NSObject <RCTBridgeModule>
#endif

@end
