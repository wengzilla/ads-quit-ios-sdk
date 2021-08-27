//
//  AdQuitManager.h
//  AdQuitSDK
//
//  Created by Tyler Lacroix on 6/26/21.
//

#import <Foundation/Foundation.h>
#import <IronSource/IronSource.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdQuitManager : NSObject<ISInterstitialDelegate, ISRewardedVideoDelegate, ISImpressionDataDelegate> {
    id<ISInterstitialDelegate> interstitial_delegate;
    id<ISRewardedVideoDelegate> rewarded_video_delegate;
}

@property (nonatomic, retain) id<ISInterstitialDelegate> interstitial_delegate;
@property (nonatomic, retain) id<ISRewardedVideoDelegate> rewarded_video_delegate;

+ (id)sharedManager;
- (void)setInterstitialDelegate:(id<ISInterstitialDelegate>)delegate;
- (void)setRewardedVideoDelegate:(id<ISRewardedVideoDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
