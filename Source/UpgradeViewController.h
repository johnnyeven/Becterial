//
//  UpgradeViewController.h
//  bacterial
//
//  Created by 李翌文 on 14-7-6.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpgradeViewController : UIViewController

-(void)updateItemViewByUpgradeId:(NSString *)upgradeId level:(int)level;

-(IBAction)btnUpgradeTouch:(id)sender;

@end
