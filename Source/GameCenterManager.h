//
//  GameCenterManager.h
//  bacterial
//
//  Created by 李翌文 on 14-6-23.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GKLocalPlayer;

@interface GameCenterManager : NSObject
<GKGameCenterControllerDelegate>

@property (nonatomic) BOOL authenticated;
@property (nonatomic, retain) GKLocalPlayer *localPlayer;
@property (nonatomic, retain) NSString *leaderboardIdentifier;

+ (GameCenterManager *) sharedGameCenterManager;
- (BOOL) isGameCenterAvailable;
- (void) authenticateLocalPlayer;
- (void) retrieveFriends;
- (void) loadPlayerData: (NSArray *) identifiers;
- (void) loadDefaultLeaderboard;
- (void) reportScore: (int64_t) score forLeaderboardID: (NSString*) identifier;
- (void) showLeaderboard: (NSString*) leaderboardID;

@end
