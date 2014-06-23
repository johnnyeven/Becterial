//
//  Becterial.m
//  becterial
//
//  Created by 李翌文 on 14-6-23.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "Becterial.h"
#import "MainScene.h"

@implementation Becterial

-(void)didLoadFromCCB
{
    self.userInteractionEnabled = YES;
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    MainScene *s = (MainScene *)self.parent.parent;
    if(s.remain > 0)
    {
        s.current = s.current + 1;
        s.remain = s.remain - 1;
        
        self.spriteFrame = [CCSpriteFrame frameWithImageNamed:@"resources/1.png"];
    }
}

@end
