//
//  AdQuitManager.m
//  AdQuitSDK
//
//  Created by Tyler Lacroix on 6/26/21.
//

#import "AdQuitManager.h"
#import "AdQuitUtil.h"

@implementation AdQuitManager

@synthesize interstitial_delegate;
@synthesize rewarded_video_delegate;
NSString* const adSdk = @"ironSource";
NSString* const rewardedVideoAdFormat = @"rewarded_video";
NSString* const interstitialAdFormat = @"interstitial";

+ (id)sharedManager {
    static AdQuitManager *sharedAdQuitManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAdQuitManager = [[self alloc] init];
    });
    return sharedAdQuitManager;
}

- (void)setInterstitialDelegate:(id<ISInterstitialDelegate>)delegate {
    interstitial_delegate = delegate;
}

- (void)setRewardedVideoDelegate:(id<ISRewardedVideoDelegate>)delegate {
    rewarded_video_delegate = delegate;
}

- (id)init {
  if (self = [super init]) {
      [IronSource setInterstitialDelegate:self];
      [IronSource setRewardedVideoDelegate:self];
      [IronSource addImpressionDataDelegate:self];
    
      [[NSNotificationCenter defaultCenter]addObserver:self
                                              selector:@selector(applicationDidBecomeActive:)
                                                   name:UIApplicationDidBecomeActiveNotification
                                                 object:nil];
      [[NSNotificationCenter defaultCenter]addObserver:self
                                                  selector:@selector(applicationDidEnterBackground:)
                                                       name:UIApplicationDidEnterBackgroundNotification
                                                     object:nil];
      [[NSNotificationCenter defaultCenter]addObserver:self
                                              selector:@selector(applicationWillTerminate:)
                                                       name:UIApplicationWillTerminateNotification
                                                     object:nil];
  }
  return self;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive");
    /* This somehow fires on the initial app open, but this is weird because by the time
     the SDK is initialized, we should've missed the hook. */

    [AdQuitUtil pingAppOpen];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"applicationDidEnterBackground");
    [AdQuitUtil pingAppBackground];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"applicationWillTerminate");
    // This never sends because it loses the thread.
    [AdQuitUtil pingAppQuit];
}

- (void)dealloc {
  // Should never be called, but just here for clarity really.
}

- (void)didClickInterstitial {
    if (interstitial_delegate) {
        [interstitial_delegate didClickInterstitial];
    }
    NSDictionary *data = @{
        @"ad_format": interstitialAdFormat,
        @"ad_sdk": adSdk,
    };
    [AdQuitUtil pingAdClick:data];
}

- (void)interstitialDidClose {
    if (interstitial_delegate) {
        [interstitial_delegate interstitialDidClose];
    }
    NSDictionary *data = @{
        @"ad_format": interstitialAdFormat,
        @"ad_sdk": adSdk,
    };
    [AdQuitUtil pingAdClose:data];
}

- (void)interstitialDidFailToLoadWithError:(NSError *)error {
    if (interstitial_delegate) {
        [interstitial_delegate interstitialDidFailToLoadWithError:error];
    }
}

- (void)interstitialDidFailToShowWithError:(NSError *)error {
    if (interstitial_delegate) {
        [interstitial_delegate interstitialDidFailToShowWithError:error];
    }
}

- (void)interstitialDidLoad {
    if (interstitial_delegate) {
        [interstitial_delegate interstitialDidLoad];
    }
}

- (void)interstitialDidOpen {
    if (interstitial_delegate) {
        [interstitial_delegate interstitialDidOpen];
    }
    NSDictionary *data = @{
        @"ad_format": interstitialAdFormat,
        @"ad_sdk": adSdk,
    };
    [AdQuitUtil pingAdImpression:data];
}

- (void)interstitialDidShow {
    if (interstitial_delegate) {
        [interstitial_delegate interstitialDidShow];
    }
}

- (void)impressionDataDidSucceed:(ISImpressionData *)impressionData {
    NSLog(@"impressionDataDidSucceed");
    /*
     (auction_id: 220ef491-f418-11eb-9f6a-15b5027feb00_1651161720, ad_unit: interstitial, ad_network: ironsource, instance_name: Bidding, instance_id: 4928464, country: US, placement: DefaultInterstitial, revenue: 0.01988, precision: BID, ab: A, segment_name: (null), lifetime_revenue: 0.04614, encrypted_cpm: (null), conversion_value: (null))
    */
    [AdQuitUtil pingAdInfo:impressionData];
}

- (void)didClickRewardedVideo:(ISPlacementInfo *)placementInfo {
    if (rewarded_video_delegate) {
        [rewarded_video_delegate didClickRewardedVideo:placementInfo];
    }
    
    NSDictionary *data = @{
        @"ad_format": rewardedVideoAdFormat,
        @"ad_sdk": adSdk,
    };
    [AdQuitUtil pingAdClick:data];
}

- (void)didReceiveRewardForPlacement:(ISPlacementInfo *)placementInfo {
    if (rewarded_video_delegate) {
        [rewarded_video_delegate didReceiveRewardForPlacement:placementInfo];
    }

    [AdQuitUtil pingAdReward];
}

- (void)rewardedVideoDidClose {
    if (rewarded_video_delegate) {
        [rewarded_video_delegate rewardedVideoDidClose];
    }
    NSDictionary *data = @{
        @"ad_format": rewardedVideoAdFormat,
        @"ad_sdk": adSdk,
    };
    [AdQuitUtil pingAdClose:data];
}

- (void)rewardedVideoDidEnd {
    if (rewarded_video_delegate) {
        [rewarded_video_delegate rewardedVideoDidEnd];
    }
}

- (void)rewardedVideoDidFailToShowWithError:(NSError *)error {
    if (rewarded_video_delegate) {
        [rewarded_video_delegate rewardedVideoDidFailToShowWithError:error];
    }
}

- (void)rewardedVideoDidOpen {
    if (rewarded_video_delegate) {
        [rewarded_video_delegate rewardedVideoDidOpen];
    }
    NSLog(@"IN REWARDED VIDEO DID OPEN");
    NSDictionary *data = @{
        @"ad_format": rewardedVideoAdFormat,
        @"ad_sdk": adSdk,
    };
    [AdQuitUtil pingAdImpression:data];
}

- (void)rewardedVideoDidStart {
    if (rewarded_video_delegate) {
        [rewarded_video_delegate rewardedVideoDidStart];
    }
}

- (void)rewardedVideoHasChangedAvailability:(BOOL)available {
    if (rewarded_video_delegate) {
        [rewarded_video_delegate rewardedVideoHasChangedAvailability:available];
    }
}

@end
