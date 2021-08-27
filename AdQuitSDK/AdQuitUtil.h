//
//  AdQuitUtil.h
//  AdQuitSDK
//
//  Created by Tyler Lacroix on 7/3/21.
//

#import <Foundation/Foundation.h>
#import <IronSource/IronSource.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdQuitUtil : NSObject

+ (void)pingAdClick:(NSDictionary *)data;
+ (void)pingAdClose:(NSDictionary *)data;
+ (void)pingAdImpression:(NSDictionary *)data;
+ (void)pingAdReward;
+ (void)pingAppOpen;
+ (void)pingAppBackground;
+ (void)pingAppQuit;
+ (void)pingAdInfo:(ISImpressionData *)impressionData;

@end

NS_ASSUME_NONNULL_END
