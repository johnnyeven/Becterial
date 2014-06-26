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
        // for (int j = 0; j < capacity; j++)
        // {
        //     Becterial *_b = (Becterial *)[CCBReader load:@"Becterial"];
        //     _b.anchorPoint = ccp(0.f, 0.f);
        //     _b.positionX = i;
        //     _b.positionY = j;
        //     _b.level = 0;
        //     _b.spriteFrame = [CCSpriteFrame frameWithImageNamed:@"resources/0.png"];
        //     _b.position = ccp(i * 60.5f, j * 60.5f);
        //     [_tmp addObject:_b];
        //     [_container addChild:_b];
        // }
        [_becterialContainer addObject:_tmp];
    }

    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBecterialTouched:) name:BECTERIAL_MESSAGE object:nil];
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint position = [touch locationInWorld];
    position = [[CCDirector sharedDirector] convertToGL:position];
    position = [_container convertToNodeSpace:position];

    int x = position.x / 60.5f;
    int y = position.y / 60.5f;

    Becterial *_b = (Becterial *)[CCBReader load:@"Becterial"];
    _b.anchorPoint = ccp(0.f, 0.f);
    _b.positionX = x;
    _b.positionY = y;
    _b.level = 1;
    _b.position = ccp(x * 60.5f, y * 60.5f);
    [_container addChild:_b];

    NSMutableArray *_tmp = [_becterialContainer objectAtIndex:x];
    [_tmp replaceObjectAtIndex:y withObject:_b];

    [self onBecterialTouched];
}

-(void)onBecterialTouched
{
    Becterial *_becterial;
    NSMutableArray *_tmp;

    for(int i = 0; i < [_becterialContainer count]; i++)
    {
        _tmp = [_becterialContainer objectAtIndex:i];
        for(int j = 0; j < [_tmp count]; j++)
        {
            _becterial = [_tmp objectAtIndex:j];

            if(_becterial)
            {
                if(!_becterial.newBecterial)
                {
//                  [self moveBecterial:_becterial];
                    [self isEvolution:_becterial];
                }
                else
                {
                    _becterial.newBecterial = NO;
                }
            }
        }
    }
}

-(void)moveBecterial:(Becterial *)becterial
{
    int startX = fmin(fmax(becterial.positionX - 1, 0), 4);
    int endX = fmin(fmax(becterial.positionX + 1, 0), 4);
    int startY = fmin(fmax(becterial.positionY - 1, 0), 4);
    int endY = fmin(fmax(becterial.positionY + 1, 0), 4);
    Becterial *other;
    NSMutableArray *list = [[NSMutableArray alloc] init];

    for(int i = startX; i <= endX; i++)
    {
        for(int j = startY; j <= endY; j++)
        {
            other = [[_becterialContainer objectAtIndex:i] objectAtIndex:j];
            if(!other)
            {
                CGPoint position = ccp(i, j);
                [list addObject:position];
            }
        }
    }

    int count = [list count];
    if(count > 0)
    {
        CGPoint *p = [list objectAtIndex:(arc4random() % count)];
        [[_becterialContainer objectAtIndex:becterial.positionX] replaceObjectAtIndex:becterial.positionY withObject:null];
        [[_becterialContainer objectAtIndex:p.x] replaceObjectAtIndex:p.y withObject:becterial];
        becterial.positionX = p.x;
        becterial.positionY = p.y;

        CCActionMoveTo *aMoveTo = [CCActionMoveTo actionWithDuration:.2f position:ccp(p.x * 60.5f, p.y * 60.5f)];
        CCActionCallBlock *aCallBlock = [CCActionCallBlock actionWithBlock:^(void)
        {
            [self isEvolution:becterial];
        }];
        [becterial runAction:[CCActionSequence actionWithArray:@[aMoveTo, aCallBlock]]];
    }
}

-(BOOL)isEvolution:(Becterial *)becterial
{
    NSLog(@"x=%i, y=%i", becterial.positionX, becterial.positionY);
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
                if(i != becterial.positionX || j != becterial.positionY)
                {
                    other = [[_becterialContainer objectAtIndex:i] objectAtIndex:j];
                    if(other && other.level == becterial.level)
                    {
                        count++;
                        [list addObject:other];
                    }
                }
            }
        }
        
        if(count >= 2)
        {
            Becterial *tmp;
            BOOL isCallback = NO;
            for(int m = 0; m < [list count]; m++)
            {
                other = [list objectAtIndex:m];
                [[_becterialContainer objectAtIndex:other.positionX] replaceObjectAtIndex:other.positionY withObject:null];
                // tmp = [other clone];
                // [_container addChild:tmp];
                // other.level = 0;

                CCActionMoveTo *aMoveTo = [CCActionMoveTo actionWithDuration:.2f position:ccp(becterial.position.x, becterial.position.y)];
                CCActionRemove *aRemove = [CCActionRemove action];
                if(!isCallback)
                {
                    CCActionCallBlock *aCallBlock = [CCActionCallBlock actionWithBlock:^(void)
                    {
                        self.remain++;
                        becterial.level++;
                        for(int i = startX; i <= endX; i++)
                        {
                            for(int j = startY; j <= endY; j++)
                            {
                                Becterial *other = [[_becterialContainer objectAtIndex:i] objectAtIndex:j];
                                [self isEvolution:other];
                            }
                        }
                        NSLog(@"callback");
                    }];
                    isCallback = YES;
                    [other runAction:[CCActionSequence actionWithArray:@[aMoveTo, aRemove, aCallBlock]]];
                }
                else
                {
                    [other runAction:[CCActionSequence actionWithArray:@[aMoveTo, aRemove]]];
                }
            }
            return YES;
        }
    }
    return NO;
}

-(void)becterialMoveCallback
{

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
