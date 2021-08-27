//
//  AdQuitUtil.m
//  AdQuitSDK
//
//  Created by Tyler Lacroix on 7/3/21.
//

#import "AdQuitManager.h"
#import "AdQuitUtil.h"
#import <IronSource/IronSource.h>
#import <AFNetworking/AFNetworking.h>
#import <sys/utsname.h>
#import <AdSupport/ASIdentifierManager.h>

@implementation AdQuitUtil

+ (void)ping:(NSString*)event_name withData:(NSDictionary*)data {
    NSString *url = @"https://ads-quit.herokuapp.com/logEvent";
    NSDictionary *parameters;
    
    // set the POST fields
    NSDictionary *dictionary = @{
                     @"event_name": event_name,
                     @"package_name": [[NSBundle mainBundle] bundleIdentifier],
                     @"platform": @"ios",
                     @"os_version": [[UIDevice currentDevice] systemVersion],
                     @"app_version": [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],
                     @"device_id": [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],
                     @"device_brand": @"apple",
                     @"device_model": [self getDeviceModel],
                     @"uuid": [[[UIDevice currentDevice] identifierForVendor] UUIDString],
                     @"user_id": [self fetchUserId],
                     @"timestamp": @((long) [[NSDate date] timeIntervalSince1970] * 1000)
    };
    
    //    NSLog(@"%@",dictionary);
    
    if (data != NULL) {
        NSMutableDictionary *mutableDictionary = [dictionary mutableCopy];     //Make the dictionary mutable to change/add
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                           options:0
                                                             error:&error];

        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        } else {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            mutableDictionary[@"data"] = jsonString;
        }
        parameters = mutableDictionary;
    } else {
        parameters = dictionary;
    }

    // start the POST request
    [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:parameters error:nil];

}

+ (NSString*)getDeviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);

    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

+ (NSString*)fetchUserId {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [standardUserDefaults objectForKey:@"ad_quit_user_id"];

    if (user_id == nil) {
        NSUUID *UUID = [NSUUID UUID];
        NSString* user_id = [UUID UUIDString];
        [standardUserDefaults setObject:user_id forKey:@"ad_quit_user_id"];
        [standardUserDefaults synchronize];
    }

    return user_id;
}

+ (void)pingAdClick:(NSDictionary *)data {
    [AdQuitUtil ping:@"ad_click" withData:data];
}

+ (void)pingAdClose:(NSDictionary *)data {
    [AdQuitUtil ping:@"ad_close" withData:data];
}

+ (void)pingAdImpression:(NSDictionary *)data {
    [AdQuitUtil ping:@"ad_impression" withData:data];
}

+ (void)pingAdReward {
    [AdQuitUtil ping:@"ad_reward" withData:NULL];
}

+ (void)pingAppOpen {
    [AdQuitUtil ping:@"app_open" withData:NULL];
}

+ (void)pingAppBackground {
    [AdQuitUtil ping:@"app_background" withData:NULL];
}

+ (void)pingAppQuit {
    [AdQuitUtil ping:@"app_quit" withData:NULL];
}

+ (void)pingAdInfo:(ISImpressionData *)impressionData {
    [AdQuitUtil ping:@"ad_impression_data" withData:[impressionData all_data]];
}

@end
