//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Becterial.h"
#import <CCLabelAtlas.h>

@implementation MainScene
{
    CCLabelAtlas *_lblScore;
    CCLabelAtlas *_lblRemain;
    CCLabelAtlas *_lblCurrent;
    CCNode *_container;
    NSMutableArray *_becterialContainer;
}

-(void)didLoadFromCCB
{
    _remain = 10;
    _current = 0;
    
    _lblScore = [CCLabelAtlas labelWithString:@"0" charMapFile:@"resources/number_combine.png" itemWidth:14 itemHeight:22 startCharMap:'0'];
    _lblScore.position = ccp(10.f, 415.f);
    [self addChild:_lblScore];
    [_lblScore setString:@"0"];
    
    _lblCurrent = [CCLabelAtlas labelWithString:@"0" charMapFile:@"resources/number_combine.png" itemWidth:14 itemHeight:22 startCharMap:'0'];
    _lblCurrent.position = ccp(169.f, 368.f);
    [self addChild:_lblCurrent];
    [_lblCurrent setString:@"0"];
    
    _lblRemain = [CCLabelAtlas labelWithString:@"0" charMapFile:@"resources/number_combine.png" itemWidth:14 itemHeight:22 startCharMap:'0'];
    _lblRemain.position = ccp(169.f, 334.f);
    [self addChild:_lblRemain];
    [_lblRemain setString:@"10"];
}

-(void)onEnter
{
    [super onEnter];
    
    _becterialContainer = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++)
    {
        NSMutableArray *_tmp = [[NSMutableArray alloc] init];
        for (int j = 0; j < 5; j++)
        {
            Becterial *_b = (Becterial *)[CCBReader load:@"Becterial"];
            _b.anchorPoint = ccp(0.f, 0.f);
            _b.positionX = i;
            _b.positionY = j;
            _b.level = 0;
            _b.spriteFrame = [CCSpriteFrame frameWithImageNamed:@"resources/0.png"];
            _b.position = ccp(i * 60.5f, j * 60.5f);
            [_tmp addObject:_b];
            [_container addChild:_b];
        }
    }
}

-(void)update:(CCTime)delta
{
    
}

-(void)reset
{
    
}

-(void)back
{
    
}

-(void)setCurrent:(int)current
{
    if(_current != current)
    {
        _current = current;
        [_lblCurrent setString:[NSString stringWithFormat:@"%i", _current]];
    }
}

-(void)setRemain:(int)remain
{
    if(_remain != remain)
    {
        _remain = remain;
        [_lblRemain setString:[NSString stringWithFormat:@"%i", _remain]];
    }
}

@end
