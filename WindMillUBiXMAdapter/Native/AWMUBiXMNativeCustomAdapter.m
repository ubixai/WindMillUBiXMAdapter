//
//  AWMUBiXMNativeCustomAdapter.m
//  AWMUBiXMCustomAdapter
//
//  Created by guoqiang on 2024/12/20.
//

#import "AWMUBiXMNativeCustomAdapter.h"
#import <WindFoundation/WindFoundation.h>
#import <UbiXMediation/UbiXMediation.h>
#import "AWMUBiXMNativeAdViewCreator.h"
#import "AWMUBiXMNativeAdData.h"

@interface AWMUBiXMNativeCustomAdapter () <UbiXMediationFeedDelegate>
@property (nonatomic, weak) id<AWMCustomNativeAdapterBridge> bridge;
@property (nonatomic, strong) UbiXMediationFeed *nativeAd;
@property (nonatomic, assign) BOOL isReady;
@end

@implementation AWMUBiXMNativeCustomAdapter
- (instancetype)initWithBridge:(id<AWMCustomNativeAdapterBridge>)bridge {
    self = [super init];
    if (self) {
        _bridge = bridge;
    }
    return self;
}

- (BOOL)mediatedAdStatus {
    return self.isReady;
}

- (void)loadAdWithPlacementId:(NSString *)placementId adSize:(CGSize)size parameter:(AWMParameter *)parameter {
    UbiXMediationFeed *nativeAd = [[UbiXMediationFeed alloc] initWithSlotId:placementId];
    nativeAd.delegate = self;
    self.nativeAd = nativeAd;
    
    int templateType = [[parameter.customInfo objectForKey:@"templateType"] intValue];
    if (templateType == 1) {
        self.nativeAd.renderType = UbiXMFeedRenderTypeSelfRender;
    }else {
        self.nativeAd.renderType = UbiXMFeedRenderTypeTemplate;
    }
    [self.nativeAd loadAdWithAdSize:size];
}
- (void)didReceiveBidResult:(AWMMediaBidResult *)result {
    
}

- (void)destory {
    [self.nativeAd destroyAd];
}
- (void)dealloc {
    WindmillLogDebug(@"UBiXM", @"%s", __func__);
}

#pragma mark - UbiXMediationFeedDelegate
// 原生广告加载成功
- (void)mediationFeedDidLoad:(NSArray<UbiXMedationFeedAdModel *> *)feedAds {
    
    self.isReady = YES;
    
    
    UbiXMedationFeedAdModel *feedAd = feedAds.firstObject;
    NSString *platform = feedAd.extraParams[@"platform_name"];
    NSString *adnSlotId = feedAd.extraParams[@"platform_slot_id"];
    WindmillLogDebug(@"UBiXM", @"%s, adn: %@, adnSlotId: %@", __func__, platform, adnSlotId);
    NSString *price = [NSString stringWithFormat:@"%d", self.nativeAd.eCPM];
    [self.bridge nativeAd:self didAdServerResponseWithExt:@{
        AWMMediaAdLoadingExtECPM: price
    }];
    NSMutableArray *adArray = [[NSMutableArray alloc] init];
    if (feedAd.isExpressAd) {
        AWMMediatedNativeAd *mNativeAd = [[AWMMediatedNativeAd alloc] init];
        mNativeAd.originMediatedNativeAd = feedAd.feedAdView;
        mNativeAd.viewCreator = [[AWMUBiXMNativeAdViewCreator alloc] initWithNativeAd:self.nativeAd
                                                                              adModel:feedAd
                                                                         nativeAdView:nil];
        mNativeAd.view = feedAd.feedAdView;
        [adArray addObject:mNativeAd];
        [self.bridge nativeAd:self didLoadWithNativeAds:adArray];
        
        [self.bridge nativeAd:self renderSuccessWithExpressView:feedAd.feedAdView];
        
    } else {
        // 自渲染
        AWMMediatedNativeAd *mNativeAd = [[AWMMediatedNativeAd alloc] init];
        mNativeAd.data = [[AWMUBiXMNativeAdData alloc] initWithAd:feedAd];
        mNativeAd.originMediatedNativeAd = feedAd;
        UbiXMediationMediaView *adView = [[UbiXMediationMediaView alloc] init];

        mNativeAd.viewCreator = [[AWMUBiXMNativeAdViewCreator alloc] initWithNativeAd:self.nativeAd
                                                                              adModel:feedAd
                                                                         nativeAdView:adView];
        [adArray addObject:mNativeAd];
        
        [self.bridge nativeAd:self didLoadWithNativeAds:adArray];
    }
    
}

