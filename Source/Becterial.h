//
//  Becterial.h
//  becterial
//
//  Created by 李翌文 on 14-6-23.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Becterial : CCSprite

@property (nonatomic) BOOL newBecterial;
@property (nonatomic) BOOL evolution;
@property (nonatomic) int level;
@property (nonatomic) int positionX;
@property (nonatomic) int positionY;

-(Becterial *)clone;

@end
