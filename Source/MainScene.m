//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Becterial.h"
#import "define.h"
#import <CCLabelAtlas.h>

@implementation MainScene
{
    CCLabelAtlas *_lblScore;
    CCLabelAtlas *_lblRemain;
    CCLabelAtlas *_lblCurrent;
    CCNode *_container;
    NSMutableArray *_becterialContainer;
    NSMutableArray *_becterialList;
    int runningAction;
}

-(void)didLoadFromCCB
{
    _remain = 1000;
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
    [_lblRemain setString:@"1000"];

    self.userInteractionEnabled = YES;
}

-(void)onEnter
{
    [super onEnter];
    
    int capacity = 5;
    _becterialContainer = [NSMutableArray arrayWithCapacity:capacity];
    for (int i = 0; i < capacity; i++)
    {
        NSMutableArray *_tmp = [NSMutableArray arrayWithCapacity:capacity];
        for (int j = 0; j < capacity; j++)
        {
            [_tmp addObject:[NSNull null]];
        }
        [_becterialContainer addObject:_tmp];
    }
    _becterialList = [[NSMutableArray alloc] init];
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint position = [touch locationInWorld];
    position = [_container convertToNodeSpace:position];

    int x = position.x / 60.5f;
    int y = position.y / 60.5f;
    
    if (x > 4 || y > 4)
    {
        return;
    }
    
    if(runningAction == 0 && [[_becterialContainer objectAtIndex:x] objectAtIndex:y] == [NSNull null])
    {
        self.remain = _remain - 1;
        
        Becterial *_b = (Becterial *)[CCBReader load:@"Becterial"];
        _b.anchorPoint = ccp(0.f, 0.f);
        _b.positionX = x;
        _b.positionY = y;
        _b.level = 1;
        _b.position = ccp(x * 60.5f, y * 60.5f);
        [_container addChild:_b];

        NSMutableArray *_tmp = [_becterialContainer objectAtIndex:x];
        [_tmp replaceObjectAtIndex:y withObject:_b];
        [_becterialList addObject:_b];

        [self onBecterialTouched];
        
        self.current = [_becterialList count];
    }
}

-(void)onBecterialTouched
{
    Becterial *_becterial;
    for(int i = 0; i < [_becterialList count]; i++)
    {
        _becterial = [_becterialList objectAtIndex:i];
        if(!_becterial.newBecterial)
        {
            [self moveBecterial:_becterial];
        }
        else
        {
            _becterial.newBecterial = NO;
        }
    }
}

-(void)moveBecterial:(Becterial *)becterial
{
    int startX = fmin(fmax(becterial.positionX - 1, 0), 4);
    int endX = fmin(fmax(becterial.positionX + 1, 0), 4);
    int startY = fmin(fmax(becterial.positionY - 1, 0), 4);
    int endY = fmin(fmax(becterial.positionY + 1, 0), 4);
    NSMutableArray *list = [[NSMutableArray alloc] init];

    for(int i = startX; i <= endX; i++)
    {
        for(int j = startY; j <= endY; j++)
        {
            if((i != becterial.positionX || j != becterial.positionY) &&
               [[_becterialContainer objectAtIndex:i] objectAtIndex:j] == [NSNull null])
            {
                CGPoint position = ccp(i, j);
                [list addObject:[NSValue valueWithCGPoint:position]];
            }
        }
    }

    int count = [list count];
    if(count > 0)
    {
        CGPoint p = [(NSValue *)[list objectAtIndex:(arc4random() % count)] CGPointValue];
        [[_becterialContainer objectAtIndex:p.x] replaceObjectAtIndex:p.y withObject:becterial];
        [[_becterialContainer objectAtIndex:becterial.positionX] replaceObjectAtIndex:becterial.positionY withObject:[NSNull null]];
        becterial.positionX = p.x;
        becterial.positionY = p.y;

        CCActionMoveTo *aMoveTo = [CCActionMoveTo actionWithDuration:.2f position:ccp(p.x * 60.5f, p.y * 60.5f)];
        CCActionCallBlock *aCallBlock = [CCActionCallBlock actionWithBlock:^(void)
        {
            runningAction--;
            if(runningAction == 0)
            {
                [self evolution];
            }
        }];
        [becterial runAction:[CCActionSequence actionWithArray:@[aMoveTo, aCallBlock]]];
        runningAction++;
    }
}

-(void)isEvolution:(Becterial *)becterial
{
    if (becterial.level > 0)
    {
        int startX = fmin(fmax(becterial.positionX - 1, 0), 4);
        int endX = fmin(fmax(becterial.positionX + 1, 0), 4);
        int startY = fmin(fmax(becterial.positionY - 1, 0), 4);
        int endY = fmin(fmax(becterial.positionY + 1, 0), 4);
        Becterial *other;
        NSMutableArray *list = [[NSMutableArray alloc] init];
        int count = 0;
        
        for(int i = startX; i <= endX; i++)
        {
            for(int j = startY; j <= endY; j++)
            {
                if((i != becterial.positionX || j != becterial.positionY) &&
                   [[_becterialContainer objectAtIndex:i] objectAtIndex:j] != [NSNull null])
                {
                    other = [[_becterialContainer objectAtIndex:i] objectAtIndex:j];
                    if(other.level == becterial.level)
                    {
                        count++;
                        [list addObject:other];
                    }
                }
            }
        }
        
        if(count >= 2)
        {
            BOOL isCallback = NO;
            for(int m = 0; m < [list count]; m++)
            {
                other = [list objectAtIndex:m];
                [[_becterialContainer objectAtIndex:other.positionX] replaceObjectAtIndex:other.positionY withObject:[NSNull null]];

                CCActionMoveTo *aMoveTo = [CCActionMoveTo actionWithDuration:.2f position:ccp(becterial.position.x, becterial.position.y)];
                CCActionRemove *aRemove = [CCActionRemove action];
                if(!isCallback)
                {
                    CCActionCallBlock *aCallBlock = [CCActionCallBlock actionWithBlock:^(void)
                    {
                        self.remain++;
                        becterial.level++;
                        self.current = [_becterialList count];
                        runningAction--;
                        if(runningAction == 0)
                        {
                            [self evolution];
                        }
                    }];
                    isCallback = YES;
                    [other runAction:[CCActionSequence actionWithArray:@[aMoveTo, aRemove, aCallBlock]]];
                    runningAction++;
                }
                else
                {
                    [other runAction:[CCActionSequence actionWithArray:@[aMoveTo, aRemove]]];
                }
                [_becterialList removeObjectIdenticalTo:other];
            }
        }
    }
}

-(void)evolution
{
    for(int i = 0; i < [_becterialList count]; i++)
    {
        Becterial *b = [_becterialList objectAtIndex:i];
        [self isEvolution:b];
    }
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
