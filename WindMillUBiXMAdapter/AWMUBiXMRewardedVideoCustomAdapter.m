//
//  AWMUBiXMRewardedVideoCustomAdapter.m
//  AWMUBiXMCustomAdapter
//
//  Created by guoqiang on 2024/12/20.
//

#import "AWMUBiXMRewardedVideoCustomAdapter.h"
#import <WindFoundation/WindFoundation.h>
#import <UbiXMediation/UbiXMediation.h>

@interface AWMUBiXMRewardedVideoCustomAdapter () <UbiXMediationRewardedVideoDelegate>

@property (nonatomic, weak) id<AWMCustomRewardedVideoAdapterBridge> bridge;
@property (nonatomic, strong) UbiXMediationRewardedVideo *rewardVideo;
@property (nonatomic, assign) BOOL isReady;

@end

@implementation AWMUBiXMRewardedVideoCustomAdapter
- (instancetype)initWithBridge:(id<AWMCustomRewardedVideoAdapterBridge>)bridge {
    self = [super init];
    if (self) {
        _bridge = bridge;
    }
    return self;
}
- (BOOL)mediatedAdStatus {
    if (self.isReady && self.rewardVideo.isAvaliable) {
        return YES;
    }
    return NO;
}
- (void)loadAdWithPlacementId:(NSString *)placementId parameter:(AWMParameter *)parameter {
    int templateType = [[parameter.customInfo objectForKey:@"templateType"] intValue];
    UbiXMediationRewardedVideo *reward = [[UbiXMediationRewardedVideo alloc] initWithSlotId:placementId];
    reward.delegate = self;
    
    self.rewardVideo = reward;
    [self.rewardVideo loadAd];
}
- (BOOL)showAdFromRootViewController:(UIViewController *)viewController parameter:(AWMParameter *)parameter {
    [self.rewardVideo showAdWithRootViewController:viewController];
    return YES;
}
- (void)didReceiveBidResult:(AWMMediaBidResult *)result {

}
- (void)destory {
    self.rewardVideo = nil;
}
- (void)dealloc {
    WindmillLogDebug(@"UBiXM", @"%s", __func__);
}

#pragma mark - UbiXMediationRewardedVideoDelegate
// 激励视频广告加载成功回调
- (void)mediationRewardedVideoDidLoad:(UbiXMediationRewardedVideo *)rewardedVideo {
    WindmillLogDebug(@"UBiXM", @"%s", __func__);
    NSString *price = [NSString stringWithFormat:@"%ld", rewardedVideo.eCPM];
    [self.bridge rewardedVideoAd:self didAdServerResponseWithExt:@{
        AWMMediaAdLoadingExtECPM: price
    }];
    self.isReady = YES;
    [self.bridge rewardedVideoAdDidLoad:self];
}

// 激励视频广告加载失败回调
- (void)mediationRewardedVideoDidFailToLoad:(UbiXMediationRewardedVideo *)rewardedVideo error:(NSError *)error {
    WindmillLogDebug(@"UBiXM", @"%s, err: %@", __func__, error.localizedDescription);
    self.isReady = NO;
    [self.bridge rewardedVideoAd:self didLoadFailWithError:error ext:nil];
}

// 激励视频广告展示成功回调
- (void)mediationRewardedVideoDidShow:(UbiXMediationRewardedVideo *)rewardedVideo {
    WindmillLogDebug(@"UBiXM", @"%s", __func__);
    [self.bridge rewardedVideoAdDidVisible:self];
}

// 激励视频广告播放开始回调
- (void)mediationRewardedVideoDidStarted:(UbiXMediationRewardedVideo *)rewardedVideo {
    WindmillLogDebug(@"UBiXM", @"%s", __func__);
}

// 激励视频广告展示失败回调
- (void)mediationRewardedVideoDidFailToShow:(UbiXMediationRewardedVideo *)rewardedVideo error:(NSError *)error {
    WindmillLogDebug(@"UBiXM", @"%s, err: %@", __func__, error.localizedDescription);
    [self.bridge rewardedVideoAdDidShowFailed:self error:error];
}

// 激励视频奖励回调
- (void)mediationRewardedVideoDidReward:(UbiXMediationRewardedVideo *)rewardedVideo {
    WindmillLogDebug(@"UBiXM", @"%s", __func__);
    WindMillRewardInfo *info = [[WindMillRewardInfo alloc] init];
    info.isCompeltedView = YES;
    [self.bridge rewardedVideoAd:self didRewardSuccessWithInfo:info];
}

// 激励视频点击广告回调
- (void)mediationRewardedVideoDidClick:(UbiXMediationRewardedVideo *)rewardedVideo {
    WindmillLogDebug(@"UBiXM", @"%s", __func__);
    [self.bridge rewardedVideoAdDidClick:self];
}

// 激励视频点击跳过视频回调
- (void)mediationRewardedVideoDidSkip:(UbiXMediationRewardedVideo *)rewardedVideo {
    WindmillLogDebug(@"UBiXM", @"%s", __func__);
    [self.bridge rewardedVideoAdDidClickSkip:self];
}

// 激励视频关闭广告回调
- (void)mediationRewardedVideoDidClosed:(UbiXMediationRewardedVideo *)rewardedVideo {
    WindmillLogDebug(@"UBiXM", @"%s", __func__);
    [self.bridge rewardedVideoAdDidClose:self];
}
// 视频播放完成回调
- (void)mediationRewardedVideoDidPlayFinish:(UbiXMediationRewardedVideo *)rewardedVideo {
    WindmillLogDebug(@"UBiXM", @"%s", __func__);
    [self.bridge rewardedVideoAd:self didPlayFinishWithError:nil];
}
@end
