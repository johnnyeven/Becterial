/*
 * SpriteBuilder: http://www.spritebuilder.org
 *
 * Copyright (c) 2012 Zynga Inc.
 * Copyright (c) 2013 Apportable Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "cocos2d.h"
#import "MobClick.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"

#import "AppDelegate.h"
#import "Becterial.h"
#import "CCBuilderReader.h"
#import "CashStorePaymentObserver.h"
#import "PZWebManager.h"
#import "CashStoreManager.h"
#import "DataStorageManager.h"

#import <StoreKit/StoreKit.h>

@implementation AppController

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Configure Cocos2d with the options set in SpriteBuilder
    NSString* configPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Published-iOS"]; // TODO: add support for Published-Android support
    configPath = [configPath stringByAppendingPathComponent:@"configCocos2d.plist"];
    
    NSMutableDictionary* cocos2dSetup = [NSMutableDictionary dictionaryWithContentsOfFile:configPath];
    
    // Note: this needs to happen before configureCCFileUtils is called, because we need apportable to correctly setup the screen scale factor.
#ifdef APPORTABLE
    if([cocos2dSetup[CCSetupScreenMode] isEqual:CCScreenModeFixed])
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenAspectFitEmulationMode];
    else
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenScaledAspectFitEmulationMode];
#endif
    
    // Configure CCFileUtils to work with SpriteBuilder
    [CCBReader configureCCFileUtils];
    
    // Do any extra configuration of Cocos2d here (the example line changes the pixel format for faster rendering, but with less colors)
    //[cocos2dSetup setObject:kEAGLColorFormatRGB565 forKey:CCConfigPixelFormat];
    
    [self setupCocos2dWithOptions:cocos2dSetup];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[CashStorePaymentObserver sharedCashStorePaymentObserver]];
    
    [MobClick startWithAppkey:@"53b031e856240b128d1615f7"];
    [UMSocialData setAppKey:@"53b031e856240b128d1615f7"];
    [UMSocialWechatHandler setWXAppId:@"wxfa1868e8028fdf80" url:nil];
    
//    [MobClick setLogEnabled:YES];
    
    [[DataStorageManager sharedDataStorageManager] loadConfig];
    if(![DataStorageManager sharedDataStorageManager].config)
    {
        [DataStorageManager sharedDataStorageManager].config = [NSMutableDictionary new];
        [[DataStorageManager sharedDataStorageManager] saveConfig];
    }
    else
    {
        NSDictionary *products = [[DataStorageManager sharedDataStorageManager].config objectForKey:@"products"];
        if (!products)
        {
            //没有就去苹果请求
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveFromServer:) name:@"requestProductIds" object:nil];
            [[PZWebManager sharedPZWebManager] asyncGetRequest:@"https://b.profzone.net/configuration/product_id" withData:nil];
        }
        else
        {
            //有就直接使用
        }
    }
    
    return YES;
}

-(void)didReceiveFromServer:(NSNotification *)notification
{
    NSDictionary *data = [notification object];
    NSArray *products = [data objectForKey:@"products"];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *file = [path stringByAppendingPathComponent:@"product_ids"];
    NSData *becterials = [NSKeyedArchiver archivedDataWithRootObject:products];
    [becterials writeToFile:file atomically:NO];
    
    [[CashStoreManager sharedCashStoreManager] validateProductIdentifiers:products];
}

- (CCScene*) startScene
{
    [[DataStorageManager sharedDataStorageManager] loadData];
    NSDictionary *upgradeConst = [DataStorageManager sharedDataStorageManager].upgradeConst;
    NSMutableDictionary *upgradeData = [DataStorageManager sharedDataStorageManager].upgradeData;
    NSArray *keys = [upgradeData allKeys];
    for(NSString *key in keys)
    {
        int index = [[upgradeData objectForKey:key] intValue];
        NSDictionary *item = [upgradeConst objectForKey:key];
        if(item)
        {
            NSArray *levels = [item objectForKey:@"levels"];
            NSDictionary *level = [levels objectAtIndex:index-1];
            NSDictionary *additional = [level objectForKey:@"additional"];
            NSArray *adds = [additional allKeys];
            for(NSString *add in adds)
            {
                if([add isEqualToString:@"upgradeScoreInc"])
                {
                    [Becterial setUpgradeScoreInc:[[additional objectForKey:add] floatValue]];
                }
            }
        }
    }

    [[CCDirector sharedDirector] setDisplayStats:YES];
    return [CCBReader loadAsScene:@"MainScene"];
}

@end
