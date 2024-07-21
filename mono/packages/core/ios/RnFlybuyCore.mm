#import "RnFlybuyCore.h"
#import "RnFlybuyCore-Umbrella.h"

@implementation RnFlybuyCore
RCT_EXPORT_MODULE()


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

RCT_EXPORT_METHOD(loginWithToken:(NSString *)token
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)
{
    [[FlyBuyCore customer] loginWithTokenWithToken:token callback:^(FlyBuyCustomer *customer, NSError *error) {
        if (error == nil && customer != nil) {
            // Assuming you have a method `parserCustomer:` in this class that parses the customer
            resolve([self parserCustomer:customer]);
        } else {
            reject(error.localizedDescription, error.debugDescription, error);
        }
    }];
}

RCT_EXPORT_METHOD(signUp:(NSString *)email
                  withPassword:(NSString *)password
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    [[FlyBuyCore customer] signUpWithEmailAddress:email password:password callback:^(FlyBuyCustomer *customer, NSError *error) {
        if (error == nil && customer != nil) {
            // Assuming you have a method `parserCustomer:` in this class that parses the customer
            resolve([self parserCustomer:customer]);
        } else {
            reject(error.localizedDescription, error.debugDescription, error);
        }
    }];
}


RCT_EXPORT_METHOD(logout:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    [[FlyBuyCore customer] logout];
    resolve(@"ok");
}

RCT_EXPORT_METHOD(getCurrentCustomer:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    FlyBuyCustomer *customer = [[FlyBuyCore customer] current];
    if (customer == nil) {
        reject(@"not_login", @"current customer error", nil);
    } else {
        resolve([self parserCustomer:customer]);
    }
}

RCT_EXPORT_METHOD(createCustomer:(NSDictionary *)customer
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    FlyBuyCustomerInfo *customerInfo = [self decodeCustomerInfo:customer];
    [[FlyBuyCore customer] create:customerInfo termsOfService:YES ageVerification:YES callback:^(FlyBuyCustomer *customer, NSError *error) {
        if (error == nil && customer != nil) {
          resolve([self parserCustomer:customer]);
        } else {
          reject([error localizedDescription], [error debugDescription], error);
        }
    }];
      
}

RCT_EXPORT_METHOD(updateCustomer:(NSDictionary *)customer
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    FlyBuyCustomerInfo *customerInfo = [self decodeCustomerInfo:customer];
    [[FlyBuyCore customer] update:customerInfo callback:^(FlyBuyCustomer *customer, NSError *error) {
        if (error == nil && customer != nil) {
          resolve([self parserCustomer:customer]);
        } else {
          reject([error localizedDescription], [error debugDescription], error);
        }
    }];
}


// Parser
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

// Decoder
- (FlyBuyCustomerInfo *)decodeCustomerInfo:(NSDictionary<NSString *, NSString *> *)customer {
  NSString *name = customer[@"name"] ?: @" ";
  NSString *carType = customer[@"carType"] ?: @"";
  NSString *carColor = customer[@"carColor"] ?: @"";
  NSString *licensePlate = customer[@"licensePlate"] ?: @"";
  NSString *phone = customer[@"phone"] ?: @"";
  
    FlyBuyCustomerInfo *customerInfo = [[FlyBuyCustomerInfo alloc] initWithName:name
                                                          carType:carType
                                                         carColor:carColor
                                                    licensePlate:licensePlate
                                                           phone:phone];
  return customerInfo;
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
