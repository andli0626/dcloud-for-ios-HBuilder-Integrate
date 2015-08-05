//
//  GeTuiPush.h
//  GeTuiPush
//
//  Created by X on 14-4-3.
//  Copyright (c) 2014年 io.dcloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GexinSdk.h"
#import "GXSdkError.h"
#import "PGPush.h"

typedef enum {
    SdkStatusStoped,
    SdkStatusStarting,
    SdkStatusStarted
} SdkStatus;

@interface GeTuiPush : NSObject<GexinSdkDelegate> {
    GexinSdk *_gexinPusher;
}
@property (retain, nonatomic) NSString *appKey;
@property (retain, nonatomic) NSString *appSecret;
@property (retain, nonatomic) NSString *appID;
@property (retain, nonatomic) NSString *clientId;
@property (assign, nonatomic) SdkStatus sdkStatus;
@property (assign, nonatomic)id<GexinSdkDelegate> delegate;
+ (GeTuiPush*) sharedGetuiPush;
- (void)startEngine;
- (void)stopEngine;
- (void)registerDeviceToken:(NSString *)deviceToken;
@end

@interface PGGetuiPush : PGPush<GexinSdkDelegate> {
    GeTuiPush *_gexinPusher;
}

- (NSMutableDictionary*)getClientInfoJSObjcet;
- (void) onRegRemoteNotificationsError:(NSError *)error;
- (void) onRevDeviceToken:(NSString *)deviceToken;
- (void) onAppEnterBackground;
- (void) onAppEnterForeground;
@end
