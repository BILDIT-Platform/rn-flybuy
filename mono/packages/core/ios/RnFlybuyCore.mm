#import "RnFlybuyCore.h"
#import "RnFlybuyCore-Umbrella.h"

@implementation RnFlybuyCore
RCT_EXPORT_MODULE()

// Example method
// See // https://reactnative.dev/docs/native-modules-ios
//RCT_EXPORT_METHOD(multiply:(double)a
//                  b:(double)b
//                  resolve:(RCTPromiseResolveBlock)resolve
//                  reject:(RCTPromiseRejectBlock)reject)
//{
//    NSNumber *result = @(a * b);
//
//    resolve(result);
//}


RCT_EXPORT_METHOD(login:(NSString *)email
                  withPassword:(NSString *)password
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    
    [[FlyBuyCore customer] loginWithEmailAddress:email password:password callback:^(FlyBuyCustomer *customer, NSError *error) {
        if (error == nil && customer != nil) {
            // Assuming you have a method `parserCustomer:` in this class that parses the customer
            resolve([self parserCustomer:customer]);
        } else {
            reject(error.localizedDescription, error.debugDescription, error);
        }
    }];
}

- (NSDictionary<NSString *, NSString *> *)parseCustomerInfo:(FlyBuyCustomerInfo *)info {
    return @{
        @"name": info.name ? info.name : [NSNull null],
        @"carType": info.carType ? info.carType : [NSNull null],
        @"carColor": info.carColor ? info.carColor : [NSNull null],
        @"licensePlate": info.licensePlate ? info.licensePlate : [NSNull null],
        @"phone": info.phone ? info.phone : [NSNull null]
    };
}

- (NSDictionary<NSString *, id> *)parserCustomer:(FlyBuyCustomer *)customer {
    return @{
        @"token": customer.token ? customer.token : [NSNull null],
        @"emailAddress": customer.emailAddress ? customer.emailAddress : [NSNull null],
        @"info": [self parseCustomerInfo:customer.info]
    };
}


// Don't compile this code when we build for the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeRnFlybuyCoreSpecJSI>(params);
}
#endif

@end
