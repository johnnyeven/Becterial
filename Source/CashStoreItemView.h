//
//  CashStoreItemView.h
//  bacterial
//
//  Created by 李翌文 on 14-7-1.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CashStoreItemView : UIView

@property (nonatomic, retain) IBOutlet UILabel *itemName;
@property (nonatomic, retain) IBOutlet UILabel *itemComment;
@property (nonatomic, retain) IBOutlet UILabel *itemCash;
@property (nonatomic, retain) IBOutlet UIButton *btnBuy;
@property (nonatomic, retain) IBOutlet UIImageView *imgIcon;

@end
