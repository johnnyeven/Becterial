//
//  CashStoreView.h
//  bacterial
//
//  Created by 李翌文 on 14-7-1.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CashStoreView : UIView

@property (nonatomic, retain) IBOutlet UIButton *btnClose;
@property (nonatomic, retain) IBOutlet UIScrollView *scroller;

-(IBAction)closeView:(id)sender;

@end
