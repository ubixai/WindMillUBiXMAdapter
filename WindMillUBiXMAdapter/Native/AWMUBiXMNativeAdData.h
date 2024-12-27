//
//  AWMUBiXMNativeAdData.h
//  AWMUBiXMCustomAdapter
//
//  Created by guoqiang on 2024/12/23.
//

#import <Foundation/Foundation.h>
#import <WindMillSDK/WindMillSDK.h>

NS_ASSUME_NONNULL_BEGIN

@class UbiXMedationFeedAdModel;

@interface AWMUBiXMNativeAdData : NSObject <AWMMediatedNativeAdData>

- (instancetype)initWithAd:(UbiXMedationFeedAdModel *)ad;

@end

NS_ASSUME_NONNULL_END
