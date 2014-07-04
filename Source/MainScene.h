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

@property (nonatomic) CGFloat score;
@property (nonatomic) CGFloat biomass;
@property (nonatomic) int exp;
@property (nonatomic) int killerCount;

-(void)deliverProduct:(NSNotification *)notification;
-(void)update10PerSecond:(CCTime)delta;
-(void)updatePerSecond:(CCTime)delta;
-(void)prepareStage;
-(BOOL)generateBacterial:(int)type;
-(void)moveBecterial:(Becterial *)becterial x:(int)x y:(int)y;
-(BOOL)isEvolution:(Becterial *)becterial;
-(BOOL)evolution;
-(CCNode *)container;
-(void)useKiller:(int)x andY:(int)y;
-(void)saveGame;
-(BOOL)loadGame;
-(void)checkResult;
-(void)reset;

@end