// 原生广告加载失败回调
- (void)mediationFeedDidFailToLoad:(UbiXMediationFeed *)native error:(NSError *)error {
    WindmillLogDebug(@"UBiXM", @"%s, err: %@", __func__, error);
    
    [self.bridge nativeAd:self didLoadFailWithError:error];
}

// 信息流广告展示成功
- (void)mediationFeedAdViewDidShow:(UbiXMedationFeedAdModel *)feedAdModel {
    WindmillLogDebug(@"UBiXM", @"%s", __func__);
    id nativeAd = feedAdModel.isExpressAd ? feedAdModel.feedAdView : feedAdModel;
    
    [self.bridge nativeAd:self didVisibleWithMediatedNativeAd:nativeAd];
}

// 信息流广告点击回调
- (void)mediationFeedAdViewDidClick:(UbiXMedationFeedAdModel *)feedAdModel {
    WindmillLogDebug(@"UBiXM", @"%s", __func__);
    id nativeAd = feedAdModel.isExpressAd ? feedAdModel.feedAdView : feedAdModel;
    [self.bridge nativeAd:self didClickWithMediatedNativeAd:nativeAd];
}

// 信息流广告关闭回调
- (void)mediationFeedAdViewDidClosed:(UbiXMedationFeedAdModel *)feedAdModel {
    WindmillLogDebug(@"UBiXM", @"%s", __func__);
    id nativeAd = feedAdModel.isExpressAd ? feedAdModel.feedAdView : feedAdModel;
    [self.bridge nativeAd:self didClose:nativeAd closeReasons:@[@"关闭"]];
}

// 信息流广告开始播放回调
- (void)mediationFeedAdViewDidStartPlay:(UbiXMedationFeedAdModel *)feedAdModel {
    WindmillLogDebug(@"UBiXM", @"%s", __func__);
    id nativeAd = feedAdModel.isExpressAd ? feedAdModel.feedAdView : feedAdModel;
    [self.bridge nativeAd:self videoStateDidChangedWithState:WindMillMediaPlayerStatusStarted andNativeAd:nativeAd];
}

// 信息流广告结束播放回调
- (void)mediationFeedAdViewDidFinishPlay:(UbiXMedationFeedAdModel *)feedAdModel {
    WindmillLogDebug(@"UBiXM", @"%s", __func__);
    id nativeAd = feedAdModel.isExpressAd ? feedAdModel.feedAdView : feedAdModel;
    [self.bridge nativeAd:self videoStateDidChangedWithState:WindMillMediaPlayerStatusStoped andNativeAd:nativeAd];
}

// 信息流广告播放出错
- (void)mediationFeedAdView:(UbiXMedationFeedAdModel *)feedAdModel didPlayError:(NSError *)error {
    WindmillLogDebug(@"UBiXM", @"%s, err: %@", __func__, error);
    id nativeAd = feedAdModel.isExpressAd ? feedAdModel.feedAdView : feedAdModel;
    [self.bridge nativeAd:self videoStateDidChangedWithState:WindMillMediaPlayerStatusError andNativeAd:nativeAd];
}

// 信息流广告消失
- (void)mediationFeedAdViewDidDisMiss:(UbiXMedationFeedAdModel *)feedAdModel {
    WindmillLogDebug(@"UBiXM", @"%s", __func__);
    id nativeAd = feedAdModel.isExpressAd ? feedAdModel.feedAdView : feedAdModel;
    [self.bridge nativeAd:self didDismissFullScreenModalWithMediatedNativeAd:nativeAd];
}



@end
