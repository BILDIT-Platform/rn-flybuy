#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>
#import "RNCConfig.h"

// TODO: add this to documentation flybuy core
#import <CoreLocation/CoreLocation.h>
#import <FlyBuy/FlyBuy-Swift.h>
// End

// TODO: add this to documentation flybuy pickup
#import <FlyBuyPickup/FlyBuyPickup-Swift.h>


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.moduleName = @"example";
  // You can add your custom initial props in the dictionary below.
  // They will be passed down to the ViewController used by React Native.
  self.initialProps = @{};
  
  // Load environment variables & initialize FlyBuy
  NSString *appToken = [RNCConfig envFor:@"IOS_APP_TOKEN"];
  // FlyBuy core configuration, always place this above all other FlyBuy configure
  FlyBuyConfigOptionsBuilder *builder = [FlyBuyConfigOptions BuilderWithToken:appToken];
  FlyBuyConfigOptions *configOptions = [builder build];
  [FlyBuyCore configureWithOptions:configOptions];
  
  // FlyBuy Pickup native configuration
  [[FlyBuyPickupManager shared] configure];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
  return [self bundleURL];
}

- (NSURL *)bundleURL
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

@end
