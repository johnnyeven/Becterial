//
//  Becterial.m
//  becterial
//
//  Created by 李翌文 on 14-6-23.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "Becterial.h"
#import "MainScene.h"

static const NSString BecterialTouched = @"Becterial.BecterialTouched";

@implementation Becterial

@synthesize newBecterial;
@synthesize level;
@synthesize positionX;
@synthesize positionY;

-(void)didLoadFromCCB
{
    self.userInteractionEnabled = YES;
    self.newBecterial = YES;
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    MainScene *s = (MainScene *)self.parent.parent;
    if(s.remain > 0 && level == 0)
    {
        s.current = s.current + 1;
        s.remain = s.remain - 1;
        
        // self.spriteFrame = [CCSpriteFrame frameWithImageNamed:@"resources/1.png"];
        self.level = 1;

        [[NSNotificationCenter defaultCenter] postNotificationName:BecterialTouched object:self];

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

@end
