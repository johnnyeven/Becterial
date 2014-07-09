//
//  PZWebManager.h
//  bacterial
//
//  Created by 李翌文 on 14-7-2.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@interface PZWebManager : NSObject
<NSURLConnectionDelegate>

@property (nonatomic, retain) CTTelephonyNetworkInfo *networkInfo;

+(PZWebManager *)sharedPZWebManager;
-(NSURLConnection *)asyncGetRequest:(NSString *)url withData:(NSDictionary *)data;
-(NSURLConnection *)asyncPostRequest:(NSString *)url withData:(NSDictionary *)data;
-(void)networkAccessChanged;

@end
