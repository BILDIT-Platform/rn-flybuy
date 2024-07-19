#import "RnFlybuyCore.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>


@implementation RnFlybuyCore
RCT_EXPORT_MODULE()


// Don't compile this code when we build for the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeRnFlybuyCoreSpecJSI>(params);
}
#endif

RCT_EXTERN_METHOD(supportedEvents)

// Customer

RCT_EXTERN_METHOD(loginWithToken:(NSString *)token
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(login:(NSString *)email
                  withPassword:(NSString *)password
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(signUp:(NSString *)email
                  withPassword:(NSString *)password
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(logout:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getCurrentCustomer:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(createCustomer:(NSDictionary *)customer
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(updateCustomer:(NSDictionary *)customer
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

// Orders

RCT_EXTERN_METHOD(fetchOrders:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(createOrder:(int)siteId
                  withPartnerIdentifier:(NSString *)pid
                  withCustomerInfo:(NSDictionary *)customerInfo
                  withPickupWindow:(NSDictionary)pickupWindow
                  withOrderState:(NSString)orderState
                  withPickupType:(NSString)pickupType
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(createOrderWithPartnerIdentifier:(NSString *)sitePartnerIdentifier
                  withOrderPartnerIdentifier:(NSString *)pid
                  withCustomerInfo:(NSDictionary *)customerInfo
                  withPickupWindow:(NSDictionary)pickupWindow
                  withOrderState:(NSString)orderState
                  withPickupType:(NSString)pickupType
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(claimOrder:(NSString *)redeemCode
                  withCustomer:(NSDictionary *)customer
                  withPickupType:(NSString)pickupType
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(fetchOrderByRedemptionCode:(NSString *)redemCode
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(updateOrderState:(int)orderId
                  withState:(NSString *)state
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(updateOrderCustomerStateWithSpot:(int)orderId
                  withState:(NSString *)state
                  withSpot:(NSString *)state
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(updateOrderCustomerState:(int)orderId
                  withState:(NSString *)state
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(rateOrder:(int)orderId
                  withRating:(int *)rating
                  withComments:(NSString *)comments
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)
// Sites

RCT_EXTERN_METHOD(fetchAllSites:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(fetchSitesByQuery:(NSDictionary *)params
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(fetchSitesByRegion:(NSDictionary *)params
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(fetchSiteByPartnerIdentifier:(NSDictionary *)params
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(updatePushToken:(NSString *)token)

RCT_EXTERN_METHOD(handleRemoteNotification:(NSDictionary *)userInfo)

@end
