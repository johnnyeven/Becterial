//
//  Becterial.m
//  becterial
//
//  Created by 李翌文 on 14-6-23.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "Becterial.h"
#import "MainScene.h"
#import "define.h"

@implementation Becterial

-(void)didLoadFromCCB
{
    self.userInteractionEnabled = YES;
    self.newBecterial = YES;
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    MainScene *s = (MainScene *)self.parent.parent;
    if(s.remain > 0 && _level == 0)
    {
        s.current = s.current + 1;
        s.remain = s.remain - 1;
        
        self.level = 1;

        [[NSNotificationCenter defaultCenter] postNotificationName:BECTERIAL_MESSAGE object:self];

        self.newBecterial = NO;
    }
}

-(void)setLevel:(int)level
{
	if(_level != level)
	{
		_level = level;
        self.spriteFrame = [CCSpriteFrame frameWithImageNamed:[NSString stringWithFormat:@"resources/%i.png", level]];
	}
}

-(Becterial *)clone
{
    Becterial *b = (Becterial *)[CCBReader load:@"Becterial"];
    b.level = level;
    b.positionX = positionX;
    b.positionY = positionY;
    b.newBecterial = NO;
    b.position = ccp(self.position.x, self.position.y);
}

@end
