//
//  AWMUBiXMNativeAdData.m
//  AWMUBiXMCustomAdapter
//
//  Created by guoqiang on 2024/12/23.
//

#import "AWMUBiXMNativeAdData.h"
#import <WindFoundation/WindFoundation.h>
#import <UbiXMediation/UbiXMediation.h>

@interface AWMUBiXMNativeAdData ()

@property (nonatomic, weak) UbiXMedationFeedAdModel *ad;

@end

@implementation AWMUBiXMNativeAdData

@synthesize callToAction = _callToAction;
@synthesize adMode = _adMode;

- (instancetype)initWithAd:(UbiXMedationFeedAdModel *)ad {
    self = [super init];
    if (self) {
        _ad = ad;
    }
    return self;
}
- (NSString *)title {
    return self.ad.feedAdMaterialData.title;
}
- (NSString *)desc {
    return self.ad.feedAdMaterialData.body;
}
- (NSString *)iconUrl {
    return self.ad.feedAdMaterialData.iconUrl;
}
- (NSString *)callToAction {
    if (!_callToAction) {
        NSString *cta = self.ad.feedAdMaterialData.callToAction;
        if ([cta isKindOfClass:[NSString class]] && cta.length) {
            _callToAction = cta;
        } else {
            _callToAction = @"查看详情";
        }
    }
    return _callToAction;
}
- (double)rating {
    return self.ad.feedAdMaterialData.rating;
}

- (NSArray *)imageUrlList {
    return self.ad.feedAdMaterialData.imageUrls;
}

- (NSString *)videoUrl {
    return self.ad.feedAdMaterialData.videoUrl;
}
- (AWMMediatedNativeAdMode)adMode {
    if (_adMode > 0) return _adMode;
    BOOL isVideo = self.ad.feedAdMaterialData.isVideoAd;
    if (isVideo) {
        _adMode = AWMMediatedNativeAdModeVideo;
    } else {
        _adMode = AWMMediatedNativeAdModeLargeImage;
    }
    return _adMode;
}
- (WindMillAdn)networkId {
    return WindMillAdnCustom;
}

- (AWMNativeAdSlotAdType)adType {
    return AWMNativeAdSlotAdTypeFeed;
}
- (void)dealloc {
    WindmillLogDebug(@"UBiXM", @"%s", __func__);
}

@end
