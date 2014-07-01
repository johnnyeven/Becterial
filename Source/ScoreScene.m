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

@implementation ScoreScene
{
    int _score;
    PZLabelScore *_lblScore;
}

-(void)didLoadFromCCB
{
    _lblScore = [PZLabelScore initWithScore:0 fileName:@"" itemWidth:14 itemHeight:22];
    _lblScore.anchorPoint = ccp(.5f, .5f);
    _lblScore.positionType = CCPositionTypeNormalized;
    _lblScore.position = ccp(.5f, .6f);
    [self addChild:_lblScore];
}

-(void)setScore:(int)score
{
    _score = score;
    [_lblScore setScore:score];
    _lblScore.position = ccp(.5f, .6f);
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

@end
