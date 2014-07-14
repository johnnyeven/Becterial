//
//  Guide.m
//  bacterial
//
//  Created by 李翌文 on 14-7-13.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "define.h"
#import "Guide.h"
#import "DataStorageManager.h"

@implementation Guide
{
    BOOL isR4;
    CCNode *container;
    CCSprite *imgStep;
    CCSprite *arrow;
    CCSprite *mask;
}

-(void)didLoadFromCCB
{
    self.userInteractionEnabled = YES;
    isR4 = iPhone5;
    arrow = [CCSprite node];
    [self addChild:arrow];
    arrow.spriteFrame = [CCSpriteFrame frameWithImageNamed:@"resources/guide_arrow.png"];
    arrow.visible = NO;
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (_step == 1)
    {
        self.step++;
        container.position = ccp(13.f, 103.f);
    }
    else if (_step == 2)
    {
        self.step++;
        if(isR4)
        {
            
        }
        else
        {
            arrow.visible = YES;
            arrow.position = ccp(240.f, 410.f);
        }
        mask.visible = NO;
    }
    else if (_step == 3)
    {
        CGPoint position = touch.locationInWorld;
        if (position.x > 160 && position.x < 310 &&
            position.y > 410 && position.y < 440)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"guideClickBiomass" object:nil];
        }
    }
    [DataStorageManager sharedDataStorageManager].guideStep = _step;
    [[DataStorageManager sharedDataStorageManager] saveData];
}

-(void)setStep:(int)step
{
    step = fmax(1, step);
    _step = step;
    
    imgStep.spriteFrame = [CCSpriteFrame frameWithImageNamed:[NSString stringWithFormat:@"resources/guide_step%i.png", _step]];
    if (_step == 2)
    {
        if(isR4)
        {
            
        }
        else
        {
            container.position = ccp(13.f, 103.f);
        }
    }
    else if(_step == 3)
    {
        container.position = ccp(13.f, 103.f);
        if(isR4)
        {
            
        }
        else
        {
            arrow.visible = YES;
            arrow.position = ccp(240.f, 410.f);
        }
        mask.visible = NO;
    }
}

@end
