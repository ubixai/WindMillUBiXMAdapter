//
//  AWMUBiXMSplashCustomAdapter.m
//  AWMUBiXMCustomAdapter
//
//  Created by guoqiang on 2024/12/20.
//

#import "AWMUBiXMSplashCustomAdapter.h"
#import <WindFoundation/WindFoundation.h>
#import <UbiXMediation/UbiXMediation.h>

@interface AWMUBiXMSplashCustomAdapter ()<UbiXMediationSplashDelegate>
@property (nonatomic, weak) id<AWMCustomSplashAdapterBridge> bridge;
@property (nonatomic, strong) UbiXMediationSplash *splashAd;
@property (nonatomic, strong) AWMParameter *parameter;
@property (nonatomic, assign) BOOL isReady;
@end

@implementation AWMUBiXMSplashCustomAdapter
- (instancetype)initWithBridge:(id<AWMCustomSplashAdapterBridge>)bridge {
    self = [super init];
    if (self) {
        _bridge = bridge;
    }
    return self;
}
- (BOOL)mediatedAdStatus {
    return self.isReady;
}
- (void)loadAdWithPlacementId:(NSString *)placementId parameter:(AWMParameter *)parameter {
    self.parameter = parameter;
    UIViewController *viewController = [self.bridge viewControllerForPresentingModalView];
    UIView *bottomView = [parameter.extra objectForKey:AWMAdLoadingParamSPCustomBottomView];
    UIView *supView = viewController.navigationController ? viewController.navigationController.view : viewController.view;
    NSValue *sizeValue = [parameter.extra objectForKey:AWMAdLoadingParamSPExpectSize];
    CGSize adSize = [sizeValue CGSizeValue];
    if (adSize.width * adSize.height == 0) {
        CGFloat h = CGRectGetHeight(bottomView.frame);
        adSize = CGSizeMake(supView.frame.size.width, supView.frame.size.height - h);
    }
    NSInteger splashType = [[parameter.customInfo objectForKey:@"splashType"] intValue];
    int fetchDelay = [[parameter.extra objectForKey:AWMAdLoadingParamSPTolerateTimeout] intValue];
    self.splashAd = [[UbiXMediationSplash alloc] initWithSlotId:placementId];
    self.splashAd.delegate = self;
    self.splashAd.bottomView = bottomView;
    
    [self.splashAd loadAd];
}
- (void)showSplashAdInWindow:(UIWindow *)window parameter:(AWMParameter *)parameter {
    UIView *bottomView = [parameter.extra objectForKey:AWMAdLoadingParamSPCustomBottomView];
    UIViewController *viewController = [self.bridge viewControllerForPresentingModalView];
    UIView *supView = viewController.navigationController ? viewController.navigationController.view : viewController.view;
    CGRect supFrame = supView.bounds;
    CGRect adFrame = CGRectMake(0, 0, supFrame.size.width, supFrame.size.height - bottomView.bounds.size.height);
    if (bottomView) {
//        [supView addSubview:bottomView];
        bottomView.frame = CGRectMake(0,
                                      supFrame.size.height - CGRectGetHeight(bottomView.frame),
                                      CGRectGetWidth(bottomView.frame),
                                      CGRectGetHeight(bottomView.frame)
                                      );
    }
    self.splashAd.rootViewController = viewController;
    [self.splashAd showAd:window];
    
}
- (void)didReceiveBidResult:(AWMMediaBidResult *)result {
    
}
- (void)destory {
    [self removeSplashAdView];
}
- (void)removeSplashAdView {
    [self.splashAd destroyAd];
    self.splashAd = nil;
}
#pragma mark - UbiXMediationSplashDelegate
- (void)mediationSplashDidLoad:(UbiXMediationSplash *)splash {
    WindmillLogDebug(@"UBiXM", @"%@", NSStringFromSelector(_cmd));
    NSString *price = [NSString stringWithFormat:@"%ld", (long)splash.eCPM];
    [self.bridge splashAd:self didAdServerResponseWithExt:@{
        AWMMediaAdLoadingExtECPM: price
    }];
    
    self.isReady = YES;
    [self.bridge splashAdDidLoad:self];
}
- (void)mediationSplashDidFailToLoad:(UbiXMediationSplash *)splash error:(NSError *)error {
    WindmillLogDebug(@"UBiXM", @"%@", NSStringFromSelector(_cmd));
    self.isReady = NO;
    [self.bridge splashAd:self didLoadFailWithError:error ext:nil];
}
- (void)mediationSplashDidShow:(UbiXMediationSplash *)splash {
    WindmillLogDebug(@"UBiXM", @"%@", NSStringFromSelector(_cmd));
    self.isReady = NO;
    [self.bridge splashAdWillVisible:self];
}
- (void)mediationSplashDidFailToShow:(UbiXMediationSplash *)splash error:(NSError *)error {
    WindmillLogDebug(@"UBiXM", @"%@", NSStringFromSelector(_cmd));
}
- (void)mediationSplashDidClick:(UbiXMediationSplash *)splash {
    WindmillLogDebug(@"UBiXM", @"%@", NSStringFromSelector(_cmd));
    [self.bridge splashAdDidClick:self];
}

- (void)mediationSplashDidClosed:(UbiXMediationSplash *)splash skip:(BOOL)isSkip {
    WindmillLogDebug(@"UBiXM", @"%@ --- skip:%ld", NSStringFromSelector(_cmd), isSkip);
    if (isSkip) {
        [self.bridge splashAdDidClickSkip:self];
    }
    
    [self.bridge splashAdDidClose:self];
    [self removeSplashAdView];
}
- (void)mediationSplashDidFinishConversion:(UbiXMediationSplash *)splash {
    WindmillLogDebug(@"UBiXM", @"%@", NSStringFromSelector(_cmd));
}
- (void)dealloc {
    WindmillLogDebug(@"UBiXM", @"%s", __func__);
}


@end
