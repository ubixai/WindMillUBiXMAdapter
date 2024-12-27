//
//  AWMUBiXMNativeAdViewCreator.m
//  AWMUBiXMCustomAdapter
//
//  Created by guoqiang on 2024/12/23.
//

#import "AWMUBiXMNativeAdViewCreator.h"
#import <WindFoundation/WindFoundation.h>
#import <UbiXMediation/UbiXMediation.h>

@interface AWMUBiXMNativeAdViewCreator ()

@property (nonatomic, strong) UbiXMediationMediaView *nativeMediaView;
@property (nonatomic, strong) UIView *expressAdView;
@property (nonatomic, weak) UbiXMediationFeed *nativeAd;
@property (nonatomic, strong) UbiXMedationFeedAdModel *nativeAdModel;
@property (nonatomic, strong) UbiXMedationFeedAdModel *expressAdModel;
@property (nonatomic, strong) UIImage *image;

@end

@implementation AWMUBiXMNativeAdViewCreator

@synthesize adLogoView = _adLogoView;
@synthesize dislikeBtn = _dislikeBtn;
@synthesize imageView = _imageView;
@synthesize imageViewArray = _imageViewArray;
@synthesize mediaView = _mediaView;


- (instancetype)initWithNativeAd:(UbiXMediationFeed *)nativeAd
                         adModel:(UbiXMedationFeedAdModel *)adModel
                          nativeAdView:(UbiXMediationMediaView *)mediaView {
    self = [super init];
    if (self) {
        _nativeAd = nativeAd;
        if (adModel.isExpressAd) {
            _expressAdModel = adModel;
            _expressAdView = adModel.feedAdView;
        } else {
            _nativeMediaView = mediaView;
            _nativeAdModel = adModel;
        }
    }
    return self;
}

- (void)setRootViewController:(UIViewController *)viewController {
    self.nativeAd.rootViewController = viewController;
}
- (void)registerContainer:(UIView *)containerView withClickableViews:(NSArray<UIView *> *)clickableViews {
    [self.nativeAdModel setContainer:containerView clickableViews:clickableViews closableViews:@[]];
}
- (void)refreshData {
    if (self.expressAdView) {
//        [self.expressAdView render];
    }else if (self.nativeMediaView) {
        [self.nativeMediaView bindViewWithAdData:self.nativeAdModel.feedAdMaterialData];
    }
}
- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _image = placeholderImage;
}
#pragma mark - Getter
- (UIView *)adLogoView {
    return nil;
}
- (UIButton *)dislikeBtn {
    if (!_dislikeBtn) {
        _dislikeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_dislikeBtn setTitle:@"X" forState:UIControlStateNormal];
    }
    return _dislikeBtn;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        NSArray *imageAry = self.nativeAdModel.feedAdMaterialData.imageUrls;
        _imageView = [[UIImageView alloc] init];
        if(imageAry.count > 0) {
            NSString *imageUrlStr = imageAry.firstObject;
            NSURL *imgURL = [NSURL URLWithString:imageUrlStr];
            [_imageView sm_setImageWithURL:imgURL placeholderImage:self.image];
        }
    }
    return _imageView;
}
- (NSArray<UIImageView *> *)imageViewArray {
    if (self.nativeAdModel.feedAdMaterialData.isVideoAd) return nil;
    if (!_imageViewArray) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [self.nativeAdModel.feedAdMaterialData.imageUrls enumerateObjectsUsingBlock:^(NSString *imgUrlStr, NSUInteger idx, BOOL *stop) {
            UIImageView *imageView = [[UIImageView alloc] init];
            NSURL *imgURL = [NSURL URLWithString:imgUrlStr];
            [imageView sm_setImageWithURL:imgURL placeholderImage:self.image];
            [arr addObject:imageView];
        }];
        _imageViewArray = arr;
    }
    return _imageViewArray;
}
- (UIView *)mediaView {
    return self.nativeMediaView;
}
- (void)dealloc {
    WindmillLogDebug(@"UBiXM", @"%s", __func__);
}

@end
