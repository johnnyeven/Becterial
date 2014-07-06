//
//  DataStorageManager.m
//  bacterial
//
//  Created by 李翌文 on 14-7-4.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "DataStorageManager.h"

@implementation DataStorageManager

static DataStorageManager *_sharedDataStorageManager;

+(DataStorageManager *)sharedDataStorageManager
{
    if(!_sharedDataStorageManager)
    {
        _sharedDataStorageManager = [[DataStorageManager alloc] init];
    }
    return _sharedDataStorageManager;
}

-(void)saveData
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *file = [path stringByAppendingPathComponent:@"savedata"];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInt:_exp], @"exp",
                          [NSNumber numberWithInt:_killerCount], @"killerCount", nil
                          ];
    [data writeToFile:file atomically:NO];
}

-(BOOL)loadData
{
    //load upgrade const data
    NSString *upgradeConstFilePath = [[NSBundle mainBundle] pathForResource:@"upgrade_const" ofType:@"plist"];
    self.upgradeConst = [[NSDictionary alloc] initWithContentsOfFile:upgradeConstFilePath];
    
    //load game data
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *file = [path stringByAppendingPathComponent:@"savedata"];
    NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:file];
    
    if(data == nil)
    {
        return NO;
    }
    
    self.exp = [[data objectForKey:@"exp"] intValue];
    self.killerCount = [[data objectForKey:@"killerCount"] intValue];
    
    //load upgrade data
    path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    file = [path stringByAppendingPathComponent:@"saveupgradedata"];
    self.upgradeData = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
    
    if(self.upgradeData == nil)
    {
        self.upgradeData = [NSMutableDictionary new];
    }
    
    return YES;
}

@end
