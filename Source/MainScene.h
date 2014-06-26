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

@property (nonatomic) int current;
@property (nonatomic) int remain;

-(void)onBecterialTouched;
-(void)moveBecterial:(Becterial *)becterial;
-(BOOL)isEvolution:(Becterial *)becterial;
-(void)evolution;

@end
