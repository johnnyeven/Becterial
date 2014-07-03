//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "ScoreScene.h"
#import "Becterial.h"
#import "define.h"
#import "PZLabelScore.h"
#import "PZWebManager.h"
#import "CashStoreManager.h"

@implementation MainScene
{
    CCLabelTTF *_lblKillerCount;
    PZLabelScore *_lblScore;
    PZLabelScore *_lblBiomass;
    CCNode *_container;
    NSMutableArray *_becterialContainer;
    NSMutableArray *_becterialList;
    int runningAction;
    int runningTime;

    int bacterialCount;
    int enemyCount;
    CGFloat bacterialBiomass;   //细菌需要消耗的生物质
    CGFloat enemyBiomass;       //入侵病毒产生的生物质
    CGFloat scoreOffset;            //分數增加量
}

-(void)didLoadFromCCB
{
    _lblScore = [PZLabelScore initWithScore:0 fileName:@"" itemWidth:14 itemHeight:22];
    _lblScore.position = ccp(10.f, 415.f);
    [self addChild:_lblScore];

    _lblBiomass = [PZLabelScore initWithScore:0 fileName:@"" itemWidth:14 itemHeight:22];
    _lblBiomass.position = ccp(165.f, 415.f);
    [self addChild:_lblBiomass];

    self.userInteractionEnabled = YES;
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *file = [path stringByAppendingPathComponent:@"product_ids"];
    NSArray *products = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    
    if(!products)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveFromServer:) name:@"requestProductIds" object:nil];
        [[PZWebManager sharedPZWebManager] asyncGetRequest:@"http://www.profzone.net/products/bacterial_product_id.txt" withData:nil];
    }
    else
    {
        [[CashStoreManager sharedCashStoreManager] validateProductIdentifiers:products];
    }
}

-(void)didReceiveFromServer:(NSNotification *)notification
{
    NSDictionary *data = [notification object];
    NSArray *products = [data objectForKey:@"products"];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *file = [path stringByAppendingPathComponent:@"product_ids"];
    NSData *becterials = [NSKeyedArchiver archivedDataWithRootObject:products];
    [becterials writeToFile:file atomically:NO];
    
    [[CashStoreManager sharedCashStoreManager] validateProductIdentifiers:products];
}

-(void)update10PerSecond:(CCTime)delta
{
    CGFloat biomassOffset = enemyBiomass - bacterialBiomass;
    self.biomass = fmax(_biomass + biomassOffset, 0);

    if(_biomass > 0)
    {
        self.score = _score + scoreOffset;
    }
}

-(void)updatePerSecond:(CCTime)delta
{
    runningTime++;
}

-(void)prepareStage
{
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

        [self checkResult];
    }
    else
    {
        _becterialList = [[NSMutableArray alloc] init];
        self.killerCount = 10;
    }
}

-(void)onEnter
{
    [super onEnter];

    [self prepareStage];
    [self schedule:@selector(update10PerSecond:) interval:.1f];
    [self schedule:@selector(updatePerSecond:) interval:1.f];
}

-(void)onExit
{
    [super onExit];

    [self saveGame];
}

-(BOOL)generateBacterial:(int)type
{
    if(type == 0 || type == 1)
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
        
    
        int count = [list count];
        if(count > 0)
        {
            CGPoint position = [[list objectAtIndex:(arc4random() % count)] CGPointValue];
            Becterial *b = [[Becterial alloc] init];
            b.positionX = position.x;
            b.positionY = position.y;
            b.anchorPoint = ccp(0.f, 0.f);
            b.type = type;
            b.level = 1;
            b.position = ccp(position.x * 60.5f, position.y * 60.5f);
            [_container addChild:b];
            
            NSMutableArray *_tmp = [_becterialContainer objectAtIndex:position.x];
            [_tmp replaceObjectAtIndex:position.y withObject:b];
            [_becterialList addObject:b];

            return YES;
        }
    }
    return NO;
}

