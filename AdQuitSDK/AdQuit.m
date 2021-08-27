//
//  AdQuit.m
//  AdQuitSDK
//
//  Created by Tyler Lacroix on 6/24/21.
//

#import "AdQuit.h"
#import "AdQuitManager.h"

@implementation AdQuit

+ (void)setInterstitialDelegate:(id<ISInterstitialDelegate>)delegate {
    [[AdQuitManager sharedManager] setInterstitialDelegate:delegate];
}

+ (void)setRewardedVideoDelegate:(id<ISRewardedVideoDelegate>)delegate {
    [[AdQuitManager sharedManager] setRewardedVideoDelegate:delegate];
}

+ (void)addImpressionDataDelegate:(id<ISImpressionDataDelegate>)delegate {
    [[AdQuitManager sharedManager] addImpressionDataDelegate:delegate];
}

@end
