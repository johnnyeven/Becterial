//
//  UpgradeItemView.m
//  bacterial
//
//  Created by 李翌文 on 14-7-6.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "UpgradeItemView.h"

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

-(IBAction)btnUpgradeTouch:(id)sender
{
	if(self.upgradeId)
	{
		NSDictionary *constItem = [dataStorageManager.upgradeConst objectForKey:self.upgradeId];
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
