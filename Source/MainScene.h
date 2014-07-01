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

-(void)prepareStage;
-(void)onBecterialTouched;
-(void)generateEnemy;
-(void)moveBecterial:(Becterial *)becterial x:(int)x y:(int)y;
-(BOOL)isEvolution:(Becterial *)becterial;
-(BOOL)evolution;
-(CCNode *)container;
-(void)useKiller:(int)x andY:(int)y;
-(void)saveGame;
-(BOOL)loadGame;
-(void)checkResult;

@end
