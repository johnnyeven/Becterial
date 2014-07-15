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
        //进入第二步，介绍不同的细菌
        self.step++;
        container.position = ccp(13.f, 103.f);
    }
    else if (_step == 2)
    {
        //进入第三步，首先生成生物质
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
        //准备进入第四步，判断是否点击了生成生物质的按钮
        CGPoint position = touch.locationInWorld;
        if (position.x > 160 && position.x < 310 &&
            position.y > 410 && position.y < 440)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"guideClickBiomass" object:nil];
        }
    }
    else if (_step == 4)
    {
        //准备进入第五步，判断是否点击了生成生物酶的按钮
        CGPoint position = touch.locationInWorld;
        if (position.x > 10 && position.x < 290 &&
            position.y > 410 && position.y < 440)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"guideClickScore" object:nil];
        }
    }
    else if (_step == 5)
    {
        //准备进入第六步，判断是否点击了放置红色细菌的按钮
        CGPoint position = touch.locationInWorld;
        if (position.x > 88 && position.x < 149 &&
            position.y > 319 && position.y < 380)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"guideClickEnemy" object:nil];
        }
    }
    else if (_step == 6)
    {
        //准备进入第七步，判断是否点击了放置褐色细菌的按钮
        CGPoint position = touch.locationInWorld;
        if (position.x > 6 && position.x < 67 &&
            position.y > 319 && position.y < 380)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"guideClickBacterial" object:nil];
        }
    }
    else if (_step == 7)
    {
        //准备进入第八步，判断是否点击了生成生物质的按钮/生成生物酶的按钮/放置红色细菌的按钮
        CGPoint position = touch.locationInWorld;
        if (position.x > 160 && position.x < 310 &&
            position.y > 410 && position.y < 440)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"guideClickBiomass2" object:nil];
        }
        else if (position.x > 10 && position.x < 290 &&
            position.y > 410 && position.y < 440)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"guideClickScore2" object:nil];
        }
        else if (position.x > 6 && position.x < 67 &&
            position.y > 319 && position.y < 380)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"guideClickEnemy2" object:nil];
        }
    }
    else if (_step == 8)
    {
        //准备进入第九步，判断是否点击了生成生物质的按钮/生成生物酶的按钮/放置红色细菌的按钮/放置褐色细菌的按钮
        CGPoint position = touch.locationInWorld;
        if (position.x > 160 && position.x < 310 &&
            position.y > 410 && position.y < 440)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"guideClickBiomass2" object:nil];
        }
        else if (position.x > 10 && position.x < 290 &&
            position.y > 410 && position.y < 440)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"guideClickScore2" object:nil];
        }
        else if (position.x > 6 && position.x < 67 &&
            position.y > 319 && position.y < 380)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"guideClickEnemy3" object:nil];
        }
        else if (position.x > 6 && position.x < 67 &&
            position.y > 319 && position.y < 380)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"guideClickBacterial2" object:nil];
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
    else if(_step == 4)
    {
        container.position = ccp(13.f, 103.f);
        if(isR4)
        {
            
        }
        else
        {
            arrow.visible = YES;
            arrow.position = ccp(80.f, 410.f);
        }
        mask.visible = NO;
    }
    else if(_step == 5)
    {
        //干得好，下面我们首先要放置红色的产生生物质的细菌，这会消耗20单位的生物酶
        arrow.spriteFrame = [CCSpriteFrame frameWithImageNamed:@"resources/guide_circle.png"];
        container.position = ccp(13.f, 103.f);
        if(isR4)
        {
            
        }
        else
        {
            arrow.visible = YES;
            arrow.position = ccp(118.f, 347.f);
        }
        mask.visible = NO;
    }
    else if(_step == 6)
    {
        //下面我们来放置褐色的产生生物酶的细菌，这会消耗10单位的生物酶
        arrow.spriteFrame = [CCSpriteFrame frameWithImageNamed:@"resources/guide_circle.png"];
        container.position = ccp(13.f, 103.f);
        if(isR4)
        {
            
        }
        else
        {
            arrow.visible = YES;
            arrow.position = ccp(41.f, 347.f);
        }
        mask.visible = NO;
    }
    else if(_step == 7)
    {
        //Cool 下面让我们来做更多的事情，首先再放置两个更多的红色细菌，如果生物酶不够那就想想我们第一步做了什么
        arrow.visible = NO;
        container.position = ccp(13.f, 103.f);
        if(isR4)
        {
            
        }
        else
        {
            arrow.visible = YES;
            arrow.position = ccp(41.f, 347.f);
        }
        mask.visible = NO;
    }
    else if(_step == 8)
    {
        //好了吧？再放置两个更多的褐色细菌，如果生物酶不够那就想想我们第一步做了什么
        arrow.visible = NO;
        container.position = ccp(13.f, 103.f);
        if(isR4)
        {
            
        }
        else
        {
            arrow.visible = YES;
            arrow.position = ccp(41.f, 347.f);
        }
        mask.visible = NO;
    }
    else if(_step == 9)
    {
        //好了？唔，看来你并不需要我的帮助，好了，下面用你灵巧的手指移动褐色细菌，让任意细菌周围存在2个或以上的相同等级细菌，像那样
        arrow.visible = NO;
        container.position = ccp(13.f, 103.f);
        if(isR4)
        {
            
        }
        else
        {
            arrow.visible = YES;
            arrow.position = ccp(41.f, 347.f);
        }
        mask.visible = NO;
    }
}

@end
