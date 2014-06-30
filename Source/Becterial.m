//
//  Becterial.m
//  becterial
//
//  Created by 李翌文 on 14-6-23.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "Becterial.h"

@implementation Becterial

-(id)init
{
    self = [super init];
    if(self)
    {
        self.newBecterial = YES;
    }
    return self;
}

-(void)setLevel:(int)level
{
	if(_level != level)
	{
		_level = level;
        self.spriteFrame = [CCSpriteFrame frameWithImageNamed:[NSString stringWithFormat:@"resources/%i%i.png", _type, level]];
	}
}

-(Becterial *)clone
{
    Becterial *b = (Becterial *)[CCBReader load:@"Becterial"];
    b.level = self.level;
    b.type = self.type;
    b.positionX = self.positionX;
    b.positionY = self.positionY;
    b.newBecterial = NO;
    b.position = ccp(self.position.x, self.position.y);
    b.anchorPoint = ccp(0.f, 0.f);
    
    return b;
}

//序列化
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:_level forKey:@"level"];
    [aCoder encodeInt:_type forKey:@"type"];
    [aCoder encodeInt:_positionX forKey:@"positionX"];
    [aCoder encodeInt:_positionY forKey:@"positionY"];
}

//反序列化
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.type = [aDecoder decodeIntForKey:@"type"];
        self.level = [aDecoder decodeIntForKey:@"level"];
        self.positionX = [aDecoder decodeIntForKey:@"positionX"];
        self.positionY = [aDecoder decodeIntForKey:@"positionY"];
        self.newBecterial = NO;
    }

    return self;
}

@end
