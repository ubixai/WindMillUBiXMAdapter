//
//  AWMUBiXMConfigCustomAdapter.m
//  AWMUBiXMCustomAdapter
//
//  Created by guoqiang on 2024/12/20.
//

#import "AWMUBiXMConfigCustomAdapter.h"
#import <UbiXMediation/UbiXMediation.h>

@interface AWMUBiXMConfigCustomAdapter ()
@property (nonatomic, weak) id<AWMCustomConfigAdapterBridge> bridge;
@property (nonatomic, strong) UbiXMAdConfig *ubixmAdConfig;
@end

@implementation AWMUBiXMConfigCustomAdapter
- (instancetype)initWithBridge:(id<AWMCustomConfigAdapterBridge>)bridge {
    self = [super init];
    if (self) {
        _bridge = bridge;
    }
    return self;
}
- (AWMCustomAdapterVersion *)basedOnCustomAdapterVersion {
    return AWMCustomAdapterVersion1_0;
}
- (NSString *)adapterVersion {
    return @"1.0.0";
}
- (NSString *)networkSdkVersion {
    return [UbiXMediationSDK sdkVersion];
}
- (void)initializeAdapterWithConfiguration:(AWMSdkInitConfig *)initConfig {
    NSString *appId = [initConfig.extra objectForKey:@"appID"];
    
    
    [UbiXMediationSDK initializeWithAppId:appId adConfig:self.ubixmAdConfig];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.bridge initializeAdapterSuccess:self];
    });
}
- (void)didRequestAdPrivacyConfigUpdate:(NSDictionary *)config {
    WindMillPersonalizedAdvertisingState personalizedAdvertisingState = [WindMillAds getPersonalizedAdvertisingState];
    UbiXMConcealConfig *privacyConf = [[UbiXMConcealConfig alloc] init];
    if (personalizedAdvertisingState == WindMillPersonalizedAdvertisingOn) {
        privacyConf.isLimitPersonalAds = NO;
    }else if (personalizedAdvertisingState == WindMillPersonalizedAdvertisingOff) {
        privacyConf.isLimitPersonalAds = YES;
    }
    
    [privacyConf setIsOpenLog:YES];
    self.ubixmAdConfig.concealConfig = privacyConf;
}

- (UbiXMAdConfig *)ubixmAdConfig {
    if (!_ubixmAdConfig) {
        _ubixmAdConfig = [[UbiXMAdConfig alloc] init];
    }
    return _ubixmAdConfig;
}

@end
