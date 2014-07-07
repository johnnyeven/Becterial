//
//  UpgradeItemView.m
//  bacterial
//
//  Created by 李翌文 on 14-7-6.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "UpgradeItemView.h"
#import "DataStorageManager.h"

#define dataStorageManager [DataStorageManager sharedDataStorageManager]

@implementation UpgradeItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)updateItemViewByUpgradeId:(NSString *)upgradeId level:(int)level
{
    if(dataStorageManager.upgradeConst)
    {
        NSDictionary *item = [dataStorageManager.upgradeConst objectForKey:upgradeId];
        NSArray *levels = [item objectForKey:@"levels"];
        level = fmin(5, fmax(0, level));
        int nextLevel = fmin(5, fmax(0, level + 1));
        
        NSDictionary *current = [levels objectAtIndex:level - 1];
        NSDictionary *next = [levels objectAtIndex:nextLevel - 1];
        
        NSString *comment = nextLevel == 0 ? @"无" : [current objectForKey:@"comment"];
        NSString *nextComment = [next objectForKey:@"comment"];
        int cost = [[next objectForKey:@"cost"] intValue];
        int rate = [[next objectForKey:@"rate"] intValue];
        
        [self.lblComment setText:[NSString stringWithFormat:@"当前等级:%@", comment]];
        [self.lblNextComment setText:[NSString stringWithFormat:@"下一等级:%@", nextComment]];
        [self.lblNextCost setText:[NSString stringWithFormat:@"Exp消耗:%i", cost]];
        [self.lblNextRate setText:[NSString stringWithFormat:@"成功率:%i%%", rate]];
        NSString *imgPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"upgrade_status%i", level] ofType:@"png"];
        [self.imgStatus setImage:[UIImage imageWithContentsOfFile:imgPath]];
        imgPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"upgrade_level%i", level] ofType:@"png"];
        [self.imgLevel setImage:[UIImage imageWithContentsOfFile:imgPath]];
    }
}

-(IBAction)btnUpgradeTouch:(id)sender
{
	if(self.upgradeId)
	{
		NSDictionary *constItem = [dataStorageManager.upgradeConst objectForKey:self.upgradeId];
        NSArray *levels = [constItem objectForKey:@"levels"];
        NSNumber *number = [dataStorageManager.upgradeData objectForKey:self.upgradeId];
		int index = 0;
        if(number)
        {
        	index = [number intValue];
            index = fmin(5, fmax(0, index));
            if(index == 5)
            {
            	return;
            }
        }
        int nextIndex = fmin(5, fmax(0, index + 1));
        NSDictionary *nextLevel = [levels objectAtIndex:nextIndex-1];
        int cost = [[nextLevel objectForKey:@"cost"] intValue];
        int rate = [[nextLevel objectForKey:@"rate"] intValue];

        if(dataStorageManager.exp >= cost)
        {
        	//经验满足
        	int r = arc4random() % 100;
        	if(r < rate)
        	{
        		//改造成功
        		dataStorageManager.exp = dataStorageManager.exp - cost;
        		index++;
        		NSNumber *newNumber = [NSNumber numberWithInt:index];
        		[dataStorageManager.upgradeData setObject:newNumber forKey:self.upgradeId];
        		[dataStorageManager saveData];
                [dataStorageManager loadData];
                
                [self updateItemViewByUpgradeId:self.upgradeId level:index];
        	}
        }
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
