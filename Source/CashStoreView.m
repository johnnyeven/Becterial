//
//  CashStoreView.m
//  bacterial
//
//  Created by 李翌文 on 14-7-1.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "CashStoreView.h"

@implementation CashStoreView

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideLoadingIcon" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideLoadingIcon:) name:@"hideLoadingIcon" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showSuccessView" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSuccessView:) name:@"showSuccessView" object:nil];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(IBAction)closeView:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideLoadingIcon" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showSuccessView" object:nil];
    [self removeFromSuperview];
}

-(IBAction)closeSuccessView:(id)sender
{
    self.successView.hidden = YES;
}

-(void)hideLoadingIcon:(NSNotification *)notification
{
    self.loadingView.hidden = YES;
}

-(void)showSuccessView:(NSNotification *)notification
{
    self.successView.hidden = NO;
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
