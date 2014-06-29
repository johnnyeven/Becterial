//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Becterial.h"

@interface MainScene : CCNode

@property (nonatomic) int score;
@property (nonatomic) int current;
@property (nonatomic) int remain;
@property (nonatomic) int killerCount;

-(void)onBecterialTouched;
-(void)checkEnemy;
-(void)moveBecterial:(Becterial *)becterial;
-(void)isEvolution:(Becterial *)becterial;
-(void)evolution;
-(CCNode *)container;
-(void)useKiller:(int)x andY:(int)y;

@end
