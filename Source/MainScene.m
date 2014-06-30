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
#import "PZLabelScore.h"

@implementation MainScene
{
    CCLabelTTF *_lblKillerCount;
    PZLabelScore *_lblScore;
    PZLabelScore *_lblRemain;
    PZLabelScore *_lblCurrent;
    CCNode *_container;
    NSMutableArray *_becterialContainer;
    NSMutableArray *_becterialList;
    int runningAction;
}

-(void)didLoadFromCCB
{
    _remain = 1000;
    _current = 0;
    
    _lblScore = [PZLabelScore initWithScore:0 fileName:@"" itemWidth:14 itemHeight:22];
    _lblScore.position = ccp(10.f, 415.f);
    [self addChild:_lblScore];
    
    _lblCurrent = [PZLabelScore initWithScore:0 fileName:@"" itemWidth:14 itemHeight:22];
    _lblCurrent.position = ccp(169.f, 368.f);
    [self addChild:_lblCurrent];
    
    _lblRemain = [PZLabelScore initWithScore:1000 fileName:@"" itemWidth:14 itemHeight:22];
    _lblRemain.position = ccp(169.f, 334.f);
    [self addChild:_lblRemain];
    
    self.killerCount = 10;
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
    
    if([self loadGame])
    {
        for (int i = 0; i < [_becterialList count]; i++)
        {
            Becterial *b = [_becterialList objectAtIndex:i];
            b.anchorPoint = ccp(0.f, 0.f);
            NSMutableArray *tmp = [_becterialContainer objectAtIndex:b.positionX];
            [tmp replaceObjectAtIndex:b.positionY withObject:b];
            b.position = ccp(b.positionX * 60.5f, b.positionY * 60.5f);
            [_container addChild:b];
        }
    }
    else
    {
        _becterialList = [[NSMutableArray alloc] init];
    }
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
        
        Becterial *_b = [[Becterial alloc] init];
        _b.anchorPoint = ccp(0.f, 0.f);
        _b.positionX = x;
        _b.positionY = y;
        _b.level = 1;
        _b.position = ccp(x * 60.5f, y * 60.5f);
        [_container addChild:_b];

        NSMutableArray *_tmp = [_becterialContainer objectAtIndex:x];
        [_tmp replaceObjectAtIndex:y withObject:_b];
        [_becterialList addObject:_b];
        
        [self checkEnemy];
        [self onBecterialTouched];
        
        self.current = [_becterialList count];
        self.score = self.score + 1;
    }
}

-(void)checkEnemy
{
    if ((arc4random() % 100) < 30)
    {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (int i = 0; i < [_becterialContainer count]; i++)
        {
            NSMutableArray *tmp = [_becterialContainer objectAtIndex:i];
            for (int j = 0; j < [tmp count]; j++)
            {
                if([tmp objectAtIndex:j] == [NSNull null])
                {
                    CGPoint p = ccp(i, j);
                    [list addObject:[NSValue valueWithCGPoint:p]];
                }
            }
        }
        
        CGPoint position = [[list objectAtIndex:(arc4random() % [list count])] CGPointValue];
        Becterial *enemy = [[Becterial alloc] init];
        enemy.positionX = position.x;
        enemy.positionY = position.y;
        enemy.anchorPoint = ccp(0.f, 0.f);
        enemy.type = 1;
        enemy.level = 1;
        enemy.position = ccp(position.x * 60.5f, position.y * 60.5f);
        [_container addChild:enemy];
        
        NSMutableArray *_tmp = [_becterialContainer objectAtIndex:position.x];
        [_tmp replaceObjectAtIndex:position.y withObject:enemy];
        [_becterialList addObject:enemy];
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
                if(![self evolution])
                {
                    [self saveGame];
                }
            }
        }];
        [becterial runAction:[CCActionSequence actionWithArray:@[aMoveTo, aCallBlock]]];
        runningAction++;
    }
}

-(BOOL)isEvolution:(Becterial *)becterial
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
        BOOL isEnemy = NO;
        
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
                        if(other.type == 1)
                        {
                            isEnemy = YES;
                        }
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
                        if(isEnemy)
                        {
                            NSMutableArray *tmp = [_becterialContainer objectAtIndex:becterial.positionX];
                            [tmp replaceObjectAtIndex:becterial.positionY withObject:[NSNull null]];
                            [_becterialList removeObjectIdenticalTo:becterial];
                            [_container removeChild:becterial];
                        }
                        else
                        {
                            becterial.level++;
                        }
                        self.current = [_becterialList count];
                        runningAction--;
                        if(runningAction == 0)
                        {
                            if(![self evolution])
                            {
                                [self saveGame];
                            }
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
            int score = [list count] * other.level * 10 + becterial.level * 10;
            self.score = self.score + score;

            return YES;
        }
    }
    return NO;
}

-(BOOL)evolution
{
    BOOL result = YES;
    for(int i = 0; i < [_becterialList count]; i++)
    {
        Becterial *b = [_becterialList objectAtIndex:i];
        if(![self isEvolution:b])
        {
            result = NO;
        }
    }
    return result;
}

-(void)reset
{
    
}

-(void)back
{
    
}

-(void)setScore:(int)score
{
    if(_score != score)
    {
        _score = score;
        _lblScore.score = score;
    }
}

-(void)setCurrent:(int)current
{
    if(_current != current)
    {
        _current = current;
        _lblCurrent.score = current;
    }
}

-(void)setRemain:(int)remain
{
    if(_remain != remain)
    {
        _remain = remain;
        _lblRemain.score = remain;
    }
}

-(void)setKillerCount:(int)killerCount
{
    if(_killerCount != killerCount)
    {
        _killerCount = killerCount;
        [_lblKillerCount setString:[NSString stringWithFormat:@"%i", killerCount]];
    }
}

-(CCNode *)container
{
    return _container;
}

-(void)useKiller:(int)x andY:(int)y
{
    if([[_becterialContainer objectAtIndex:x] objectAtIndex:y] == [NSNull null])
    {
        return;
    }
    
    Becterial *b = [[_becterialContainer objectAtIndex:x] objectAtIndex:y];
    if(b.type == 1)
    {
        NSMutableArray *tmp = [_becterialContainer objectAtIndex:x];
        [tmp replaceObjectAtIndex:y withObject:[NSNull null]];
        [_becterialList removeObjectIdenticalTo:b];
        [_container removeChild:b];
        self.killerCount--;
        self.current = [_becterialList count];

        [self saveGame];
    }
}

-(void)saveGame
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *file = [path stringByAppendingPathComponent:@"savegame"];
    NSData *becterials = [NSKeyedArchiver archivedDataWithRootObject:_becterialList];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithInt:_score], @"score",
        [NSNumber numberWithInt:_current], @"current",
        [NSNumber numberWithInt:_remain], @"remain",
        [NSNumber numberWithInt:_killerCount], @"killerCount",
        becterials, @"becterials", nil
    ];
    [data writeToFile:file atomically:NO];
}

-(BOOL)loadGame
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *file = [path stringByAppendingPathComponent:@"savegame"];
    NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:file];
    
    if(data == nil)
    {
        return NO;
    }
    
    self.score = [[data objectForKey:@"score"] intValue];
    self.current = [[data objectForKey:@"current"] intValue];
    self.remain = [[data objectForKey:@"remain"] intValue];
    self.killerCount = [[data objectForKey:@"killerCount"] intValue];
    _becterialList = [NSKeyedUnarchiver unarchiveObjectWithData:[data objectForKey:@"becterials"]];

    return YES;
}

@end
