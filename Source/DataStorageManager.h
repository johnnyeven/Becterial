//
//  DataStorageManager.h
//  bacterial
//
//  Created by 李翌文 on 14-7-4.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStorageManager : NSObject

@property (nonatomic) int killerCount;
@property (nonatomic) int exp;
@property (nonatomic, retain) NSDictionary *upgradeConst;
@property (nonatomic, retain) NSMutableDictionary *upgradeData;
@property (nonatomic, retain) NSMutableDictionary *config;

+(DataStorageManager *)sharedDataStorageManager;
-(void)saveData;
-(BOOL)loadData;
-(void)saveConfig;
-(void)loadConfig;

@end
