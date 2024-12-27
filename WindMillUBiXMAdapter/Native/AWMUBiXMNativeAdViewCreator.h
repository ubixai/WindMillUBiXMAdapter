//
//  AWMUBiXMNativeAdViewCreator.h
//  AWMUBiXMCustomAdapter
//
//  Created by guoqiang on 2024/12/23.
//

#import <Foundation/Foundation.h>
#import <WindMillSDK/WindMillSDK.h>

NS_ASSUME_NONNULL_BEGIN

@class UbiXMediationFeed;
@class UbiXMediationMediaView;
@class UbiXMedationFeedAdModel;

@interface AWMUBiXMNativeAdViewCreator : NSObject <AWMMediatedNativeAdViewCreator>

- (instancetype)initWithNativeAd:(UbiXMediationFeed *)nativeAd
                         adModel:(UbiXMedationFeedAdModel *)adModel
                    nativeAdView:(UbiXMediationMediaView *)mediaView;

@end

NS_ASSUME_NONNULL_END
