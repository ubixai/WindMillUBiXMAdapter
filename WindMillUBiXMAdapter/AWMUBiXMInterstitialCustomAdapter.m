//
//  AWMUBiXMInterstitialCustomAdapter.m
//  AWMUBiXMCustomAdapter
//
//  Created by guoqiang on 2024/12/20.
//

#import "AWMUBiXMInterstitialCustomAdapter.h"
#import <WindFoundation/WindFoundation.h>
#import <UbiXMediation/UbiXMediation.h>

@interface AWMUBiXMInterstitialCustomAdapter() <UbiXMediationInterstitialDelegate>
@property (nonatomic, weak) id<AWMCustomInterstitialAdapterBridge> bridge;
@property (nonatomic, strong) UbiXMediationInterstitial *interstitialAd;
@property (nonatomic, assign) BOOL isReady;
@end

@implementation AWMUBiXMInterstitialCustomAdapter
- (instancetype)initWithBridge:(id<AWMCustomInterstitialAdapterBridge>)bridge {
    self = [super init];
    if (self) {
        _bridge = bridge;
    }
    return self;
}
- (void)loadAdWithPlacementId:(NSString *)placementId parameter:(AWMParameter *)parameter {
    UbiXMediationInterstitial *interstitial = [[UbiXMediationInterstitial alloc] initWithSlotId:placementId];
    interstitial.delegate = self;
    self.interstitialAd = interstitial;
    
    [self.interstitialAd loadAd];
}
- (BOOL)mediatedAdStatus {
    if (self.isReady && self.interstitialAd.isReady) {
        return YES;
    }
    return NO;
}
- (BOOL)showAdFromRootViewController:(UIViewController *)viewController parameter:(AWMParameter *)parameter {
    [self.interstitialAd showAdFromRootViewController:viewController];
    return YES;
}
- (void)didReceiveBidResult:(AWMMediaBidResult *)result {
    
}

- (void)destory {
    self.interstitialAd = nil;
}
- (void)dealloc {
    WindmillLogDebug(@"UBiXM", @"%s", __func__);
}

#pragma mark -UbiXMediationInterstitialDelegate

// 插屏广告模板加载成功
- (void)mediationInterstitialDidLoad:(UbiXMediationInterstitial *)interstitial {
    WindmillLogDebug(@"UBiXM", @"%@", NSStringFromSelector(_cmd));
    NSString *price = [NSString stringWithFormat:@"%d", interstitial.eCPM];
    [self.bridge interstitialAd:self didAdServerResponseWithExt:@{
        AWMMediaAdLoadingExtECPM: price
    }];
    self.isReady = YES;
    [self.bridge interstitialAdDidLoad:self];
}

// 插屏加载失败回调
- (void)mediationInterstitialDidFailToLoad:(UbiXMediationInterstitial *)interstitial error:(NSError *)error {
    WindmillLogDebug(@"UBiXM", @"%@", NSStringFromSelector(_cmd));
    [self.bridge interstitialAd:self didLoadFailWithError:error ext:nil];
}

// 插屏广告展示成功
- (void)mediationInterstitialDidShow:(UbiXMediationInterstitial *)interstitial {
    WindmillLogDebug(@"UBiXM", @"%@", NSStringFromSelector(_cmd));
    [self.bridge interstitialAdDidVisible:self];
}

// 插屏广告展示失败
- (void)mediationInterstitialDidFailToShow:(UbiXMediationInterstitial *)interstitial error:(NSError *)error {
    WindmillLogDebug(@"UBiXM", @"%@", NSStringFromSelector(_cmd));
    [self.bridge interstitialAdDidShowFailed:self error:error];
}

// 插屏点击广告回调
- (void)mediationInterstitialDidClick:(UbiXMediationInterstitial *)interstitial {
    WindmillLogDebug(@"UBiXM", @"%@", NSStringFromSelector(_cmd));
    [self.bridge interstitialAdDidClick:self];
}

// 插屏关闭广告回调
- (void)mediationInterstitialDidClosed:(UbiXMediationInterstitial *)interstitial {
    WindmillLogDebug(@"UBiXM", @"%@", NSStringFromSelector(_cmd));
    [self.bridge interstitialAdDidClose:self];
}



@end
