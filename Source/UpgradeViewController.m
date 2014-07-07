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
            int nextIndex = 1;
            if(number)
            {
                index = [[dataStorageManager.upgradeData objectForKey:key] intValue];
                index = fmin(5, fmax(0, index));
                nextIndex = fmin(5, fmax(0, index + 1));
            }
            NSDictionary *level;
            if(index > 0)
            {
                level = [levels objectAtIndex:index-1];
            }
            NSDictionary *nextLevel = [levels objectAtIndex:nextIndex-1];
            NSString *comment = index == 0 ? @"无" : [level objectForKey:@"comment"];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
