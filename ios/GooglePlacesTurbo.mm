#import "GooglePlacesTurbo.h"
#if __has_include("GooglePlacesTurbo-Swift.h")
#import "GooglePlacesTurbo-Swift.h"
#else
#import "GooglePlacesTurbo/GooglePlacesTurbo-Swift.h"
#endif

@implementation GooglePlacesTurbo {
  GooglePlaceImpl *moduleIml;
}
- (instancetype)init {
  self = [super init];
  if (self) {
    moduleIml = [GooglePlaceImpl new];
  }
  return self;
}

- (void)openAutocompleteModal:(nonnull NSDictionary *)options
                      resolve:(nonnull RCTPromiseResolveBlock)resolve
                       reject:(nonnull RCTPromiseRejectBlock)reject {

  [moduleIml presentAutocompleteModalWithOptions:options
                                         resolve:resolve
                                          reject:reject];
}

- (void)initialize:(nonnull NSString *)key
         onSuccess:(nonnull RCTResponseSenderBlock)onSuccess
           onError:(nonnull RCTResponseSenderBlock)onError {
  [moduleIml initialize:key onSelect:onSuccess onError:onError];
}


- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeGooglePlacesTurboSpecJSI>(params);
}

+ (NSString *)moduleName
{
  return @"GooglePlacesTurbo";
}

@end
