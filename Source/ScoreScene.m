//
//  ScoreScene.m
//  bacterial
//
//  Created by 李翌文 on 14-6-30.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "ScoreScene.h"
#import "PZLabelScore.h"

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
    
}

-(void)share
{
    
}

@end
