//
//  CashStoreItemView.m
//  bacterial
//
//  Created by 李翌文 on 14-7-1.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "CashStoreItemView.h"
#import "CashStoreManager.h"
#import "CashStoreView.h"

@implementation CashStoreItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(IBAction)btnBuyTouched:(id)sender
{
    [[CashStoreManager sharedCashStoreManager] purchaseProduct:_identifier];
    CashStoreView *v = (CashStoreView *)self.superview.superview;
    v.loadingView.hidden = NO;
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
