//
//  ScoreScene.m
//  bacterial
//
//  Created by 李翌文 on 14-6-30.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "ScoreScene.h"
#import "PZLabelScore.h"
#import "UMSocial.h"

#import "CashStoreViewController.h"

@implementation ScoreScene
{
    BOOL _over;
    int _score;
    int _time;
    PZLabelScore *_lblScore;
    PZLabelScore *_lblTime;
    CCButton *btnContinue;
}

-(void)didLoadFromCCB
{
    _lblScore = [PZLabelScore initWithScore:0 fileName:@"" itemWidth:14 itemHeight:22];
    _lblScore.anchorPoint = ccp(0.f, 0.f);
    _lblScore.position = ccp(24.f, 385.f);
    [self addChild:_lblScore];

    _lblTime = [PZLabelScore initWithScore:0 fileName:@"" itemWidth:14 itemHeight:22];
    _lblTime.anchorPoint = ccp(0.f, 0.f);
    _lblTime.position = ccp(24.f, 305.f);
    [self addChild:_lblTime];
    
    _over = NO;
}

-(void)setOver:(BOOL)over
{
    _over = over;
    btnContinue.visible = !over;
}

-(void)setScore:(int)score
{
    _score = score;
    [_lblScore setScore:score];
}

-(void)setTime:(int)time
{
    _time = time;
    [_lblTime setScore:time];
}

-(void)back
{
    MainScene *main = (MainScene *)[CCBReader load:@"MainScene"];
    CCScene *scene = [CCScene new];
    [scene addChild:main];
    [main reset];
    [[CCDirector sharedDirector] replaceScene:scene];
}

-(void)share
{
    [UMSocialSnsService presentSnsIconSheetView:(UIViewController *)[CCDirector sharedDirector].view.nextResponder
                                         appKey:@"53b031e856240b128d1615f7"
                                      shareText:@"从IOS发来的测试"
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,nil]
                                       delegate:nil];
}

-(void)store
{
    CashStoreViewController *storeView = [[CashStoreViewController alloc] initWithNibName:@"CashStoreView" bundle:nil];
    [[[CCDirector sharedDirector] view] addSubview:storeView.view];
}

-(void)upgrade
{

}

-(void)continueGame
{
    MainScene *main = (MainScene *)[CCBReader load:@"MainScene"];
    CCScene *scene = [CCScene new];
    [scene addChild:main];
    [[CCDirector sharedDirector] replaceScene:scene];
}

@end
