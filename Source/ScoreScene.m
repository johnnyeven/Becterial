//
//  ScoreScene.m
//  bacterial
//
//  Created by 李翌文 on 14-6-30.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "define.h"
#import "MainScene.h"
#import "ScoreScene.h"
#import "PZLabelScore.h"
#import "UMSocial.h"
#import "UMSocialScreenShoter.h"
#import "YouMiWall.h"
#import "YouMiPointsManager.h"

#import "CashStoreViewController.h"
#import "UpgradeViewController.h"
#import "DataStorageManager.h"
#import "GameCenterManager.h"

#define dataStorageManagerConfig [DataStorageManager sharedDataStorageManager].config

@implementation ScoreScene
{
    BOOL isR4;
    BOOL _over;
    int _score;
    int _time;
    CGFloat _rate;
    int _exp;
    PZLabelScore *_lblScore;
    PZLabelScore *_lblTime;
    PZLabelScore *_lblRate;
    PZLabelScore *_lblExp;
    CCButton *btnContinue;
    CCButton *btnScoreboard;
}

-(void)didLoadFromCCB
{
    if(iPhone5)
    {
        isR4 = YES;
    }
    else
    {
        isR4 = NO;
    }
    _lblScore = [PZLabelScore initWithScore:0 fileName:@"" itemWidth:14 itemHeight:22];
    _lblScore.anchorPoint = ccp(0.f, 0.f);
    if(isR4)
    {
        _lblScore.position = ccp(24.f, 486.f);
    }
    else
    {
        _lblScore.position = ccp(24.f, 410.f);
    }
    [self addChild:_lblScore];

    _lblTime = [PZLabelScore initWithScore:0 fileName:@"" itemWidth:14 itemHeight:22];
    _lblTime.anchorPoint = ccp(0.f, 0.f);
    if(isR4)
    {
        _lblTime.position = ccp(24.f, 416.f);
    }
    else
    {
        _lblTime.position = ccp(24.f, 340.f);
    }
    [self addChild:_lblTime];
    
    _lblRate = [PZLabelScore initWithScore:0 fileName:@"" itemWidth:14 itemHeight:22];
    _lblRate.anchorPoint = ccp(0.f, 0.f);
    if(isR4)
    {
        _lblRate.position = ccp(24.f, 346.f);
    }
    else
    {
        _lblRate.position = ccp(24.f, 270.f);
    }
    [self addChild:_lblRate];

    _lblExp = [PZLabelScore initWithScore:0 fileName:@"" itemWidth:14 itemHeight:22];
    _lblExp.anchorPoint = ccp(0.f, 0.f);
    if(isR4)
    {
        _lblExp.position = ccp(24.f, 281.f);
    }
    else
    {
        _lblExp.position = ccp(24.f, 205.f);
    }
    [self addChild:_lblExp];
    
    _over = NO;

    if(dataStorageManagerConfig)
    {
        NSDictionary *scoreboardResult = [dataStorageManagerConfig objectForKey:@"score_board"];
        int scoreboard = [[scoreboardResult objectForKey:@"result"] intValue];
        if(scoreboard == 1)
        {
            btnScoreboard.visible = YES;
            int *points = [YouMiPointsManager pointsRemained];
            if(*points > 0)
            {
                [YouMiPointsManager spendPoints:*points];
                [DataStorageManager sharedDataStorageManager].exp = [DataStorageManager sharedDataStorageManager].exp + *points;
                [[DataStorageManager sharedDataStorageManager] saveData];
                
                [self setExp:[DataStorageManager sharedDataStorageManager].exp];
            }
            free(points);
        }
        else
        {
            btnScoreboard.visible = NO;
        }
    }
}

-(void)setOver:(BOOL)over
{
    _over = over;
    btnContinue.visible = !over;
    if (over)
    {
        [[GameCenterManager sharedGameCenterManager] reportScore:_score];
    }
}

-(void)setScore:(int)score
{
    _score = score;
    [_lblScore setScore:score];
}

-(void)setRate:(CGFloat)rate
{
    _rate = rate;
    [_lblRate setScore:rate];
}

-(void)setExp:(int)exp
{
    _exp = exp;
    [_lblExp setScore:exp];
}

-(void)setTime:(int)time
{
    _time = time;
    [_lblTime setScore:time];
}

-(void)showScoreboard
{
    [YouMiWall showOffers:YES didShowBlock:^{
        NSLog(@"有米积分墙已显示");
    } didDismissBlock:^{
        NSLog(@"有米积分墙已退出");
    }];
}

-(void)back
{
    MainScene *main;
    if(isR4)
    {
        main = (MainScene *)[CCBReader load:@"MainScene-r4"];
    }
    else
    {
        main = (MainScene *)[CCBReader load:@"MainScene"];
    }
    CCScene *scene = [CCScene new];
    [scene addChild:main];
    [main reset];
    [[CCDirector sharedDirector] replaceScene:scene];
}

-(void)share
{
    UIImage *screenshot = [[UMSocialScreenShoterCocos2d screenShoter] getScreenShot];
    [UMSocialSnsService presentSnsIconSheetView:(UIViewController *)[CCDirector sharedDirector].view.nextResponder
                                         appKey:@"53b031e856240b128d1615f7"
                                      shareText:@"从IOS发来的测试"
                                     shareImage:screenshot
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,nil]
                                       delegate:nil];
}

-(void)store
{
    CashStoreViewController *storeView;
    if(isR4)
    {
        storeView = [[CashStoreViewController alloc] initWithNibName:@"CashStoreR4View" bundle:nil];
    }
    else
    {
        storeView = [[CashStoreViewController alloc] initWithNibName:@"CashStoreView" bundle:nil];
    }
    [[[CCDirector sharedDirector] view] addSubview:storeView.view];
}

-(void)upgrade
{
    UpgradeViewController *upgradeView;
    if(isR4)
    {
        upgradeView = [[UpgradeViewController alloc] initWithNibName:@"UpgradeR4View" bundle:nil];
    }
    else
    {
        upgradeView = [[UpgradeViewController alloc] initWithNibName:@"UpgradeView" bundle:nil];
    }
    [[[CCDirector sharedDirector] view] addSubview:upgradeView.view];
}

-(void)continueGame
{
    MainScene *main;
    if(isR4)
    {
        main = (MainScene *)[CCBReader load:@"MainScene-r4"];
    }
    else
    {
        main = (MainScene *)[CCBReader load:@"MainScene"];
    }
    CCScene *scene = [CCScene new];
    [scene addChild:main];
    [[CCDirector sharedDirector] replaceScene:scene];
}

@end
