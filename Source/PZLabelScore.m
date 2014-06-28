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
    NSMutableArray *numberSpriteArr;
}

+(id)initWithScore:(int)score fileName:(NSString *)fileName itemWidth:(int)itemWidth itemHeight:(int)itemHeight
{
    PZLabelScore *label = [[PZLabelScore alloc] init];
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
        numberSpriteArr = [[NSMutableArray alloc] init];
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
        [self removeAllChildren];
        [numberSpriteArr removeAllObjects];
        
        NSString *fileName = [NSString stringWithFormat:@"number/number_%i.png", 0];
        CCSprite *numSprite = [CCSprite spriteWithImageNamed:fileName];
        [numSprite setContentSize:CGSizeMake(_itemWidth, _itemHeight)];
        numSprite.anchorPoint = ccp(0, 0);
        numSprite.position = ccp(0, 0);
        [numberSpriteArr addObject:numSprite];
        [self addChild:numSprite];
        return;
    }
    if(_score != score)
    {
        _score = score;
        [self removeAllChildren];
        [numberSpriteArr removeAllObjects];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        while (score)
        {
            int num = score % 10;
            NSNumber *number = [NSNumber numberWithInt:num];
            [arr addObject:number];
            
            score = score / 10;
        }
        
        int count = [arr count];
        for(int i = count - 1; i >= 0; i--)
        {
            NSString *fileName = [NSString stringWithFormat:@"number/number_%i.png", [[arr objectAtIndex:i] intValue]];
            CCSprite *numSprite = [CCSprite spriteWithImageNamed:fileName];
            [numSprite setContentSize:CGSizeMake(_itemWidth, _itemHeight)];
            numSprite.anchorPoint = ccp(0, 0);
            numSprite.position = ccp((count - 1 - i) * numSprite.contentSize.width, 0);
            [numberSpriteArr addObject:numSprite];
            [self addChild:numSprite];
        }
    }
}

@end
