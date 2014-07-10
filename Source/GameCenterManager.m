//
//  CashStoreManager.m
//  bacterial
//
//  Created by 李翌文 on 14-7-2.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CashStoreManager.h"
#import "DataStorageManager.h"

@implementation GameCenterManager

static GameCenterManager *_instance = nil;

+ (GameCenterManager *) sharedGameCenterManager
{
	if(!_instance)
	{
		_instance = [[GameCenterManager alloc] init];
	}

	return _instance;
}

- (BOOL) isGameCenterAvailable
{
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- (void) authenticateLocalPlayer
{
    _localPlayer = [GKLocalPlayer localPlayer];
    //IOS 5.0
    /*
    [localPlayer authenticateWithCompletionHandler:^(NSError *error){
        if (error == nil) {
            //成功处理
            NSLog(@"成功");
            NSLog(@"1--alias--.%@",[GKLocalPlayer localPlayer].alias);
            NSLog(@"2--authenticated--.%d",[GKLocalPlayer localPlayer].authenticated);
            NSLog(@"3--isFriend--.%d",[GKLocalPlayer localPlayer].isFriend);
            NSLog(@"4--playerID--.%@",[GKLocalPlayer localPlayer].playerID);
            NSLog(@"5--underage--.%d",[GKLocalPlayer localPlayer].underage);
        }else {
            //错误处理
            NSLog(@"失败  %@",error);
        }
    }];
    */

    //IOS 6.0
    _localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error)
    {
        if (viewController != nil)
        {
            _authenticated = NO;
            // showAuthenticationDialogWhenReasonable: is an example method name. Create your own method that displays an authentication view when appropriate for your app.
            // [self showAuthenticationDialogWhenReasonable: viewController];
        }
        else if (_localPlayer.isAuthenticated)
        {
            _authenticated = YES;
            //authenticatedPlayer: is an example method name. Create your own method that is called after the loacal player is authenticated.
            // [self authenticatedPlayer: localPlayer];
        }
        else
        {
            _authenticated = NO;
            // [self disableGameCenter];
        }
    };
}

- (void) retrieveFriends
{
   if (_authenticated && _localPlayer.isAuthenticated)
   {
      [_localPlayer loadFriendsWithCompletionHandler:^(NSArray *friendIDs, NSError *error)
      {
         if (friendIDs != nil)
         {
            // [self loadPlayerData: friendIDs];
         }
      }];
   }
}

- (void) loadPlayerData: (NSArray *) identifiers
{
    [GKPlayer loadPlayersForIdentifiers:identifiers withCompletionHandler:^(NSArray *players, NSError *error)
    {
        if (error != nil)
        {
            // Handle the error.
        }
        if (players != nil)
        {
            // Process the array of GKPlayer objects.
        }
     }];
}

- (void) loadPlayerPhoto: (GKPlayer*) player
{
    [player loadPhotoForSize:GKPhotoSizeSmall withCompletionHandler:^(UIImage *photo, NSError *error)
    {
        if (photo != nil)
        {
            // [self storePhoto: photo forPlayer: player];
        }
        if (error != nil)
        {
            // Handle the error if necessary.
        }
    }];
}

- (void) loadDefaultLeaderboard
{
    [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:
    ^(NSString *leaderboardIdentifier, NSError *error)
    {
        _leaderboardIdentifier = leaderboardIdentifier;
    }]
}

- (void) reportScore: (int64_t) score forLeaderboardID: (NSString*) identifier
{
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: identifier];
    scoreReporter.shouldSetDefaultLeaderboard = YES;
    scoreReporter.value = score;
    scoreReporter.context = 0;
 
    NSArray *scores = @[scoreReporter];
    [GKLeaderboard reportScores:scores withCompletionHandler:^(NSError *error)
    {
    }];
}

- (void) showLeaderboard: (NSString*) leaderboardID
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
       gameCenterController.gameCenterDelegate = self;
       gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
       gameCenterController.leaderboardTimeScope = GKLeaderboardTimeScopeToday;
       gameCenterController.leaderboardCategory = leaderboardID;
       // [self presentViewController: gameCenterController animated: YES completion:nil];
    }
}

@end