-(void)moveBecterial:(Becterial *)becterial x:(int)x y:(int)y
{
    NSMutableArray *tmp = [_becterialContainer objectAtIndex:x];
    if([tmp objectAtIndex:y] == [NSNull null])
    {
        [tmp replaceObjectAtIndex:y withObject:becterial];
        tmp = [_becterialContainer objectAtIndex:becterial.positionX];
        [tmp replaceObjectAtIndex:becterial.positionY withObject:[NSNull null]];
        becterial.positionX = x;
        becterial.positionY = y;
//        [self generateBacterial:1];
        
        CCActionMoveTo *aMoveTo = [CCActionMoveTo actionWithDuration:.2f position:ccp(x * 60.5f, y * 60.5f)];
        CCActionCallBlock *aCallBlock = [CCActionCallBlock actionWithBlock:^(void)
        {
            runningAction--;
            if(runningAction == 0)
            {
                if(![self evolution])
                {
                    [self saveGame];
                    [self checkResult];
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
                        if(isEnemy && becterial.type == 0)
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
                        runningAction--;
                        if(runningAction == 0)
                        {
                            if(![self evolution])
                            {
                                [self saveGame];
                                [self checkResult];
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
//            int score = [list count] * other.level * 10 + becterial.level * 10;
//            self.score = self.score + score;

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

-(void)btnGenerateScore
{
    if (_biomass > 0)
    {
        self.biomass = _biomass - 5;
        self.score = _score + 10;
        
        [self saveGame];
    }
}

-(void)btnGenerateBiomass
{
    self.biomass = _biomass + 5;
    [self saveGame];
}

-(void)putNewBacterial
{
    if(_score >= NEW_BACTERIAL_COST && _biomass > 0 && [self generateBacterial:0])
    {
        self.score = _score - NEW_BACTERIAL_COST;
        
        if(![self evolution])
        {
            [self saveGame];
        }
    }
    
    [self checkResult];
}

-(void)putNewEnemy
{
    if(_score >= NEW_ENEMY_COST && [self generateBacterial:1])
    {
        self.score = _score - NEW_ENEMY_COST;

        if(![self evolution])
        {
            [self saveGame];
        }
    }
    
    [self checkResult];
}

-(void)menu
{
    ScoreScene *scoreScene = (ScoreScene *)[CCBReader load:@"ScoreScene"];
    [scoreScene setScore:_score];
    [scoreScene setTime:runningTime];
    CCScene *scene = [CCScene new];
    [scene addChild:scoreScene];
    [[CCDirector sharedDirector] replaceScene:scene];
}

-(void)setScore:(CGFloat)score
{
    if(_score != score)
    {
        _score = score;
        _lblScore.score = score;
    }
}

-(void)setBiomass:(CGFloat)biomass
{
    if(_biomass != biomass)
    {
        _biomass = biomass;
        _lblBiomass.score = biomass;
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
        [self checkResult];
        [self saveGame];
    }
}

-(void)checkResult
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    int bCount = 0;
    int eCount = 0;
    CGFloat bBiomass = 0.f;
    CGFloat eBiomass = 0.f;
    CGFloat bScore = 0.f;
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
            else
            {
                Becterial *b = (Becterial *)[tmp objectAtIndex:j];
                if(b.type == 0)
                {
                    bCount++;
                    bBiomass = bBiomass + BACTERIAL_BIOMASS * b.level;
                    bScore = bScore + BACTERIAL_SCORE * b.level;
                }
                else if(b.type == 1)
                {
                    eCount++;
                    eBiomass = eBiomass + ENEMY_BIOMASS * b.level;
                }
            }
        }
    }

    bacterialCount = bCount;
    enemyCount = eCount;
    bacterialBiomass = bBiomass;
    enemyBiomass = eBiomass;
    scoreOffset = bScore;
    
    int count = [list count];
    if(count == 0)
    {
        ScoreScene *scoreScene = (ScoreScene *)[CCBReader load:@"ScoreScene"];
        [scoreScene setScore:_score];
        CCScene *scene = [CCScene new];
        [scene addChild:scoreScene];
        [[CCDirector sharedDirector] replaceScene:scene];
    }
}

-(void)saveGame
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *file = [path stringByAppendingPathComponent:@"savegame"];
    NSData *becterials = [NSKeyedArchiver archivedDataWithRootObject:_becterialList];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithInt:_score], @"score",
        [NSNumber numberWithInt:_biomass], @"biomass",
        [NSNumber numberWithInt:_killerCount], @"killerCount",
        [NSNumber numberWithInt:bacterialCount], @"bacterialCount",
        [NSNumber numberWithInt:enemyCount], @"enemyCount",
        [NSNumber numberWithFloat:bacterialBiomass], @"bacterialBiomass",
[NSNumber numberWithFloat:enemyBiomass], @"enemyBiomass",
        [NSNumber numberWithFloat:scoreOffset], @"scoreOffset",
        [NSNumber numberWithInt:runningTime], @"runningTime",
                          
        becterials, @"bacterials", nil
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
    self.biomass = [[data objectForKey:@"biomass"] intValue];
    self.killerCount = [[data objectForKey:@"killerCount"] intValue];
    bacterialCount = [[data objectForKey:@"bacterialCount"] intValue];
    enemyCount = [[data objectForKey:@"enemyCount"] intValue];
    bacterialBiomass = [[data objectForKey:@"bacterialBiomass"] floatValue];
    enemyBiomass = [[data objectForKey:@"enemyBiomass"] floatValue];
    scoreOffset = [[data objectForKey:@"scoreOffset"] floatValue];
    _becterialList = [NSKeyedUnarchiver unarchiveObjectWithData:[data objectForKey:@"bacterials"]];
    runningTime = [[data objectForKey:@"runningTime"] intValue];
    if(_becterialList == nil)
    {
        _becterialList = [[NSMutableArray alloc] init];
    }

    return YES;
}

-(void)reset
{
    runningTime = 0;
    self.score = 0;
    self.biomass = 0;
    [_becterialList removeAllObjects];
    [_container removeAllChildren];
    [self saveGame];
    [self prepareStage];
}

@end
