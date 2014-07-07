//
//  UpgradeViewController.m
//  bacterial
//
//  Created by 李翌文 on 14-7-6.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "UpgradeViewController.h"
#import "UpgradeView.h"
#import "UpgradeItemView.h"
#import "DataStorageManager.h"

#define dataStorageManager [DataStorageManager sharedDataStorageManager]

@interface UpgradeViewController ()

@end

@implementation UpgradeViewController
{
    UpgradeView *upgradeView;
    NSMutableDictionary *itemViews;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        itemViews = [NSMutableDictionary new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    upgradeView = (UpgradeView *)[self view];
    if (dataStorageManager.upgradeConst)
    {
        NSString *name;
        NSArray *levels;
        NSArray *keys = [dataStorageManager.upgradeConst allKeys];
        NSDictionary *item;
        
        CGFloat offsetY = 0.f;
        CGFloat contentSizeWidth = 0.f;
        CGFloat contentSizeHeight = 0.f;
        
        for (NSString *key in keys)
        {
            item = [dataStorageManager.upgradeConst objectForKey:key];
            name = [item objectForKey:@"name"];
            levels = [item objectForKey:@"levels"];
            
            NSNumber *number = [dataStorageManager.upgradeData objectForKey:key];
            int index = 0;
            int nextIndex = 0;
            if(number)
            {
                index = [[dataStorageManager.upgradeData objectForKey:key] intValue];
                index = fmin(5, fmax(0, index));
                nextIndex = fmin(5, fmax(0, index + 1));
            }
            if(index > 0)
            {
                NSDictionary *level = [levels objectAtIndex:index-1];
            }
            NSDictionary *nextLevel = [levels objectAtIndex:nextIndex-1];
            NSString *comment = nextIndex == 0 ? @"无" : [level objectForKey:@"comment"];
            NSString *nextComment = index == 5 ? @"无" : [nextLevel objectForKey:@"comment"];
            int cost = [[nextLevel objectForKey:@"cost"] intValue];
            int rate = [[nextLevel objectForKey:@"rate"] intValue];
            
            NSArray *xibArray = [[NSBundle mainBundle] loadNibNamed:@"UpgradeItemView" owner:nil options:nil];
            UpgradeItemView *item = [xibArray objectAtIndex:0];
            item.upgradeId = key;
            [item.lblName setText:name];
            [item.lblComment setText:[NSString stringWithFormat:@"当前等级:%@", comment]];
            [item.lblNextComment setText:[NSString stringWithFormat:@"下一等级:%@", nextComment]];
            [item.lblNextCost setText:[NSString stringWithFormat:@"Exp消耗:%i", cost]];
            [item.lblNextRate setText:[NSString stringWithFormat:@"成功率:%i%%", rate]];
            NSString *imgPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"upgrade_status%i", index] ofType:@"png"];
            [item.imgStatus setImage:[UIImage imageWithContentsOfFile:imgPath]];
            imgPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"upgrade_level%i", index] ofType:@"png"];
            [item.imgLevel setImage:[UIImage imageWithContentsOfFile:imgPath]];
            [upgradeView.scroller addSubview:item];
            [itemViews setObject:item forKey:key];

            item.backgroundColor = nil;
            item.frame = CGRectMake(0.f, offsetY, item.frame.size.width, item.frame.size.height);
            offsetY = offsetY + item.frame.size.height;
            contentSizeHeight = contentSizeHeight + item.frame.size.height;
            contentSizeWidth = item.frame.size.width;
        }
    }
}

-(void)updateItemViewByUpgradeId:(NSString *)upgradeId level:(int)level
{
    UpgradeItemView *view = [itemViews objectForKey:upgradeId];
    if(view && dataStorageManager.upgradeConst)
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

        [view.lblComment setText:[NSString stringWithFormat:@"当前等级:%@", comment]];
        [view.lblNextComment setText:[NSString stringWithFormat:@"下一等级:%@", nextComment]];
        [view.lblNextCost setText:[NSString stringWithFormat:@"Exp消耗:%i", cost]];
        [view.lblNextRate setText:[NSString stringWithFormat:@"成功率:%i%%", rate]];
        NSString *imgPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"upgrade_status%i", level] ofType:@"png"];
        [item.imgStatus setImage:[UIImage imageWithContentsOfFile:imgPath]];
        imgPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"upgrade_level%i", level] ofType:@"png"];
        [item.imgLevel setImage:[UIImage imageWithContentsOfFile:imgPath]];
    }
}

-(IBAction)btnUpgradeTouch:(id)sender
{
    UpgradeItemView *item = (UpgradeItemView *)sender;
    if(item.upgradeId)
    {
        NSDictionary *constItem = [dataStorageManager.upgradeConst objectForKey:item.upgradeId];
        NSNumber *number = [dataStorageManager.upgradeData objectForKey:item.upgradeId];
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
                [dataStorageManager.upgradeData setObject:newNumber forKey:item.upgradeId];
                [dataStorageManager saveData];

                [self updateItemViewByUpgradeId:item.upgradeId level:index];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
