//
//  PZLabelScore.m
//  becterial
//
//  Created by 李翌文 on 14-6-28.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "PZLabelScore.h"

@implementation PZLabelScore
{
    CCSpriteBatchNode *spriteSheet;
}

+(id)initWithScore:(int)score fileName:(NSString *)fileName itemWidth:(int)itemWidth itemHeight:(int)itemHeight
{
    PZLabelScore *label = [[PZLabelScore alloc] init];
    label.fileName = fileName;
    label.itemWidth = itemWidth;
    label.itemHeight = itemHeight;
    label.score = score;
    return label;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"number.png"];
        [self addChild:spriteSheet];
        return self;
    }
    return nil;
}

-(void)setPadding:(int)padding
{
    _padding = padding;
    self.score = _score;
}

-(void)setScore:(int)score
{
    if(score == 0)
    {
        _score = score;
        [spriteSheet removeAllChildren];
        
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"number_0.png"];
        CCSprite *numSprite = [CCSprite spriteWithSpriteFrame:frame];
        [numSprite setContentSize:CGSizeMake(_itemWidth, _itemHeight)];
        numSprite.anchorPoint = ccp(0, 0);
        numSprite.position = ccp(0, 0);
        [spriteSheet addChild:numSprite];
        return;
    }
    else if(_score != score)
    {
        _score = score;
        [spriteSheet removeAllChildren];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        while (score)
        {
            int num = score % 10;
            NSNumber *number = [NSNumber numberWithInt:num];
            [arr addObject:number];
            
            score = score / 10;
        }
        
        long count = [arr count];
        CCSpriteFrame *frame;
        NSString *fileName;
        for(long i = count - 1; i >= 0; i--)
        {
            fileName = [NSString stringWithFormat:@"number_%i.png", [[arr objectAtIndex:i] intValue]];
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fileName];
            CCSprite *numSprite = [CCSprite spriteWithSpriteFrame:frame];
            [numSprite setContentSize:CGSizeMake(_itemWidth, _itemHeight)];
            numSprite.anchorPoint = ccp(0, 0);
            numSprite.position = ccp((count - 1 - i) * numSprite.contentSize.width, 0);
            [spriteSheet addChild:numSprite];
        }
    }
}

@end
