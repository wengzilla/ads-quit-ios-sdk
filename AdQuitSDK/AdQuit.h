//
//  AdQuit.h
//  AdQuitSDK
//
//  Created by Tyler Lacroix on 6/24/21.
//

#import <Foundation/Foundation.h>
#import <IronSource/IronSource.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdQuit : NSObject

+ (void)setInterstitialDelegate:(id<ISInterstitialDelegate>)delegate;

+ (void)setRewardedVideoDelegate:(id<ISRewardedVideoDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
