//
//  CashStoreViewController.m
//  bacterial
//
//  Created by 李翌文 on 14-7-1.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "CashStoreViewController.h"
#import "CashStoreView.h"
#import "CashStoreItemView.h"
#import "CashStoreManager.h"
#import "CashStorePaymentObserver.h"
#import "DataStorageManager.h"
#import <StoreKit/StoreKit.h>

#define sharedCashStoreManager [CashStoreManager sharedCashStoreManager]

@interface CashStoreViewController ()

@end

@implementation CashStoreViewController
{
    CashStoreView *cashStoreView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    cashStoreView = (CashStoreView *)self.view;
    cashStoreView.loadingView.hidden = YES;
    CGFloat offsetY = 0.f;
    CGFloat contentSizeWidth = 0.f;
    CGFloat contentSizeHeight = 0.f;
    if(sharedCashStoreManager.products)
    {
        for (SKProduct *product in sharedCashStoreManager.products)
        {
            NSArray *xibArray = [[NSBundle mainBundle] loadNibNamed:@"CashStoreItemView" owner:nil options:nil];
            CashStoreItemView *item = [xibArray objectAtIndex:0];
            item.identifier = product.productIdentifier;
            [item.itemName setText:product.localizedTitle];
            [item.itemComment setText:product.localizedDescription];
            [item.itemCash setText:product.price.stringValue];
            [cashStoreView.scroller addSubview:item];
            item.backgroundColor = nil;
            item.frame = CGRectMake(0.f, offsetY, item.frame.size.width, item.frame.size.height);
            offsetY = offsetY + item.frame.size.height;
            contentSizeHeight = contentSizeHeight + item.frame.size.height;
            contentSizeWidth = item.frame.size.width;
        }
    }
    else
    {
        NSDictionary *config = [DataStorageManager sharedDataStorageManager].config;
        NSDictionary *productsResult = [config objectForKey:@"products"];
        NSArray *products = [productsResult objectForKey:@"result"];
        if (!products)
        {
            //取默认plist
            NSString *file = [[NSBundle mainBundle] pathForResource:@"products" ofType:@"plist"];
            products = [[NSArray alloc] initWithContentsOfFile:file];
        }
        for (NSDictionary *product in products)
        {
            NSArray *xibArray = [[NSBundle mainBundle] loadNibNamed:@"CashStoreItemView" owner:nil options:nil];
            CashStoreItemView *item = [xibArray objectAtIndex:0];
            item.identifier = [product objectForKey:@"productIdentifier"];
            [item.itemName setText:[product objectForKey:@"localizedTitle"]];
            [item.itemComment setText:[product objectForKey:@"localizedDescription"]];
            [item.itemCash setText:[product objectForKey:@"price"]];
            [cashStoreView.scroller addSubview:item];
            item.backgroundColor = nil;
            item.frame = CGRectMake(0.f, offsetY, item.frame.size.width, item.frame.size.height);
            offsetY = offsetY + item.frame.size.height;
            contentSizeHeight = contentSizeHeight + item.frame.size.height;
            contentSizeWidth = item.frame.size.width;
        }
    }
    cashStoreView.scroller.contentSize = CGSizeMake(contentSizeWidth, contentSizeHeight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
